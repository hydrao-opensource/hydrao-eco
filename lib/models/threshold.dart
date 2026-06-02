import 'dart:ui';

import 'package:hydrao_flutter_offline/conversions.dart';

enum ThresholdColor {
  yellow,
  orange,
  red,
  purple,
  blue,
  lightBlue,
  green,
  lightGreen,
  black,
}

class HydraoThreshold {
  final double liter;
  final String color; // ex: "FF0000"

  HydraoThreshold({required this.liter, required this.color});

  factory HydraoThreshold.fromJson(Map<String, dynamic> json) {
    String colorString = json["color"] as String;
    String color = colorString.startsWith('#')
        ? colorString.substring(1)
        : colorString;
    if (color.length > 6) {
      //remove trailing FF
      color = color.substring(color.length - 6);
    }
    var volume = (json['liter'] as num? ?? 0.0).toDouble();

    return HydraoThreshold(color: color, liter: volume);
  }

  Map<String, dynamic> toJson() => {'color': "#$color", 'liter': liter};

  @override
  String toString() {
    return toJson().toString();
  }

  ThresholdColor getThresholdColor() {
    return getThresholdColorFromHexa(color);
  }

  Color getColor() {
    // final buffer = StringBuffer();
    // if (color.length == 6 || color.length == 7) buffer.write('ff');
    // buffer.write(color.replaceFirst('#', ''));
    // return Color(int.parse(buffer.toString(), radix: 16));

    ThresholdColor thresholdColor = getThresholdColorFromHexa(color);

    return getDisplayColorFromThresholdColor(thresholdColor);
  }

  HydraoThreshold copyWith({double? liter, String? color}) {
    return HydraoThreshold(
      liter: liter ?? this.liter,
      color: color ?? this.color,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HydraoThreshold &&
          liter == other.liter &&
          color.toLowerCase() == other.color.toLowerCase();

  @override
  int get hashCode => liter.hashCode ^ color.hashCode;
}
