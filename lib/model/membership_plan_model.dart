
import 'dart:convert';

class MembershipPlanModel {
  final int id;
  final String planName;
  final double amount;
  final int status;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  MembershipPlanModel({
    required this.id,
    required this.planName,
    required this.amount,
    required this.status,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create Plan object from JSON
  factory MembershipPlanModel.fromJson(Map<String, dynamic> json) {
    return MembershipPlanModel(
      id: json['id'],
      planName: json['plan_name'],
      amount: json['amount'].toDouble(), // Ensure the amount is a double
      status: json['status'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Method to convert Plan object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plan_name': planName,
      'amount': amount,
      'status': status,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

