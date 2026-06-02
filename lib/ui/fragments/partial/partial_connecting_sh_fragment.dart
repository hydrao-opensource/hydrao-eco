import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/widgets/animated_sequence.dart';

class PartialConnectingShFragment extends StatelessWidget {
  final String name;

  const PartialConnectingShFragment({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    // final t = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSequenceWidget(
            width: 160,
            height: 80,
            imagePaths: [
              "assets/images/showerhead_connect_white_1a.png",
              "assets/images/showerhead_connect_white_1b.png",
              "assets/images/showerhead_connect_white_1c.png",
              "assets/images/showerhead_connect_white_1d.png",
            ],
            duration: Duration(milliseconds: 500),
          ),

          Text(
            name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: AppTheme.scanSectionTextColor,
            ),
            textAlign: TextAlign.start,
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ],
      ),
    );
  }
}
