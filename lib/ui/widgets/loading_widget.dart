import 'package:flutter/material.dart';

class MovieDbLoadingWidget extends StatelessWidget {
  const MovieDbLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 32,
        height: 32,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
