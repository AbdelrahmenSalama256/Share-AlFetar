//! AddressModel
class AddressModel {
  final String id;
  final String title;
  final String name;
  final String phone;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  bool isDefault;

  AddressModel({
    required this.id,
    this.title = 'Address',
    this.name = '',
    required this.phone,
    required this.street,
    required this.city,
    this.state = '',
    this.zipCode = '',
    required this.country,
    this.isDefault = false,
  });

  AddressModel copyWith({
    String? id,
    String? title,
    String? name,
    String? phone,
    String? street,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      title: title ?? this.title,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  String get fullAddress => '$street, $city, $state $zipCode, $country';


  Map<String, dynamic> toAddJson() {
    return {
      'country': country,
      'city': city,
      'address': street,
      'phone': phone,
      'is_default': isDefault ? '1' : '0',
      if (title.isNotEmpty) 'title': title,
      if (name.isNotEmpty) 'name': name,
      if (state.isNotEmpty) 'state': state,
      if (zipCode.isNotEmpty) 'zipCode': zipCode,
    };
  }


  Map<String, dynamic> toUpdateJson() {
    return {
      'country': country,
      'city': city,
      'address': street,
      'phone': phone,
      'is_default': isDefault ? '1' : '0',
      if (title.isNotEmpty) 'title': title,
      if (name.isNotEmpty) 'name': name,
      if (state.isNotEmpty) 'state': state,
      if (zipCode.isNotEmpty) 'zipCode': zipCode,
    };
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id']?.toString() ?? '',
      title: json.containsKey('title') &&
              json['title'] != null &&
              json['title'].toString().isNotEmpty
          ? json['title'].toString()
          : 'Address',
      name: json.containsKey('name') && json['name'] != null
          ? json['name'].toString()
          : '',
      phone: json.containsKey('phone') && json['phone'] != null
          ? json['phone'].toString()
          : (json.containsKey('mobile') && json['mobile'] != null
              ? json['mobile'].toString()
              : ''),
      street: json.containsKey('address') && json['address'] != null
          ? json['address'].toString()
          : '',
      city: json.containsKey('city') && json['city'] != null
          ? json['city'].toString()
          : '',
      state: json.containsKey('state') && json['state'] != null
          ? json['state'].toString()
          : '',
      zipCode: json.containsKey('zipCode') && json['zipCode'] != null
          ? json['zipCode'].toString()
          : (json.containsKey('postal_code') && json['postal_code'] != null
              ? json['postal_code'].toString()
              : ''),
      country: json.containsKey('country') && json['country'] != null
          ? json['country'].toString()
          : '',
      isDefault: json.containsKey('is_default') &&
          (json['is_default'] == '1' ||
              json['is_default'] == 1 ||
              json['is_default'] == true),
    );
  }
}
