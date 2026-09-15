import 'package:flutter/material.dart';

class DolibarrModule {
  final String key;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String route;
  final bool isEnabled;

  const DolibarrModule({
    required this.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.route,
    this.isEnabled = true,
  });
}
