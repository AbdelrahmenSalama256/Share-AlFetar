import 'package:cozy/core/constants/widgets/errors/exceptions.dart';
import 'package:cozy/core/constants/widgets/print_util.dart';
import 'package:cozy/core/database/api/api_consumer.dart';
import 'package:cozy/core/database/api/end_points.dart';
import 'package:cozy/features/profile/data/models/address_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/common/logs.dart';

//! AddressRepo
class AddressRepo {
  final ApiConsumer api;

  AddressRepo(this.api);

  Future<Either<String, List<String>>> getCitiesByCountry({
    required String countryCode,
    required String langCode,
  }) async {
    // Localized fallback datasets
    const saEn = <String>[
      'Riyadh',
      'Jeddah',
      'Mecca',
      'Medina',
      'Dammam',
      'Al Khobar',
      'Dhahran',
      'Taif',
      'Tabuk',
      'Abha',
      'Jizan',
      'Al Kharj',
      'Buraidah',
      'Hail',
      'Najran',
      'Al Jubail',
      'Yanbu'
    ];
    const saAr = <String>[
      'الرياض',
      'جدة',
      'مكة',
      'المدينة المنورة',
      'الدمام',
      'الخبر',
      'الظهران',
      'الطائف',
      'تبوك',
      'أبها',
      'جيزان',
      'الخرج',
      'بريدة',
      'حائل',
      'نجران',
      'الجبيل',
      'ينبع'
    ];
    const egEn = <String>[
      'Cairo',
      'Giza',
      'Alexandria',
      'Shubra El Kheima',
      'Port Said',
      'Suez',
      'Luxor',
      'Asyut',
      'Ismailia',
      'Faiyum',
      'Zagazig',
      'Mansoura',
      'Tanta',
      'Aswan',
      'Damietta'
    ];
    const egAr = <String>[
      'القاهرة',
      'الجيزة',
      'الإسكندرية',
      'شبرا الخيمة',
      'بورسعيد',
      'السويس',
      'الأقصر',
      'أسيوط',
      'الإسماعيلية',
      'الفيوم',
      'الزقازيق',
      'المنصورة',
      'طنطا',
      'أسوان',
      'دمياط'
    ];
    const aeEn = <String>[
      'Dubai',
      'Abu Dhabi',
      'Sharjah',
      'Ajman',
      'Ras Al Khaimah',
      'Fujairah',
      'Umm Al Quwain',
      'Al Ain'
    ];
    const aeAr = <String>[
      'دبي',
      'أبوظبي',
      'الشارقة',
      'عجمان',
      'رأس الخيمة',
      'الفجيرة',
      'أم القيوين',
      'العين'
    ];
    List<String> fallbackFor(String cc, String lang) {
      final l = lang.toLowerCase().startsWith('ar') ? 'ar' : 'en';
      switch (cc.toUpperCase()) {
        case 'EG':
          return l == 'ar' ? egAr : egEn;
        case 'AE':
          return l == 'ar' ? aeAr : aeEn;
        case 'SA':
        default:
          return l == 'ar' ? saAr : saEn;
      }
    }

    try {
      // Prefer plain endpoint first (api/cities), then try with params if needed.
      Future<List<String>> parse(dynamic data) async {
        List<String> result = [];
        if (data is Map<String, dynamic>) {
          final list = (data['data'] ?? data['cities'] ?? []) as List;
          result = list.map((e) {
            if (e is String) return e;
            if (e is Map) {
              final isAr = langCode.toLowerCase().startsWith('ar');
              final ar = e['name_ar']?.toString();
              final en = e['name']?.toString();
              if (isAr && ar != null && ar.isNotEmpty) return ar;
              if (en != null && en.isNotEmpty) return en;
            }
            return e.toString();
          }).toList();
        } else if (data is List) {
          result = data.map((e) => e.toString()).toList();
        }
        return result;
      }

      // Attempt 1: plain endpoint
      try {
        final r1 = await api.get(EndPoints.cities);
        final parsed1 = await parse(r1.data);
        if (parsed1.isNotEmpty) {
          return Right(parsed1);
        }
      } catch (_) {
        // fallthrough to attempt 2
      }

      // Attempt 2: endpoint with country/lang params (if backend supports it)
      try {
        final r2 = await api.get(
          '${EndPoints.cities}?country=${countryCode.toUpperCase()}&lang=${langCode.toLowerCase()}',
        );
        final parsed2 = await parse(r2.data);
        if (parsed2.isNotEmpty) {
          return Right(parsed2);
        }
      } catch (_) {
        // fallthrough to fallback
      }

      // Fallback localized defaults
      return Right(fallbackFor(countryCode, langCode));
    } on ServerException {
      return Right(fallbackFor(countryCode, langCode));
    } on NoInternetException {
      return Right(fallbackFor(countryCode, langCode));
    } catch (e) {
      return Right(fallbackFor(countryCode, langCode));
    }
  }

