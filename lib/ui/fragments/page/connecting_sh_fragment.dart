import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/widgets/animated_sequence.dart';

class ConnectingShFragment extends StatelessWidget {
  final String message;
  // final VoidCallback? onHelpTap; // callback optionnel

  const ConnectingShFragment({
    super.key,
    required this.message,
    // this.onHelpTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: BoxDecoration(
            color: AppTheme.sectionBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AnimatedSequenceWidget(
                width: 180,
                height: 180,
                imagePaths: [
                  "assets/images/showerhead_connect_1a.png",
                  "assets/images/showerhead_connect_1b.png",
                  "assets/images/showerhead_connect_1c.png",
                  "assets/images/showerhead_connect_1d.png",
                ],
                duration: Duration(milliseconds: 500),
              ),

              // const SizedBox(height: 15),
              Text(
                message,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ],
    );
  }
}
