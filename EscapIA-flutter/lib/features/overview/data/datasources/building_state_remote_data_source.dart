import 'dart:async';
import 'package:dio/dio.dart';
import 'package:escapia/core/constants/api_endpoints.dart';
import 'package:escapia/features/overview/data/models/zone_model.dart';
import 'package:signalr_netcore/ihub_protocol.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:escapia/core/errors/exceptions.dart';
import 'package:escapia/core/network/dio_interceptor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BuildingStateRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage storage;
  HubConnection? _hubConnection;

  final StreamController<ZoneModel> _controller =
      StreamController<ZoneModel>.broadcast();

  BuildingStateRemoteDataSource({
    required this.dio,
    FlutterSecureStorage? storage,
  }) : storage = storage ?? const FlutterSecureStorage();

  bool get _isConnected =>
      _hubConnection?.state == HubConnectionState.Connected;

  Future<void> connect() async {
    if (_isConnected) {
      print('[SignalR] Already connected, skipping.');
      return;
    }

    try {
      final token = await storage.read(key: DioInterceptor.tokenKey);
      final headers = MessageHeaders();
      if (token != null && token.isNotEmpty) {
        headers.setHeaderValue('Authorization', 'Bearer $token');
      }

      _hubConnection = HubConnectionBuilder()
          .withUrl(
            ApiEndpoints.hubUrl,
            options: HttpConnectionOptions(
              headers: headers,
              transport: HttpTransportType.WebSockets,
              skipNegotiation: false,
              requestTimeout: 15000,
            ),
          )
          .withAutomaticReconnect()
          .build();
      _hubConnection!.on('BuildingStateUpdated', (arguments) {
        if (arguments == null || arguments.isEmpty) return;
        final rawData = arguments.first;
        if (rawData is! Map) return;
        try {
          final json = Map<String, dynamic>.from(rawData);
          final zone = ZoneModel.fromJson(json);
          if (!_controller.isClosed) {
            _controller.add(zone);
          }
        } catch (e) {
          if (!_controller.isClosed) {
            _controller.addError(
              ServerException('Failed to parse SignalR update: $e'),
            );
          }
        }
      });
      print('[SignalR] Connecting to: ${ApiEndpoints.hubUrl}');
      await _hubConnection!.start();
      print('[SignalR] Connected successfully!');
    } catch (e) {
      print('[SignalR] Connection failed: $e');
      throw ServerException('Failed to connect to detection hub: $e');
    }
  }

  Future<List<ZoneModel>> fetchInitialState() async {
    if (!_isConnected) {
      await connect();
    }
    try {
      final response = await dio.get(
        ApiEndpoints.buildApiUrl,
      );
      if (response.statusCode == 200 && response.data is List) {
        final List data = response.data as List;
        return data
            .map((json) => ZoneModel.fromJson(Map<String, dynamic>.from(json)))
            .toList();
      }
      throw ServerException('Unexpected initial state response format');
    } catch (e) {
      print('[REST API] fetchInitialState failed: $e');
      throw ServerException(
        'Failed to load initial state from ${ApiEndpoints.buildApiUrl}: $e',
      );
    }
  }

  Stream<ZoneModel> watchBuildingState() {
    return _controller.stream;
  }

  Future<void> disconnect() async {
    await _hubConnection?.stop();
    _hubConnection = null;
  }
}
