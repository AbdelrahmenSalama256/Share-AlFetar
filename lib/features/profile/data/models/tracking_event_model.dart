
//! TrackingEvent
class TrackingEvent {
  final int id;
  final int transactionId;
  final String title;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;

  TrackingEvent({
    required this.id,
    required this.transactionId,
    required this.title,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TrackingEvent.fromJson(Map<String, dynamic> json) {
    return TrackingEvent(
      id: json['id'] as int? ?? 0,
      transactionId: json['transaction_id'] as int? ?? 0,
      title: json['title']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_id': transactionId,
      'title': title,
      'text': text,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
