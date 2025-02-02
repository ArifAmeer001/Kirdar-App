import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color color;
  final dynamic height;
  final Color fontColor;
  final bool loading;
  const RoundButton(
      {super.key,
      required this.title,
      required this.onTap,
      required this.color,
      this.loading = false,
      this.height = 50,
      this.fontColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
            // color: const Color(0xFF1C5153),
            color: color,
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: loading ? const CircularProgressIndicator(strokeWidth: 3,) :
          Text(
            title,
            style: TextStyle(color: fontColor),
          ),
        ),
      ),
    );
  }
}
