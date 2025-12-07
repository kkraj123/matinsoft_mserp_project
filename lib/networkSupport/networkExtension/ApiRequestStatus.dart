enum ApiStatus { initial, loading, success, error }

extension ApiRequestStatus on ApiStatus {
  bool get isInitial => this == ApiStatus.initial;

  bool get isLoading => this == ApiStatus.loading;

  bool get isSuccess => this == ApiStatus.success;

  bool get isError => this == ApiStatus.error;
}
