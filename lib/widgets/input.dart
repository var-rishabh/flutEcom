import 'package:flutter/material.dart';

class KInputField extends StatelessWidget {
  final String labelText;
  final IconData? icon;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const KInputField({
    super.key,
    required this.labelText,
    this.icon,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          floatingLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
          prefixIcon: icon != null ? Icon(icon) : null,
          prefixIconColor: Theme.of(context).iconTheme.color,
          contentPadding: const EdgeInsets.all(16.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
    );
  }
}
