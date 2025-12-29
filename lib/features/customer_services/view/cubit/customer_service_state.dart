import '../../data/models/support_ticket_model.dart';

sealed class CustomerServiceState {}

final class CustomerServiceInitial extends CustomerServiceState {}

final class CustomerServiceLoading extends CustomerServiceState {}

final class CustomerServiceSuccess extends CustomerServiceState {
  final String message;

  CustomerServiceSuccess(this.message);
}

final class CustomerServiceError extends CustomerServiceState {
  final String message;

  CustomerServiceError(this.message);
}

final class CustomerServiceDataLoaded extends CustomerServiceState {}

final class CustomerServiceDataUpdated extends CustomerServiceState {}

final class SupportTicketsLoading extends CustomerServiceState {}

final class SupportTicketsLoaded extends CustomerServiceState {
  final List<SupportTicket> tickets;

  SupportTicketsLoaded(this.tickets);
}

final class SupportTicketsError extends CustomerServiceState {
  final String message;

  SupportTicketsError(this.message);
}
