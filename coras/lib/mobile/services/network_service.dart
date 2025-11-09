import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:coras/api_client.dart';

class NetworkService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  NetworkService() {
    _connectivity.onConnectivityChanged.listen((results) async {
      final online = await _hasInternet(results);
      _controller.add(online);
    });
  }

  Stream<bool> get status async* {
    final initial = await _connectivity.checkConnectivity();
    yield await _hasInternet(initial);
    yield* _controller.stream;
  }

  Future<bool> _hasInternet(List<ConnectivityResult> results) async {
    if (results.contains(ConnectivityResult.none)) return false;

    try {
      final response = await ApiClient.dio.get("/accounts/health-check/");
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static hasInternet() {}
}
