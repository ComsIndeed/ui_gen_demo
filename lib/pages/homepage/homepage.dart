import 'package:flutter/material.dart';
import 'package:ui_gen_demo/constants/app_constants.dart';
import 'package:ui_gen_demo/pages/homepage/app_title.dart';
import 'package:ui_gen_demo/pages/homepage/chat_view/animated_drawer_wrapper.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [AppTitle()],
        ),
      ),
    );
  }
}
