import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DeviceIdService {
  final FlutterSecureStorage _storage;
  static const String _deviceIdKey = 'device_id';

  DeviceIdService({required FlutterSecureStorage storage}) : _storage = storage;

  /// Gets the current device ID, generating one if it doesn't exist
  Future<String> getDeviceId() async {
    try {
      String? deviceId = await _storage.read(key: _deviceIdKey);

      if (deviceId == null || deviceId.isEmpty) {
        deviceId = _generateDeviceId();
        await _storage.write(key: _deviceIdKey, value: deviceId);
      }

      return deviceId;
    } catch (e) {
      // If there's an error reading from storage, generate a new ID
      // but don't store it to avoid overwriting existing data
      return _generateDeviceId();
    }
  }

  /// Generates a new unique device ID and stores it
  Future<String> regenerateDeviceId() async {
    try {
      final newDeviceId = _generateDeviceId();
      await _storage.write(key: _deviceIdKey, value: newDeviceId);
      return newDeviceId;
    } catch (e) {
      throw Exception('Failed to regenerate device ID: $e');
    }
  }

  /// Clears the stored device ID
  Future<void> clearDeviceId() async {
    try {
      await _storage.delete(key: _deviceIdKey);
    } catch (e) {
      throw Exception('Failed to clear device ID: $e');
    }
  }

  /// Generates a unique device ID using timestamp and random characters
  String _generateDeviceId() {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final Random random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // Generate 8 random characters
    String randomPart = '';
    for (int i = 0; i < 8; i++) {
      randomPart += chars[random.nextInt(chars.length)];
    }

    // Combine timestamp (last 8 digits) with random part
    final timestampPart = timestamp.toString().substring(
      timestamp.toString().length - 8,
    );

    return 'DEV-$timestampPart-$randomPart';
  }
}
