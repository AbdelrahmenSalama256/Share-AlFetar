//! ContactResponse
class ContactResponse {
  final bool success;
  final String message;
  final ContactData data;

  ContactResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ContactResponse.fromJson(Map<String, dynamic> json) {
    return ContactResponse(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ?? '',
      data: ContactData.fromJson(json['data'] ?? json['info'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data.toJson(),
      };
}

//! ContactData
class ContactData {
  final String? token;
  final int id;
  final String? username;
  final String? mobile;
  final UserDetails user;

  ContactData({
    this.token,
    required this.id,
    this.username,
    this.mobile,
    required this.user,
  });

  factory ContactData.fromJson(Map<String, dynamic> json) {
    return ContactData(
      token: json['token'] as String?,
      id: json['id'] as int? ?? json['user']?['id'] as int? ?? 0,
      username:
          json['username'] as String? ?? json['user']?['username'] as String?,
      mobile: json['mobile'] as String? ?? json['user']?['mobile'] as String?,
      user: UserDetails.fromJson(json['user'] ?? json),
    );
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'id': id,
        'username': username,
        'mobile': mobile,
        'user': user.toJson(),
      };
}

//! UserDetails
class UserDetails {
  final int id;
  final int? businessId;
  final String type;
  final String? contactType;
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String contactId;
  final String contactStatus;
  final String? mobile;
  final String? balance;
  final String? createdAt;
  final String? updatedAt;
  final String? image;
  final String? imageUrl;
  final String? fcmToken;

  UserDetails({
    required this.id,
    this.businessId,
    required this.type,
    this.contactType,
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    required this.contactId,
    required this.contactStatus,
    this.mobile,
    this.balance,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.fcmToken,
    this.imageUrl,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'] as int? ?? 0,
      businessId: json['business_id'] as int?,
      type: json['type'] as String? ?? '',
      contactType: json['contact_type'] as String?,
      name: json['name'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      contactId: json['contact_id'] as String? ?? '',
      contactStatus: json['contact_status'] as String? ?? 'active',
      mobile: json['mobile'] as String?,
      balance: json['balance'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      image: json['image'] as String?,
      fcmToken: json['fcm_token'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'business_id': businessId,
        'type': type,
        'contact_type': contactType,
        'name': name,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'contact_id': contactId,
        'contact_status': contactStatus,
        'mobile': mobile,
        'balance': balance,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'image': image,
        'fcm_token': fcmToken,
        'image_url': imageUrl,
      };

  UserDetails copyWith({
    int? id,
    int? businessId,
    String? type,
    String? contactType,
    String? name,
    String? firstName,
    String? lastName,
    String? email,
    String? contactId,
    String? contactStatus,
    String? mobile,
    String? balance,
    String? createdAt,
    String? updatedAt,
    String? image,
    String? imageUrl,
    String? fcmToken,
  }) {
    return UserDetails(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      type: type ?? this.type,
      contactType: contactType ?? this.contactType,
      name: name ?? this.name,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      contactId: contactId ?? this.contactId,
      contactStatus: contactStatus ?? this.contactStatus,
      mobile: mobile ?? this.mobile,
      balance: balance ?? this.balance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      image: image ?? this.image,
      fcmToken: fcmToken ?? this.fcmToken,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
