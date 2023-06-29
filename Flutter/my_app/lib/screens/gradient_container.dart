import 'package:flutter/material.dart';

class GradienContainer extends StatelessWidget {
  const GradienContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.black, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
      child: const Center(
        child: Text(
          'ssssssaaaas',
          style: TextStyle(color: Colors.blue, fontSize: 30),
        ),
      ),
    );
  }
}
