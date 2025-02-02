import 'dart:ui';

import 'package:flutter/material.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Comming Soon',
          style: TextStyle(
            fontSize: 35,
          ),
        ),
      ),
    );
  }
}
