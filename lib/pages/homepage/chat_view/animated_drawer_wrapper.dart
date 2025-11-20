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

class AnimatedDrawerWrapperState extends State<AnimatedDrawerWrapper> {
  final _advancedDrawerController = AdvancedDrawerController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    // No animations: nothing to initialize here
  }

  @override
  void dispose() {
    _advancedDrawerController.dispose();
    _focusNode.dispose();
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
          child: CustomPaint(
            painter: WeatheredGridPainter(),
            size: Size.infinite,
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