  // Backwards compatibility wrapper
  Future<Either<String, List<String>>> getCities() async {
    return getCitiesByCountry(countryCode: 'SA', langCode: 'en');
  }

  //! Fetch all addresses
  Future<Either<String, List<AddressModel>>> getAddresses() async {
    try {
      final response = await api.get(EndPoints.getAddresses);
      if (response.data['success']) {
        final addresses = (response.data['data'] as List)
            .map((json) {
              try {
                return AddressModel.fromJson(json);
              } catch (e) {
                Print.error('Error parsing address: $e, JSON: $json');

                return AddressModel(
                  id: json['id']?.toString() ?? 'error',
                  phone: json['phone']?.toString() ?? '',
                  street: json['address']?.toString() ?? '',
                  city: json['city']?.toString() ?? '',
                  country: json['country']?.toString() ?? '',
                );
              }
            })
            .where((address) =>
                address.id != 'error') // Filter out error addresses
            .toList();
        return Right(addresses);
      } else {
        return Left('Failed to fetch addresses');
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch addresses: $e');
    }
  }

  Future<Either<String, String>> addAddress(AddressModel address) async {
    try {
      final response = await api.post(
        EndPoints.addAddress,
        data: address.toAddJson(),
        isFormData: true,
      );
      return Right(response.data['message'] ?? 'Address added successfully');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to add address: $e');
    }
  }

  //! Update an existing address - use toUpdateJson()
  Future<Either<String, String>> updateAddress(AddressModel address) async {
    try {
      PrintUtil.debug('Sending update data: ${address.toUpdateJson()}');

      final response = await api.post(
        "${EndPoints.updateAddress}/${address.id}",
        data: address.toUpdateJson(), // Use update-specific JSON
        isFormData: true,
      );

      PrintUtil.debug('Update response: ${response.data}');

      final message =
          response.data['message'] ?? 'Address updated successfully';
      return Right(message);
    } on ServerException catch (e) {
      PrintUtil.debug('Server exception: ${e.errorModel.detail}');
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      PrintUtil.debug('No internet exception: ${e.errorModel.detail}');
      return Left(e.errorModel.detail);
    } catch (e, stackTrace) {
      PrintUtil.debug('Error updating address: $e');
      PrintUtil.debug('Stack trace: $stackTrace');
      return Left('Failed to update address: $e');
    }
  }

  //! Delete an address
  Future<Either<String, String>> deleteAddress(String addressId) async {
    try {
      final response =
          await api.delete("${EndPoints.deleteAddress}/$addressId");
      return Right(response.data['message']);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to delete address: $e');
    }
  }

  //! Set an address as default
  Future<Either<String, String>> setDefaultAddress(String addressId) async {
    try {
      final response = await api.post(
        "${EndPoints.setDefaultAddress}/$addressId/make-default",
        data: {'id': addressId},
      );
      return Right(response.data['message']);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to set default address: $e');
    }
  }
}
