import 'package:flutter/material.dart';

class Design {
  static const Color backgroundColor = Color(0xFF1565D3);
}

TextStyle LabelDesing() {
  return TextStyle(
    color: Design.backgroundColor,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
}

InputDecoration DesignTextBox(String label, String hint, IconData icon) {
  return InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 8),
      prefixIcon: Icon(icon),
      hintText: hint,
      labelText: label,
      fillColor: Design.backgroundColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)));
}
