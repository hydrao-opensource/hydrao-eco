import 'package:flutter/material.dart';

class WelcomeFragment extends StatelessWidget {
  const WelcomeFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // important
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          fit: FlexFit.loose, // <= au lieu de Expanded
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Image.asset('assets/images/logo_hydrao_white.png'),
          ),
        ),
      ],
    );
  }
}
