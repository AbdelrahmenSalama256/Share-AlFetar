import 'dart:ui' as ui;

import 'package:bloc/bloc.dart';
import 'package:cozy/core/common/logs.dart';
import 'package:cozy/core/network/local_network.dart';
import 'package:cozy/features/profile/data/models/address_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/service_locator.dart';
import '../../data/repo/address_repo.dart';
import 'address_state.dart';

//! AddressCubit
class AddressCubit extends Cubit<AddressState> {
  final AddressRepo addressRepo;

  AddressCubit(this.addressRepo) : super(AddressInitial());

  List<AddressModel> addresses = [];

  // Cities dropdown support
  List<String> cities = [];
  String? selectedCity;

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipController = TextEditingController();
  final countryController = TextEditingController();
  bool isDefault = false;
  bool isEditing = false;
  String? editingAddressId;

  void initializeForm({AddressModel? address}) {
    if (address != null) {
      isEditing = true;
      editingAddressId = address.id;
      titleController.text = address.title;
      nameController.text = address.name;
      phoneController.text = address.phone;
      streetController.text = address.street;
      cityController.text = address.city;
      selectedCity = address.city.isNotEmpty ? address.city : null;
      stateController.text = address.state;
      zipController.text = address.zipCode;
      countryController.text = address.country;
      isDefault = address.isDefault;
    } else {
      isEditing = false;
      editingAddressId = null;
      titleController.text = '';
      nameController.clear();
      phoneController.clear();
      streetController.clear();
      cityController.clear();
      selectedCity = null;
      stateController.clear();
      zipController.clear();
      // Derive default country from platform locale, fallback to SA
      final platformLocale = ui.PlatformDispatcher.instance.locale;
      final cc = (platformLocale.countryCode ?? '').toUpperCase();
      // Map a few known codes to localized country names (basic)
      String defaultCountry;
      switch (cc) {
        case 'EG':
          defaultCountry = 'Egypt';
          break;
        case 'AE':
          defaultCountry = 'United Arab Emirates';
          break;
        case 'SA':
        default:
          defaultCountry = 'Saudi Arabia';
      }
      countryController.text = defaultCountry;
      isDefault = false;
    }
    emit(AddressFormInitialized(isEditing: isEditing, isDefault: isDefault));
  }

  void toggleDefault(bool value) {
    isDefault = value;
    emit(AddressFormUpdated(isDefault: isDefault));
  }

  Future<void> saveAddress() async {
    if (!formKey.currentState!.validate()) {
      emit(AddressFormInvalid());
      return;
    }

    // Persist dropdown values from form fields that use onSaved
    try {
      formKey.currentState!.save();
    } catch (_) {}

    final address = AddressModel(
      id: isEditing ? editingAddressId! : '',
      title: titleController.text.isEmpty ? 'Address' : titleController.text,
      name: nameController.text,
      phone: phoneController.text,
      street: streetController.text,
      city: (selectedCity ?? cityController.text),
      state: stateController.text,
      zipCode: zipController.text,
      country: countryController.text,
      isDefault: isDefault,
    );

    emit(AddressLoading());
    final result = isEditing
        ? await addressRepo.updateAddress(address)
        : await addressRepo.addAddress(address);

    result.fold(
      (error) {
        Print.error(error);
        emit(AddressError(error));
      },
      (savedAddress) {
        emit(AddressSuccess(savedAddress));
      },
    );
  }

  String _mapCountryNameToCode(String name) {
    final n = (name).toLowerCase().trim();
    if (n.contains('saudi') || n.contains('السعود') || n == 'sa') return 'SA';
    if (n.contains('egypt') || n.contains('مصر') || n == 'eg') return 'EG';
    if (n.contains('emirates') || n.contains('الإمارات') || n == 'ae') {
      return 'AE';
    }
    if (n.contains('united states') || n.contains('usa') || n == 'us') {
      return 'US';
    }
    return 'SA';
  }

  Future<void> fetchCities() async {
    // Determine language from cache (en/ar)
    final langCode = sl<CacheHelper>().getCachedLanguage();
    // Determine country code from field or platform
    final platformLocale = ui.PlatformDispatcher.instance.locale;
    final ccFromCountry = _mapCountryNameToCode(countryController.text);
    final countryCode = (ccFromCountry.isNotEmpty
        ? ccFromCountry
        : (platformLocale.countryCode ?? 'SA'));

    final result = await addressRepo.getCitiesByCountry(
      countryCode: countryCode,
      langCode: langCode,
    );
    result.fold(
      (_) {},
      (list) {
        cities = list;
        // If an existing city matches, keep it
        if (selectedCity != null && !cities.contains(selectedCity)) {
          selectedCity = null;
        }
        emit(AddressFormUpdated(isDefault: isDefault));
      },
    );
  }

  Future<void> fetchAddresses() async {
    emit(AddressLoading());
    final result = await addressRepo.getAddresses();
    result.fold(
      (error) {
        Print.error(error);
        emit(AddressError(error));
      },
      (fetchedAddresses) {
        addresses = fetchedAddresses;
        emit(AddressLoaded(addresses));
      },
    );
  }

  Future<void> deleteAddress(String addressId) async {
    emit(AddressLoading());
    final result = await addressRepo.deleteAddress(addressId);
    result.fold(
      (error) {
        Print.error(error);
        emit(AddressError(error));
      },
      (message) {
        addresses.removeWhere((address) => address.id == addressId);
        emit(AddressSuccess(message));
        fetchAddresses();
      },
    );
  }

  Future<void> setDefaultAddress(String addressId) async {
    emit(AddressLoading());
    final result = await addressRepo.setDefaultAddress(addressId);
    result.fold(
      (error) {
        Print.error(error);
        emit(AddressError(error));
      },
      (message) {
        for (var address in addresses) {
          address.isDefault = address.id == addressId;
        }
        emit(AddressSuccess(message));
        fetchAddresses();
      },
    );
  }

  @override
  Future<void> close() {
    titleController.dispose();
    nameController.dispose();
    phoneController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipController.dispose();
    countryController.dispose();
    return super.close();
  }
}
