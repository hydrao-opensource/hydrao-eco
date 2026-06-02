import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrao_flutter_offline/core/form_validators.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/widgets/click_tooltip.dart';
import 'package:hydrao_flutter_offline/ui/widgets/dynamic_slider_field.dart';
import 'package:hydrao_flutter_offline/ui/widgets/dynamic_text_field.dart';
import 'package:hydrao_flutter_offline/ui/widgets/labeled_input_row.dart';

// enum FieldType { Text, Double, List }

Widget buildSliderField(
  double value,
  double min,
  double max,
  double step,
  void Function(double?) onChange, {
  String? label,
  String? unit,
  String? infoMessage,
  String? errorMessage,
}) {
  final field = DynamicSliderField(
    value: value,
    min: min,
    max: max,
    divisions: ((max - min) / step).round(),
    onChanged: onChange,
  );

  return _buildField(
    field,
    label: label,
    unit: unit,
    infoMessage: infoMessage,
    errorMessage: errorMessage,
  );
}

Widget buildDoubleField(
  double? value,
  void Function(double?) onChange, {
  String? label,
  String? unit,
  String? infoMessage,
  String? errorMessage,
  double? inputWidth,
  bool layoutVertical = false,
}) {
  final field = DynamicTextField(
    value: value != null ? value.toString() : "",
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'^\d*([.,]\d*)?$')),
    ],
    textAlign: TextAlign.center,
    onChanged: (newValue) {
      final cleanedValue = cleanDouble(newValue);
      // appLogger.d(
      //   '$LOG_TAG doubleField value changed val=$newValue / cleanVal=$cleanedValue',
      // );
      onChange(cleanedValue);
    },
    // debounceDuration: const Duration(milliseconds: 2000),
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.black12),
      ),
      enabledBorder: errorMessage != null
          ? OutlineInputBorder(borderSide: BorderSide(color: Colors.red))
          : OutlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
      focusedBorder: errorMessage != null
          ? OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
            )
          : null,
    ),
  );

  return _buildField(
    field,
    label: label,
    unit: unit,
    infoMessage: infoMessage,
    errorMessage: errorMessage,
    fieldWidth: inputWidth,
    layoutVertical: layoutVertical,
  );
}

Widget buildTextField(
  String? value,
  void Function(String?) onChange, {
  String? label,
  int? maxLength,
  String? unit,
  String? infoMessage,
  String? errorMessage,
  BorderSide borderSide = BorderSide.none,
  TextAlign textAlign = TextAlign.start,
  bool layoutVertical = false,
  TextInputType? keyboardType,
  bool isPassword = false,
  Widget? suffixIcon,
}) {
  final field = DynamicTextField(
    value: value ?? "",
    textAlign: textAlign,
    maxLength: maxLength,
    keyboardType: keyboardType,
    obscureText: isPassword,
    inputFormatters: maxLength != null
        ? [LengthLimitingTextInputFormatter(maxLength)]
        : null,
    onChanged: (newValue) {
      final cleanedValue = (newValue.trim().isNotEmpty) ? newValue : null;
      onChange(cleanedValue);
    },
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: borderSide,
      ),
      enabledBorder: errorMessage != null
          ? const OutlineInputBorder(borderSide: BorderSide(color: Colors.red))
          : OutlineInputBorder(borderSide: borderSide),
      focusedBorder: errorMessage != null
          ? const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
            )
          : null,
      suffixIcon: suffixIcon,
    ),
  );

  return _buildField(
    field,
    label: label,
    unit: unit,
    infoMessage: infoMessage,
    errorMessage: errorMessage,
    layoutVertical: layoutVertical,
  );
}

