import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DynamicTextField extends StatefulWidget {
  final String? value;
  final Duration debounceDuration;
  final ValueChanged<String>? onChanged;

  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextStyle? style;
  final TextAlign textAlign;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;

  const DynamicTextField({
    super.key,
    required this.value,
    this.onChanged,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.decoration,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.style,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
  });

  @override
  State<DynamicTextField> createState() => _DynamicTextFieldState();
}

class _DynamicTextFieldState extends State<DynamicTextField> {
  late TextEditingController _controller;
  late ScrollController _scrollController;
  Timer? _debounce;
  bool _isObscured = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _scrollController = ScrollController();
    _isObscured = widget.obscureText;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(DynamicTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // ⚡ Mise à jour seulement si la valeur externe change et que l'utilisateur n'a pas déjà tapé
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Si le parent nous donne une largeur infinie, on clamp à une valeur fixe
        final double maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 400.0;

        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility:
                true, // Force la visibilité de la barre (si le texte dépasse)
            trackVisibility: true, // Optionnel : affiche la piste de la barre
            child: TextFormField(
              controller: _controller,
              scrollController: _scrollController,
              onChanged: widget.onChanged != null
                  ? (String text) {
                      _debounce?.cancel(); // <-- reset timer

                      _debounce = Timer(widget.debounceDuration, () {
                        widget.onChanged!(
                          text,
                        ); // <-- déclenché après 500ms de silence
                      });
                    }
                  : null,
              decoration: widget.obscureText
                  ? widget.decoration?.copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscured ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() => _isObscured = !_isObscured);
                        },
                      ),
                    )
                  : widget.decoration,
              keyboardType: widget.keyboardType,
              autocorrect: widget.keyboardType != null ? false : true,
              obscureText: _isObscured,
              validator: widget.validator,
              style: widget.style,
              textAlign: widget.textAlign,
              inputFormatters: widget.inputFormatters,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              maxLength: widget.maxLength,
            ),
          ),
        );
      },
    );
  }
}
