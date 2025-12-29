//! CustomerServiceRequest
class CustomerServiceRequest {
  final String name;
  final String email;
  final String phone;
  final String category;
  final String subject;
  final String message;
  final String type;
  final String? orderNumber;
  final int? severity;

  CustomerServiceRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.category,
    required this.subject,
    required this.message,
    required this.type,
    this.orderNumber,
    this.severity,
  });

  Map<String, dynamic> toJson() {
    final data = {
      'name': name,
      'email': email,
      'phone': phone,
      'category': category,
      'subject': subject,
      'message': message,
      'type': type,
    };

    if (orderNumber != null && orderNumber!.isNotEmpty) {
      data['order_number'] = orderNumber ?? "";
    }

    if (severity != null) {
      data['severity'] = severity.toString();
    }

    return data;
  }
}

//! CustomerServiceResponse
class CustomerServiceResponse {
  final bool success;
  final String message;

  CustomerServiceResponse({
    required this.success,
    required this.message,
  });

  factory CustomerServiceResponse.fromJson(Map<String, dynamic> json) {
    return CustomerServiceResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
