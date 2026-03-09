import 'package:flutter/material.dart';

class AgentModel {
  final String id;
  final String title;
  final String description;
  final String tag;
  final String status;
  final String rating;
  final String completed;
  final String activeUsers;
  final String load;
  final String tps;
  final IconData icon;
  final String themeColor;
  final String bgImage;
  final String role;
  final List<String> expertise;
  final Map<String, String> metrics;
  final List<Map<String, String>> pipeline;
  final String recentAchievement;

  AgentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.tag,
    required this.status,
    required this.rating,
    required this.completed,
    required this.activeUsers,
    required this.load,
    required this.tps,
    required this.icon,
    required this.themeColor,
    required this.bgImage,
    required this.role,
    required this.expertise,
    required this.metrics,
    required this.pipeline,
    required this.recentAchievement,
  });
}
