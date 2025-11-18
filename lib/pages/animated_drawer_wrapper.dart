import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ui_gen_demo/pages/drawer_view.dart';
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
    with SingleTickerProviderStateMixin {
  final _advancedDrawerController = AdvancedDrawerController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _borderRadiusAnimation;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();

    // Initialize animation controller for border radius
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    // Create animation for border radius (0 to 48)
    _borderRadiusAnimation = Tween<double>(begin: 0.0, end: 48.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Listen to drawer state changes
    _advancedDrawerController.addListener(_onDrawerChanged);
  }

  void _onDrawerChanged() {
    // Backup listener in case the drawer state changes externally
    if (_advancedDrawerController.value.visible) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _advancedDrawerController.removeListener(_onDrawerChanged);
    _advancedDrawerController.dispose();
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void toggleDrawer() {
    // Check current drawer state and trigger animation IMMEDIATELY
    final isCurrentlyVisible = _advancedDrawerController.value.visible;

    if (isCurrentlyVisible) {
      // Drawer is open, so we're closing it - animate to 0
      _animationController.reverse();
    } else {
      // Drawer is closed, so we're opening it - animate to 48
      _animationController.forward();
    }

    // Then toggle the actual drawer
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
        disabledGestures: true,
        openScale: 0.97,
        openRatio: isMobile ? 0.975 : 0.75,
        animationCurve: Curves.easeInOutCubic,
        controller: _advancedDrawerController,
        animationDuration: const Duration(milliseconds: 300),
        // Drawer content: simple fade-in and slide-up using flutter_animate
        drawer: DrawerView(drawerController: _advancedDrawerController)
            .animate()
            .fadeIn(
              duration: const Duration(milliseconds: 300),
              delay: const Duration(milliseconds: 100),
            )
            .slideY(
              begin: 1.0,
              duration: const Duration(milliseconds: 300),
              delay: const Duration(milliseconds: 100),
              curve: Curves.easeOutCubic,
            ),
        child: AnimatedBuilder(
          animation: _borderRadiusAnimation,
          builder: (context, child) {
            return Material(
              clipBehavior: Clip.antiAlias,
              shape: RoundedSuperellipseBorder(
                borderRadius: BorderRadius.circular(
                  _borderRadiusAnimation.value,
                ),
                side: const BorderSide(width: 1),
              ),
              child: child!,
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}
