// ignore_for_file: unused_field

enum RequestStatus { success, error, loading, none }

class RequestState {
  final RequestStatus requestStatus;
  final String? error;
  RequestState(this.requestStatus, this.error);
}
