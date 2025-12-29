import 'package:bloc/bloc.dart';
import 'package:cozy/core/services/service_locator.dart';
import 'package:flutter/material.dart';

import '../../../../core/cubit/global_cubit.dart';
import '../../data/models/support_ticket_model.dart';
import '../../data/repo/customer_service_repo.dart';
import 'customer_service_state.dart';

//! CustomerServiceCubit
class CustomerServiceCubit extends Cubit<CustomerServiceState> {
  CustomerServiceCubit() : super(CustomerServiceInitial());

  final CustomerServiceRepo _repo = sl<CustomerServiceRepo>();


  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController orderNumberController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController complaintController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  String selectedCategory = 'product_information';
  String complaintType = 'product_quality';
  String requestType = 'return';
  String returnReason = 'defective_product';


  int severityLevel = 2;


  final List<String> categories = [
    'product_information',
    'order_status',
    'shipping',
    'payment',
    'account',
    'other'
  ];

  final List<String> complaintTypes = [
    'product_quality',
    'customer_service',
    'delivery_issue',
    'website_app_issue',
    'billing_problem',
    'other'
  ];

  final List<String> requestTypes = ['return', 'refund', 'exchange'];

  final List<String> returnReasons = [
    'defective_product',
    'wrong_item',
    'not_as_described',
    'changed_mind',
    'size_issue',
    'other'
  ];


  void initializeWithUserData() {
    final globalCubit = sl<GlobalCubit>();
    final user = globalCubit.contactResponse?.data.user;

    if (user != null) {
      nameController.text = user.name ?? '';
      emailController.text = user.email ?? '';
      phoneController.text = user.mobile ?? '';
    }
    emit(CustomerServiceDataLoaded());
  }


  void updateSelectedCategory(String value) {
    selectedCategory = value;
    emit(CustomerServiceDataUpdated());
  }

  void updateComplaintType(String value) {
    complaintType = value;
    emit(CustomerServiceDataUpdated());
  }

  void updateRequestType(String value) {
    requestType = value;
    emit(CustomerServiceDataUpdated());
  }

  void updateReturnReason(String value) {
    returnReason = value;
    emit(CustomerServiceDataUpdated());
  }

  void updateSeverityLevel(int value) {
    severityLevel = value;
    emit(CustomerServiceDataUpdated());
  }

  Future<void> submitTicket({
    required String type, // inquiry, return, complaints
    String? orderNumber,
    int? severity,
  }) async {
    emit(CustomerServiceLoading());

    String category;
    String message;


    if (type == 'inquiry') {
      category = selectedCategory;
      message = messageController.text;
    } else if (type == 'complaints') {
      category = complaintType;
      message = complaintController.text;
    } else {
      category = returnReason;
      message = descriptionController.text;
    }

    final result = await _repo.submitTicket(
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      category: category,
      subject: subjectController.text,
      message: message,
      type: type,
      orderNumber: orderNumber,
      severity: severity.toString(),
    );

    result.fold(
      (error) => emit(CustomerServiceError(error)),
      (response) => emit(CustomerServiceSuccess(response.message)),
    );
  }

  void clearForm() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    subjectController.clear();
    messageController.clear();
    orderNumberController.clear();
    descriptionController.clear();
    complaintController.clear();

    selectedCategory = 'product_information';
    complaintType = 'product_quality';
    requestType = 'return';
    returnReason = 'defective_product';
    severityLevel = 2;

    emit(CustomerServiceDataUpdated());
  }

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    subjectController.dispose();
    messageController.dispose();
    orderNumberController.dispose();
    descriptionController.dispose();
    complaintController.dispose();
    return super.close();
  }

  List<SupportTicket> supportTickets = [];

  Future<void> getSupportTickets() async {
    emit(SupportTicketsLoading());

    final result = await _repo.getSupportTickets();

    result.fold(
      (error) => emit(SupportTicketsError(error)),
      (response) {
        supportTickets = response.tickets;
        emit(SupportTicketsLoaded(supportTickets));
      },
    );
  }
}
