import 'package:flutter/material.dart';

//! SupportTicketResponse
class SupportTicketResponse {
  final bool success;
  final List<SupportTicket> tickets;

  SupportTicketResponse({
    required this.success,
    required this.tickets,
  });

  factory SupportTicketResponse.fromJson(Map<String, dynamic> json) {
    return SupportTicketResponse(
      success: json['success'] ?? false,
      tickets: (json['tickets'] as List<dynamic>)
          .map((ticketJson) => SupportTicket.fromJson(ticketJson))
          .toList(),
    );
  }
}

//! SupportTicket
class SupportTicket {
  final int id;
  final int businessId;
  final String subject;
  final String data;
  final int contactId;
  final String status;
  final String priority;
  final int? assignedTo;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;

  SupportTicket({
    required this.id,
    required this.businessId,
    required this.subject,
    required this.data,
    required this.contactId,
    required this.status,
    required this.priority,
    this.assignedTo,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      id: json['id'] ?? 0,
      businessId: json['business_id'] ?? 0,
      subject: json['subject'] ?? '',
      data: json['data'] ?? '',
      contactId: json['contact_id'] ?? 0,
      status: json['status'] ?? '',
      priority: json['priority'] ?? '',
      assignedTo: json['assigned_to'],
      type: json['type'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? ''),
      updatedAt: DateTime.parse(json['updated_at'] ?? ''),
    );
  }


  Color getStatusColor() {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.green;
      case 'closed':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }


  Color getPriorityColor() {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }


  String getTypeDisplayText() {
    switch (type.toLowerCase()) {
      case 'inquiry':
        return 'General Inquiry';
      case 'complaints':
        return 'Complaint';
      case 'return':
        return 'Return Request';
      case 'refund':
        return 'Refund Request';
      case 'exchange':
        return 'Exchange Request';
      default:
        return type;
    }
  }
}
