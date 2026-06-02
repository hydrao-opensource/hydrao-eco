import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/conversions.dart';
import 'package:hydrao_flutter_offline/core/form_fields.dart';

class LiterDropDown extends StatefulWidget {
  final int maxLiter;
  final int minLiter;
  final int? value;
  final int id;
  final String unit;
  final void Function(int id, int value) onChanged;

  const LiterDropDown({
    super.key,
    this.maxLiter = 200,
    this.minLiter = 2,
    this.value,
    required this.id,
    required this.onChanged,
    required this.unit,
  });

  @override
  // ignore: library_private_types_in_public_api
  _LiterDropDownState createState() => _LiterDropDownState();
}

class _LiterDropDownState extends State<LiterDropDown> {
  int? selectedLiter;

  @override
  void initState() {
    super.initState();
    selectedLiter = widget.value;
  }

  @override
  void didUpdateWidget(covariant LiterDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      selectedLiter = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    // prepare choices
    Map<String, String> choices = getLiterChoicesForUnit(
      widget.minLiter,
      widget.maxLiter,
      widget.unit,
    );

    if (choices.isEmpty) return const SizedBox.shrink();

    // adapt selected value from choices
    if (selectedLiter == null) {
      selectedLiter = int.parse(choices.keys.first);
    } else {
      selectedLiter = int.parse(
        choices.keys.firstWhere(
          (l) => int.parse(l) <= selectedLiter!,
          orElse: () => choices.keys.last,
        ),
      );
    }

    return buildDropdownField(selectedLiter.toString(), choices, (newValue) {
      int newLiter = int.parse(newValue!);
      widget.onChanged(widget.id, newLiter);
      setState(() {
        selectedLiter = newLiter;
      });
    }, fieldWidth: 95);
  }
}
