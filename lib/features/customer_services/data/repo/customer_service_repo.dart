import 'dart:convert'; // For jsonEncode

import 'package:dartz/dartz.dart';

import '../../../../core/constants/widgets/errors/exceptions.dart';
import '../../../../core/database/api/api_consumer.dart';
import '../../../../core/database/api/end_points.dart';
import '../models/customer_service_model.dart';
import '../models/support_ticket_model.dart';

//! CustomerServiceRepo
class CustomerServiceRepo {
  final ApiConsumer api;

  CustomerServiceRepo(this.api);

  Future<Either<String, CustomerServiceResponse>> submitTicket({
    required String name,
    required String email,
    required String phone,
    required String category,
    required String subject,
    required String message,
    required String type,
    String? orderNumber,
    String? severity,
  }) async {
    try {

      final ticketData = {
        'name': name,
        'email': email,
        'phone': phone,
        'category': category,
        'message': message,
      };


      if (orderNumber != null && orderNumber.isNotEmpty) {
        ticketData['order_number'] = orderNumber;
      }

      if (severity != null) {
        ticketData['severity'] = severity;
      }


      final data = {
        'data': jsonEncode(ticketData),
        'type': type,
        'subject': subject,
      };

      final response = await api.post(
        EndPoints.submitTicket,
        data: data,
      );

      final responseData = response.data as Map<String, dynamic>;
      return Right(CustomerServiceResponse.fromJson(responseData));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, SupportTicketResponse>> getSupportTickets() async {
    try {
      final response = await api.get(EndPoints.getSupportTickets);
      final responseData = response.data as Map<String, dynamic>;
      return Right(SupportTicketResponse.fromJson(responseData));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }
}
