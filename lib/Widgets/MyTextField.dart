import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final String? label;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final Function? onEnterPress;
  final void Function(String)? onChanged;
  final Function? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? enabled;
  final bool? isMandatory;
  final bool? isLabelNeeded;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? arrTextInputFormatter;
  final int? maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final List<String>? autofillHints;
  final TextAlign? textAlign;
  final EdgeInsets? contentPadding;
  final TextInputAction? textInputAction;
  final bool? obscureText;

  const MyTextField({
    super.key,
    this.controller,
    required this.hint,
    this.label,
    this.labelStyle,
    this.textStyle,
    this.onEnterPress,
    this.onChanged,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled,
    this.isMandatory,
    this.isLabelNeeded,
    this.validator,
    this.arrTextInputFormatter,
    this.maxLines,
    this.minLines,
    this.keyboardType,
    this.autofillHints,
    this.textAlign,
    this.contentPadding,
    this.textInputAction,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText!,
        maxLines: maxLines ?? 1,
        minLines: minLines ?? 1,
        keyboardType: keyboardType,
        autofillHints: autofillHints,
        textAlign: textAlign ?? TextAlign.start,
        textInputAction: textInputAction,
        style: textStyle,
        onChanged: onChanged,
        onTap: onTap as void Function()?,
        enabled: enabled ?? true,
        validator: validator,
        inputFormatters: arrTextInputFormatter,
        decoration: InputDecoration(
          labelText: isLabelNeeded ?? true ? label : null,
          labelStyle: labelStyle,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: InputBorder.none,
        ),
        onFieldSubmitted: (value) {
          if (onEnterPress != null) {
            onEnterPress!();
          }
        },
      ),
    );
  }
}
