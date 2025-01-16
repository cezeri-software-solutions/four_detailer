import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../core.dart';

enum FieldInputType { text, integer, double, email, phone, password }

class MyTextFormField extends StatelessWidget {
  final String? fieldTitle;
  final String? fieldFooter;
  final bool? isMandatory;
  // final String? labelText; //* Labeltext schaut bei dieser Größe nicht schön aus
  final String? hintText;
  final String? initialValue;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final FieldInputType inputType;
  final bool readOnly;
  final bool addPlaceholderForError;
  final TextAlign? textAlign;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final Widget? prefix;
  final Widget? prefixIcon;
  final String? prefixText;
  final Widget? suffix;
  final Widget? suffixIcon;
  final String? suffixText;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(PointerDownEvent)? onTapOutside;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final Color? fillColor;
  final bool unfocusOnTapOutside;
  final double maxWidth;

  const MyTextFormField({
    super.key,
    this.fieldTitle,
    this.fieldFooter,
    this.isMandatory = false,
    // this.labelText,
    this.hintText,
    this.initialValue,
    this.controller,
    this.validator,
    this.inputFormatters,
    this.inputType = FieldInputType.text,
    this.readOnly = false,
    this.addPlaceholderForError = false,
    this.textAlign = TextAlign.start,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.prefix,
    this.prefixIcon,
    this.prefixText,
    this.suffix,
    this.suffixIcon,
    this.suffixText,
    this.onChanged,
    this.onTap,
    this.onTapOutside,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.fillColor,
    this.unfocusOnTapOutside = false,
    this.maxWidth = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerOrEqualTo(DESKTOP);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (fieldTitle != null) FieldTitle(fieldTitle: fieldTitle!, isMandatory: isMandatory!),
        SizedBox(
          width: maxWidth,
          height: addPlaceholderForError ? 55 : null,
          child: TextFormField(
            minLines: minLines,
            textAlign: textAlign!,
            controller: controller,
            initialValue: initialValue,
            validator: (value) => validator != null ? validator!(value) : null,
            // style: const TextStyle(fontSize: 16),
            focusNode: focusNode,
            onTapOutside: unfocusOnTapOutside ? (_) => FocusScope.of(context).unfocus() : null,
            keyboardType: keyboardType,
            readOnly: readOnly,
            textCapitalization: textCapitalization,
            maxLines: maxLines,
            textInputAction: textInputAction,
            obscureText: obscureText,
            inputFormatters: inputFormatters ??
                switch (inputType) {
                  FieldInputType.integer => [IntegerInputFormatter()],
                  FieldInputType.double => [DoubleInputFormatter()],
                  _ => null,
                },
            onChanged: onChanged,
            onTap: onTap,
            decoration: InputDecoration(
              // labelText: labelText,
              // labelStyle: const TextStyle().copyWith(letterSpacing: 0),
              hintText: hintText,
              hintStyle: const TextStyle().copyWith(color: readOnly ? null : Colors.grey, letterSpacing: 0),
              fillColor: fillColor,
              filled: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: isDesktop ? 9 : 5.5),
              isDense: true,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              prefix: prefix,
              prefixIcon: prefixIcon,
              prefixIconConstraints: const BoxConstraints(minWidth: 36, minHeight: 0),
              prefixText: prefixText,
              suffix: suffix,
              suffixIcon: suffixIcon,
              suffixIconConstraints: const BoxConstraints(minWidth: 36, minHeight: 0),
              suffixText: suffixText,

              // suffixStyle: const TextStyle(fontSize: 14),
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(6),
              //   borderSide: const BorderSide(color: Colors.red),
              // ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: context.colorScheme.surfaceContainerLow),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: context.colorScheme.primary),
              ),
            ),
          ),
        ),
        if (fieldFooter != null) Text(fieldFooter!, style: context.textTheme.bodySmall!.copyWith(color: context.colorScheme.outline)),
      ],
    );
  }
}
