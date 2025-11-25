import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
// animations removed: no flutter_animate usage
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ui_gen_demo/pages/homepage/chat_view/drawer_view.dart';
import 'package:ui_gen_demo/aesthetics/weathered_grid_painter.dart';

class AnimatedDrawerWrapper extends StatefulWidget {
  final Widget child;

  const AnimatedDrawerWrapper({super.key, required this.child});

  @override
  State<AnimatedDrawerWrapper> createState() => AnimatedDrawerWrapperState();

  // Expose the toggle method to child widgets
  static AnimatedDrawerWrapperState? of(BuildContext context) {
    return context.findAncestorStateOfType<AnimatedDrawerWrapperState>();
  }
}

class AnimatedDrawerWrapperState extends State<AnimatedDrawerWrapper>
    with TickerProviderStateMixin {
  final _advancedDrawerController = AdvancedDrawerController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _shockwaveController;
  late AnimationController _flickerController;
  late AnimationController _flickerDecayController;
  bool _isDrawerVisible = false;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();

    // Initialize shockwave animation controller
    _shockwaveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Initialize flicker animation controller - continuous loop
    _flickerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Shorter for faster cycling
    );

    // Initialize flicker decay controller - fades out the flicker effect
    _flickerDecayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Quick half-second decay
    );

    // Listen to drawer state and trigger animations when opening
    _advancedDrawerController.addListener(() {
      final visible = _advancedDrawerController.value.visible;
      if (visible && !_isDrawerVisible) {
        // Drawer is opening
        _shockwaveController.forward(from: 0.0);
        _flickerController.repeat();
        _flickerDecayController.forward(
          from: 0.0,
        ); // Start decay from full intensity
      } else if (!visible && _isDrawerVisible) {
        // Drawer is closing - immediately stop and reset everything
        _shockwaveController.stop();
        _shockwaveController.reset();
        _flickerController.stop();
        _flickerController.reset();
        _flickerDecayController.stop();
        _flickerDecayController.value =
            1.0; // Set to fully decayed (no flicker)
      }
      _isDrawerVisible = visible;
    });
  }

  @override
  void dispose() {
    _advancedDrawerController.dispose();
    _focusNode.dispose();
    _shockwaveController.dispose();
    _flickerController.dispose();
    _flickerDecayController.dispose();
    super.dispose();
  }

  void toggleDrawer() {
    _advancedDrawerController.toggleDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (KeyEvent event) {
        if (HardwareKeyboard.instance.isControlPressed &&
            event.logicalKey == LogicalKeyboardKey.space &&
            event is KeyDownEvent) {
          toggleDrawer();
        }
      },
      child: AdvancedDrawer(
        childDecoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        backdrop: Container(
          decoration: const BoxDecoration(color: Colors.black),
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _shockwaveController,
              _flickerController,
              _flickerDecayController,
            ]),
            builder: (context, child) {
              // Decay goes from 1.0 (full flicker) to 0.0 (no flicker)
              final flickerIntensity = 1.0 - _flickerDecayController.value;
              return CustomPaint(
                painter: WeatheredGridPainter(
                  animationProgress: _shockwaveController.value,
                  flickerTime:
                      _flickerController.value * 50, // Much faster flicker rate
                  flickerIntensity: flickerIntensity,
                ),
                size: Size.infinite,
              );
            },
          ),
        ),
        openScale: 0.97,
        animationCurve: Curves.easeInOutCubic,
        openRatio: isMobile ? 0.975 : 0.75,
        controller: _advancedDrawerController,
        drawer: DrawerView(drawerController: _advancedDrawerController),
        child: Material(
          clipBehavior: Clip.antiAlias,
          shape: RoundedSuperellipseBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(width: 1),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
