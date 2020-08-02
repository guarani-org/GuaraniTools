import 'Device.dart';
import 'package:flutter/material.dart';
import 'ConnectionDialog.dart';

class DeviceCard extends StatefulWidget {
  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  final Map<ConnectionStatus, StatusInfo> statusMap = {
    ConnectionStatus.connected: StatusInfo(
        color: Colors.green[600],
        text: 'Connected',
        icon: Icons.link,
        toolTipText: 'Disconnect'),
    ConnectionStatus.connecting: StatusInfo(
        color: Colors.amber[600],
        text: 'Connecting',
        icon: Icons.link_off,
        toolTipText: 'Cancel'),
    ConnectionStatus.disconected: StatusInfo(
        color: Colors.grey[600],
        text: 'Disconnected',
        icon: Icons.link_off,
        toolTipText: 'Connect'),
  };

  DeviceSettings deviceSettings = DeviceSettings();
  ConnectionStatus connectionStatus = ConnectionStatus.disconected;

  Future<void> disconnect(BuildContext context) async {
    await deviceSettings.disconnect();
    setState(() {
      connectionStatus = deviceSettings.status;
    });
    if (connectionStatus == ConnectionStatus.disconected) {
      final snack = SnackBar(
        content: Row(children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.warning,
              color: Colors.amber,
            ),
          ),
          Text('Device disconnected!'),
        ]),
      );
      Scaffold.of(context).showSnackBar(snack);
    }
  }

  Future<void> cancel(BuildContext context) async {
    await deviceSettings.cancel();
    setState(() {
      connectionStatus = deviceSettings.status;
    });
  }

  Future<void> connect(BuildContext context) async {
    setState(() {
      connectionStatus = ConnectionStatus.connecting;
    });

    await deviceSettings.connect().then((_) {
      setState(() {
        connectionStatus = deviceSettings.status;
      });

      if (connectionStatus == ConnectionStatus.connected) {
        final snack = SnackBar(
          content: Row(children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.check,
                color: Colors.green,
              ),
            ),
            Text(
                'Device connected! Ip: ${deviceSettings.ip} Port: ${deviceSettings.port}'),
          ]),
        );
        Scaffold.of(context).showSnackBar(snack);
      } else {
        final snack = SnackBar(
          content: Row(children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.error,
                color: Colors.red,
              ),
            ),
            Text('Unable to connect to device!'),
          ]),
        );
        Scaffold.of(context).showSnackBar(snack);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 220,
      child: Card(
        elevation: 8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.devices,
              size: 64,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Device',
                  style: Theme.of(context).textTheme.headline4,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: IconButton(
                    icon: Icon(
                      statusMap[connectionStatus].icon,
                      color: statusMap[connectionStatus].color,
                      size: 48,
                    ),
                    tooltip: statusMap[connectionStatus].toolTipText,
                    onPressed: () {
                      if (connectionStatus == ConnectionStatus.connected) {
                        disconnect(context);
                        return;
                      }
                      if (connectionStatus == ConnectionStatus.connecting) {
                        cancel(context);
                        return;
                      }
                      if (connectionStatus == ConnectionStatus.disconected) {
                        showDialog(context: context, child: ConnectionDialog())
                            .then((value) => connect(context));
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
