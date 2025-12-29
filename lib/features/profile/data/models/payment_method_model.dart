enum PaymentMethodType {
  card,
  paypal,
  applePay,
  googlePay,
  bankTransfer,
}

//! PaymentMethodModel
class PaymentMethodModel {
  final String id;
  final PaymentMethodType type;
  final String? cardNumber;
  final String? cardHolderName;
  final String? expiryDate;
  final String? cardType;
  final String? email;
  bool isDefault;

  PaymentMethodModel({
    required this.id,
    required this.type,
    this.cardNumber,
    this.cardHolderName,
    this.expiryDate,
    this.cardType,
    this.email,
    this.isDefault = false,
  });

  String get displayName {
    switch (type) {
      case PaymentMethodType.card:
        return cardType ?? 'Card';
      case PaymentMethodType.paypal:
        return 'PayPal';
      case PaymentMethodType.applePay:
        return 'Apple Pay';
      case PaymentMethodType.googlePay:
        return 'Google Pay';
      case PaymentMethodType.bankTransfer:
        return 'Bank Transfer';
    }
  }

  String get displayInfo {
    switch (type) {
      case PaymentMethodType.card:
        return cardNumber ?? '';
      case PaymentMethodType.paypal:
        return email ?? '';
      case PaymentMethodType.applePay:
        return 'Apple Pay';
      case PaymentMethodType.googlePay:
        return 'Google Pay';
      case PaymentMethodType.bankTransfer:
        return 'Bank Account';
    }
  }

  PaymentMethodModel copyWith({
    String? id,
    PaymentMethodType? type,
    String? cardNumber,
    String? cardHolderName,
    String? expiryDate,
    String? cardType,
    String? email,
    bool? isDefault,
  }) {
    return PaymentMethodModel(
      id: id ?? this.id,
      type: type ?? this.type,
      cardNumber: cardNumber ?? this.cardNumber,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      expiryDate: expiryDate ?? this.expiryDate,
      cardType: cardType ?? this.cardType,
      email: email ?? this.email,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString(),
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'expiryDate': expiryDate,
      'cardType': cardType,
      'email': email,
      'isDefault': isDefault,
    };
  }

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'],
      type: PaymentMethodType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      cardNumber: json['cardNumber'],
      cardHolderName: json['cardHolderName'],
      expiryDate: json['expiryDate'],
      cardType: json['cardType'],
      email: json['email'],
      isDefault: json['isDefault'] ?? false,
    );
  }
}