Widget buildTextAreaField(
  String? value,
  void Function(String?) onChange, {
  String? label,
  int? maxLength,
  int? minLines = 5,
  int? maxLines = 10,
  String? hintText,
  String? unit,
  String? infoMessage,
  String? errorMessage,
}) {
  final field = DynamicTextField(
    value: value ?? "",
    textAlign: TextAlign.start,
    maxLength: maxLength,
    inputFormatters: maxLength != null
        ? [LengthLimitingTextInputFormatter(maxLength)]
        : null,
    minLines: minLines,
    maxLines: maxLines,
    keyboardType: TextInputType.multiline,
    onChanged: (newValue) {
      final cleanedValue = (newValue.trim().isNotEmpty) ? newValue : null;
      onChange(cleanedValue);
    },
    decoration: InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: errorMessage != null
          ? const OutlineInputBorder(borderSide: BorderSide(color: Colors.red))
          : null,
      focusedBorder: errorMessage != null
          ? const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
            )
          : null,
    ),
  );

  return _buildField(
    field,
    label: label,
    unit: unit,
    infoMessage: infoMessage,
    errorMessage: errorMessage,
  );
}

Widget buildFileField(
  AppLocalizations t,
  void Function(String?) onChanged, {
  List<String>? extensions, // ex: ['json']
  String? label,
  String? unit,
  String? infoMessage,
  String? errorMessage,
  int? fieldWidth,
  Color? labelColor,
}) {
  final field = Container(
    margin: const EdgeInsets.symmetric(vertical: 5),
    padding: const EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: errorMessage != null
          ? Border.all(color: Colors.red)
          : Border.all(color: Colors.black12),
    ),
    // width: fieldWidth?.toDouble(),
    child: InkWell(
      onTap: () async {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: extensions,
        );

        if (result != null &&
            result.files.isNotEmpty &&
            result.files.single.path != null) {
          final path = result.files.single.path!;
          onChanged(path);
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 5,
        ), // zone cliquable maîtrisée
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.folder, size: 20),
            SizedBox(width: 5),
            Text(t.choose),
          ],
        ),
      ),
    ),
  );

  return _buildField(
    field,
    label: label,
    unit: unit,
    infoMessage: infoMessage,
    errorMessage: errorMessage,
    labelColor: labelColor,
    fieldWidth: fieldWidth?.toDouble(),
  );
}

Widget buildDropdownField(
  String? value,
  Map<String, String> options,
  void Function(String?) onChanged, {
  String? label,
  String? unit,
  String? infoMessage,
  String? errorMessage,
  int? fieldWidth,
}) {
  final field = Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: errorMessage != null
          ? Border.all(color: Colors.red)
          : Border.all(color: Colors.black12),
    ),
    width: fieldWidth?.toDouble(),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        isExpanded: fieldWidth != null,
        items: options.entries
            .map(
              (MapEntry<String, String> entry) =>
                  DropdownMenuItem(value: entry.key, child: Text(entry.value)),
            )
            .toList(),
        onChanged: onChanged,
      ),
    ),
  );

  return _buildField(
    field,
    label: label,
    unit: unit,
    infoMessage: infoMessage,
    errorMessage: errorMessage,
    fieldWidth: fieldWidth?.toDouble(),
  );
}

Widget _buildField(
  Widget field, {
  String? label,
  String? unit,
  String? infoMessage,
  String? errorMessage,
  double? fieldWidth,
  Color? labelColor,
  bool layoutVertical = false,
}) {
  final Widget infoWidget = infoMessage != null
      ? ClickTooltip(
          message: infoMessage,
          child: Padding(
            padding: EdgeInsets.only(left: 4.0),
            child: Icon(
              Icons.help_outline,
              size: 18,
              color: labelColor ?? AppTheme.textColor,
            ),
          ),
        )
      : const SizedBox.shrink();

  final labeledInput = LabeledInputRow(
    label: label,
    field: field,
    unit: unit,
    infoWidget: infoWidget,
    fieldWidth: fieldWidth,
    textColor: labelColor,
    vertical: layoutVertical,
  );

  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0, top: 4),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labeledInput, // plus de SizedBox infinity ici
        if (errorMessage != null && errorMessage.trim().isNotEmpty)
          Text(
            errorMessage,
            style: const TextStyle(color: Colors.redAccent, fontSize: 14.0),
          ),
      ],
    ),
  );
}
