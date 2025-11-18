import 'package:flutter/material.dart';
import 'package:ui_gen_demo/pages/animated_drawer_wrapper.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          AnimatedDrawerWrapper.of(context)?.toggleDrawer();
        },
        label: const Column(
          children: [
            Text('Talk to Gemini'),
            Text(
              'Ctrl + Space',
              style: TextStyle(fontSize: 10, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: const Center(child: Text('Homepage Content')),
    );
  }
}
