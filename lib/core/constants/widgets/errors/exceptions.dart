import 'package:dio/dio.dart';
import 'package:cozy/core/constants/app_constant.dart';
import 'package:cozy/core/network/local_network.dart';
import 'package:cozy/core/services/service_locator.dart';

import 'error_model.dart';

//!ServerException
class ServerException implements Exception {
  final ErrorModel errorModel;
  ServerException(this.errorModel);
}

//!No Internet
//! NoInternetException
class NoInternetException implements Exception {
  final ErrorModel errorModel;
  NoInternetException(this.errorModel);
}

//!CacheExeption
//! CacheException
class CacheException implements Exception {
  final String errorMessage;
  CacheException({required this.errorMessage});
}

//! BadCertificateException
class BadCertificateException extends ServerException {
  BadCertificateException(super.errorModel);
}

//! ConnectionTimeoutException
class ConnectionTimeoutException extends ServerException {
  ConnectionTimeoutException(super.errorModel);
}

//! BadResponseException
class BadResponseException extends ServerException {
  BadResponseException(super.errorModel);
}

//! ReceiveTimeoutException
class ReceiveTimeoutException extends ServerException {
  ReceiveTimeoutException(super.errorModel);
}

//! ConnectionErrorException
class ConnectionErrorException extends ServerException {
  ConnectionErrorException(super.errorModel);
}

//! SendTimeoutException
class SendTimeoutException extends ServerException {
  SendTimeoutException(super.errorModel);
}

//! UnauthorizedException
class UnauthorizedException extends ServerException {
  UnauthorizedException(super.errorModel);
}

//! ForbiddenException
class ForbiddenException extends ServerException {
  ForbiddenException(super.errorModel);
}

//! NotFoundException
class NotFoundException extends ServerException {
  NotFoundException(super.errorModel);
}

//! CofficientException
class CofficientException extends ServerException {
  CofficientException(super.errorModel);
}

//! CancelException
class CancelException extends ServerException {
  CancelException(super.errorModel);
}

//! UnknownException
class UnknownException extends ServerException {
  UnknownException(super.errorModel);
}

//! handleDioException
handleDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionError:
      throw ConnectionErrorException(ErrorModel(detail: e.error.toString()));
    case DioExceptionType.badCertificate:
      throw BadCertificateException(ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.connectionTimeout:
      throw ConnectionTimeoutException(ErrorModel(detail: e.error.toString()));

    case DioExceptionType.receiveTimeout:
      throw ReceiveTimeoutException(ErrorModel.fromJson(e.response!.data));

    case DioExceptionType.sendTimeout:
      throw SendTimeoutException(ErrorModel.fromJson(e.response!.data));

    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 400: // Bad request

          throw BadResponseException(ErrorModel.fromJson(e.response!.data));

        case 401: //unauthorized
          sl<CacheHelper>().removeData(key: AppConstants.token);
          sl<CacheHelper>().removeData(key: AppConstants.userType);
          sl<CacheHelper>().removeData(key: AppConstants.wssToken);
          sl<CacheHelper>().removeData(key: AppConstants.cookie);






          throw UnauthorizedException(ErrorModel.fromJson(e.response!.data));

        case 403: //forbidden
          throw ForbiddenException(ErrorModel.fromJson(e.response!.data));

        case 404: //not found
          throw NotFoundException(ErrorModel.fromJson(e.response!.data));

        case 409: //cofficient

          throw CofficientException(ErrorModel.fromJson(e.response!.data));

        case 413:
          throw BadResponseException(ErrorModel(detail: e.response!.data));

        case 422: //  Unprocessable Entity
          throw BadResponseException(ErrorModel.fromJson(e.response!.data));
        case 504: // Bad request
          throw BadResponseException(ErrorModel(
            detail: e.response!.data,
          ));
        case 500:
          throw BadResponseException(ErrorModel(detail: e.response!.data));
      }

    case DioExceptionType.cancel:
      throw CancelException(ErrorModel(detail: e.toString()));

    case DioExceptionType.unknown:
      throw UnknownException(ErrorModel(detail: e.toString()));
  }
}
