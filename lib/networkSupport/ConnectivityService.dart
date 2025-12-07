import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<ConnectivityResult> _streamController = StreamController<ConnectivityResult>.broadcast();

  Stream<ConnectivityResult> get connectivityStream => _streamController.stream;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Get initial status
      final initialResult = await _connectivity.checkConnectivity();
      _streamController.add(_getMainResult(initialResult));

      // Listen for changes
      _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
        _streamController.add(_getMainResult(results));
      });

      _isInitialized = true;
    } catch (e) {
      print('ConnectivityService initialization error: $e');
    }
  }

  ConnectivityResult _getMainResult(List<ConnectivityResult> results) {
    return results.isNotEmpty ? results.first : ConnectivityResult.none;
  }

  Future<bool> get isConnected async {
    try {
      final results = await _connectivity.checkConnectivity();
      return _getMainResult(results) != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    _streamController.close();
  }
}