import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as wsStatus;

enum ConnectionStatus { disconected, connecting, connected }

class DeviceSettings {
  static final DeviceSettings _instance = DeviceSettings._internal();

  DeviceSettings._internal();
  String ip = 'localhost';
  int port = 8080;

  factory DeviceSettings() {
    return _instance;
  }
}

class StatusInfo {
  const StatusInfo({this.color, this.text, this.icon, this.toolTipText});
  final Color color;
  final String text;
  final IconData icon;
  final String toolTipText;
}

class DeviceConnection {
  static final DeviceConnection _instance = DeviceConnection._internal();
  DeviceConnection._internal();
  factory DeviceConnection() {
    return _instance;
  }

  ConnectionStatus getConnectionStatus() {
    return connectionStatus;
  }

  final settings = DeviceSettings();
  IOWebSocketChannel _channel;
  ConnectionStatus connectionStatus;

  Future<void> disconnect() async {
    try {
      _channel.sink.close(wsStatus.goingAway);
      connectionStatus = ConnectionStatus.disconected;
    } catch (e) {}
  }

  Future<void> cancel() async {
    _channel.sink.close(wsStatus.goingAway);
    connectionStatus = ConnectionStatus.disconected;
  }

  Future<void> connect() async {
    connectionStatus = ConnectionStatus.connecting;
    try {
      _channel =
          IOWebSocketChannel.connect("ws://${settings.ip}:${settings.port}");
      _channel.sink.add("ping");
      await for (dynamic value in _channel.stream) {
        if (value.toString().isNotEmpty) {
          connectionStatus = ConnectionStatus.connected;
        } else {
          connectionStatus = ConnectionStatus.disconected;
        }
      }
    } catch (e) {
      connectionStatus = ConnectionStatus.disconected;
    }
  }
}
