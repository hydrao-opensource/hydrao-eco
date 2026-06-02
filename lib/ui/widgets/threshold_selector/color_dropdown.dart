import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/conversions.dart';
import 'package:hydrao_flutter_offline/models/threshold.dart';

class ColorDropDown extends StatefulWidget {
  final ThresholdColor value;
  final int id;
  final void Function(int id, ThresholdColor value) onChanged;

  const ColorDropDown({
    super.key,
    required this.value,
    required this.id,
    required this.onChanged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ColorDropDownState createState() => _ColorDropDownState();
}

class _ColorDropDownState extends State<ColorDropDown> {
  ThresholdColor? selectedColor;

  DropdownMenuItem<ThresholdColor> _getDdItem(ThresholdColor color) {
    return DropdownMenuItem<ThresholdColor>(
      value: color,
      child: Center(
        child: Container(
          width: 50,
          height: 20,
          decoration: BoxDecoration(
            color: getDisplayColorFromThresholdColor(color),
            border: Border.all(
              color: color == selectedColor ? Colors.black45 : Colors.white,
              width: 1.5,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: color == ThresholdColor.black
              ? Center(
                  child: Text(
                    'OFF',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                )
              : Container(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    selectedColor = widget.value;
  }

  @override
  void didUpdateWidget(covariant ColorDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      selectedColor = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        onChanged: (dynamic color) {
          widget.onChanged(widget.id, color as ThresholdColor);
          setState(() {
            selectedColor = color;
          });
        },
        value: selectedColor,
        items: <DropdownMenuItem<ThresholdColor>>[
          _getDdItem(ThresholdColor.yellow),
          _getDdItem(ThresholdColor.orange),
          _getDdItem(ThresholdColor.red),
          _getDdItem(ThresholdColor.purple),
          _getDdItem(ThresholdColor.blue),
          _getDdItem(ThresholdColor.lightBlue),
          _getDdItem(ThresholdColor.green),
          _getDdItem(ThresholdColor.lightGreen),
          _getDdItem(ThresholdColor.black),
        ],
      ),
    );
  }
}
