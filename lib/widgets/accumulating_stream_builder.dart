import 'dart:async';

import 'package:flutter/material.dart';

/// A StreamBuilder that accumulates string chunks from a stream
/// and displays the accumulated text progressively.
///
/// This is useful for streaming text from LLMs where chunks are sent
/// incrementally but you want to display the full accumulated text.
class AccumulatingStreamBuilder extends StatefulWidget {
  /// The stream of string chunks to accumulate
  final Stream<String> stream;

  /// Builder function that receives the accumulated text
  final Widget Function(BuildContext context, String accumulatedText) builder;

  /// Optional initial value to start with
  final String initialValue;

  /// Optional widget to show while waiting for first chunk
  final Widget? loadingWidget;

  /// Optional widget to show on error
  final Widget Function(BuildContext context, Object error)? errorBuilder;

  const AccumulatingStreamBuilder({
    super.key,
    required this.stream,
    required this.builder,
    this.initialValue = '',
    this.loadingWidget,
    this.errorBuilder,
  });

  @override
  State<AccumulatingStreamBuilder> createState() =>
      _AccumulatingStreamBuilderState();
}

class _AccumulatingStreamBuilderState extends State<AccumulatingStreamBuilder> {
  // Global cache to track stream subscriptions across widget rebuilds
  static final Map<Stream, _StreamSubscriptionInfo> _streamCache = {};

  _StreamSubscriptionInfo? _info;
  Stream<String>? _uiStream;

  @override
  void initState() {
    super.initState();
    _setupStream();
  }

  @override
  void didUpdateWidget(AccumulatingStreamBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If stream instance changed, switch to the new one
    if (!identical(oldWidget.stream, widget.stream)) {
      _setupStream();
    }
  }

  @override
  void dispose() {
    // We do NOT remove from cache here, because we want the subscription
    // to survive navigation (widget dispose/rebuild).
    _info = null;
    super.dispose();
  }

  void _setupStream() {
    // Check if we already have a subscription for this exact stream instance
    if (_streamCache.containsKey(widget.stream)) {
      _info = _streamCache[widget.stream]!;
    } else {
      // Create new subscription info for this stream
      _info = _StreamSubscriptionInfo(widget.stream, widget.initialValue);
      _streamCache[widget.stream] = _info!;
    }

    _uiStream = _info!.stream;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: _uiStream,
      initialData: widget.initialValue.isNotEmpty ? widget.initialValue : null,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          if (widget.errorBuilder != null) {
            return widget.errorBuilder!(context, snapshot.error!);
          }
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return widget.loadingWidget ?? const SizedBox.shrink();
        }

        return widget.builder(context, snapshot.data!);
      },
    );
  }
}

/// Tracks subscription information for a stream instance
class _StreamSubscriptionInfo {
  Stream<String>? sourceStream;
  final StreamController<String> _controller =
      StreamController<String>.broadcast();
  final StringBuffer buffer;
  StreamSubscription<String>? _subscription;
  bool _isDone = false;
  Object? _error;

  _StreamSubscriptionInfo(this.sourceStream, String initialValue)
    : buffer = StringBuffer(initialValue) {
    _subscribe();
  }

  Stream<String> get stream {
    // Return a stream that starts with the current accumulated value
    // This ensures new listeners get the full text immediately
    if (_isDone) {
      if (_error != null) return Stream.error(_error!);
      return Stream.value(buffer.toString());
    }

    return _getStreamWithCurrent();
  }

  Stream<String> _getStreamWithCurrent() async* {
    // Emit current buffer first
    yield buffer.toString();
    // Then emit updates from the controller
    yield* _controller.stream;
  }

  void _subscribe() {
    if (sourceStream == null) return;

    _subscription = sourceStream!.listen(
      (chunk) {
        buffer.write(chunk);
        if (!_controller.isClosed) {
          _controller.add(buffer.toString());
        }
      },
      onError: (error) {
        _error = error;
        _isDone = true;
        if (!_controller.isClosed) {
          _controller.addError(error);
        }
        _cleanupSource();
      },
      onDone: () {
        _isDone = true;
        if (!_controller.isClosed) {
          _controller.close();
        }
        _cleanupSource();
      },
      cancelOnError: false,
    );
  }

  void _cleanupSource() {
    _subscription?.cancel();
    _subscription = null;
    // Release reference to source stream to allow GC (if possible)
    sourceStream = null;
  }
}
