










//! ErrorModel
class ErrorModel {
  final String detail;

  ErrorModel({required this.detail});

  factory ErrorModel.fromJson(Map<String, dynamic> jsonData) {
    String detailMessage;

    if (jsonData.containsKey('data') &&
        jsonData['data'] is Map<String, dynamic>) {

      final dataMap = jsonData['data'] as Map<String, dynamic>;
      final firstErrorMessages = dataMap.values.first;
      if (firstErrorMessages is List && firstErrorMessages.isNotEmpty) {
        detailMessage = firstErrorMessages.first;
      } else {
        detailMessage = 'An unknown error occurred in the data field';
      }
    } else if (jsonData.containsKey('message') &&
        jsonData['message'] is Map<String, dynamic>) {

      final messageMap = jsonData['message'] as Map<String, dynamic>;
      final firstErrorMessages = messageMap.values.first;
      if (firstErrorMessages is List && firstErrorMessages.isNotEmpty) {
        detailMessage = firstErrorMessages.first;
      } else {
        detailMessage = 'An unknown error occurred in the message field';
      }
    } else if (jsonData.containsKey('message') &&
        jsonData['message'] is String) {

      detailMessage = jsonData['message'];
    } else {

      detailMessage = 'An unknown error occurred';
    }

    return ErrorModel(
      detail: detailMessage,
    );
  }
}

