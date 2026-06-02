import 'package:flutter/material.dart';

class SplashscreenFragment extends StatelessWidget {
  const SplashscreenFragment({super.key});

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

    // final colorScheme = Theme.of(context).colorScheme;

    // return Center(
    //   child: Padding(
    //     padding: const EdgeInsets.all(24.0),
    //     child: SpinKitWaveSpinner(
    //       color: colorScheme.primary.withValues(alpha: 0.4),
    //       // waveColor: Colors.purple.shade300,
    //       waveColor: Colors.blue.shade200,
    //       size: 200.0,
    //     ),
    //   ),
    // );
  }
}
