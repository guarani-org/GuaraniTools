import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as wsStatus;

enum ConnectionStatus { disconected, connecting, connected }

class DeviceSettings {
  static final DeviceSettings _instance = DeviceSettings._internal();
  DeviceSettings._internal();
  String ip = '192.168.0.27';
  int port = 8080;
  ConnectionStatus status;
  IOWebSocketChannel channel;

  factory DeviceSettings() {
    return _instance;
  }

  Future<void> disconnect() async {
    try {
      channel.sink.close(wsStatus.goingAway);
      status = ConnectionStatus.disconected;
    } catch (e) {}
  }

  Future<void> cancel() async {
    channel.sink.close(wsStatus.goingAway);
    status = ConnectionStatus.disconected;
  }

  Future<void> connect() async {
    status = ConnectionStatus.connecting;
    try {
      channel = IOWebSocketChannel.connect("ws://$ip:$port");
      channel.sink.add("ping");
      await for (dynamic value in channel.stream) {
        if (value.toString().isNotEmpty) {
          status = ConnectionStatus.connected;
        } else {
          status = ConnectionStatus.disconected;
        }
      }
    } catch (e) {
      status = ConnectionStatus.disconected;
    }
  }
}

class StatusInfo {
  const StatusInfo({this.color, this.text, this.icon, this.toolTipText});
  final Color color;
  final String text;
  final IconData icon;
  final String toolTipText;
}
