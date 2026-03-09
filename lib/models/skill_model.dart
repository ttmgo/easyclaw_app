import 'package:flutter/material.dart';

class SkillModel {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final String tag;
  final double rating;
  final String users;
  final String latency;
  final String stack;
  final String performance;
  final String details;
  final List<String> features;
  final String usage;
  final String version;
  final String category;

  SkillModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.tag,
    required this.rating,
    required this.users,
    required this.latency,
    required this.stack,
    required this.performance,
    required this.details,
    required this.features,
    required this.usage,
    required this.version,
    required this.category,
  });
}
