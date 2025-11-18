import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({super.key, required this.drawerController});

  final AdvancedDrawerController drawerController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children:
              [
                    const Spacer(),
                    IconButton.outlined(
                      onPressed: () => drawerController.hideDrawer(),
                      icon: const Icon(Icons.close),
                    ),
                  ]
                  .map(
                    (widget) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: widget,
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}
