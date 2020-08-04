import 'Device.dart';
import 'package:flutter/material.dart';
import 'ConnectionDialog.dart';
import 'DeviceScreen.dart';

class ConnectionSnackInfo {
  const ConnectionSnackInfo({this.message, this.icon});
  final String message;
  final Icon icon;
}

class DeviceCard extends StatefulWidget {
  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  final Map<ConnectionStatus, ConnectionSnackInfo> snackMap = {
    ConnectionStatus.connected: ConnectionSnackInfo(
        icon: Icon(
          Icons.check,
          color: Colors.green,
        ),
        message: 'Device connected!'),
    ConnectionStatus.connecting: ConnectionSnackInfo(
        icon: Icon(
          Icons.loop,
          color: Colors.amber,
        ),
        message: 'Connecting to device...'),
    ConnectionStatus.disconected: ConnectionSnackInfo(
        icon: Icon(
          Icons.warning,
          color: Colors.amber,
        ),
        message: 'Device disconnected!')
  };

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

  DeviceConnection deviceConnection = DeviceConnection();
  ConnectionStatus connectionStatus = ConnectionStatus.disconected;

  Widget getSnackBar({ConnectionStatus status, bool error = false}) {
    if (error == false) {
      return SnackBar(
        content: Row(children: [
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: snackMap[status].icon),
          Text(snackMap[status].message),
        ]),
      );
    }
    return SnackBar(
      content: Row(children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Icon(Icons.error, color: Colors.red),
        ),
        Text("Connection error!"),
      ]),
    );
  }

  Future<void> disconnect(BuildContext context) async {
    await deviceConnection.disconnect();
    setState(() {
      connectionStatus = deviceConnection.getConnectionStatus();
    });
    if (connectionStatus == ConnectionStatus.disconected) {
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(getSnackBar(status: connectionStatus));
    }
  }

  Future<void> cancel(BuildContext context) async {
    await deviceConnection.cancel();
    setState(() {
      connectionStatus = deviceConnection.getConnectionStatus();
    });
  }

  Future<void> connect(BuildContext context) async {
    setState(() {
      connectionStatus = ConnectionStatus.connecting;
    });

    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(getSnackBar(status: connectionStatus));

    await deviceConnection.connect().then((_) {
      setState(() {
        connectionStatus = deviceConnection.getConnectionStatus();
      });

      if (connectionStatus == ConnectionStatus.connected) {
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context)
            .showSnackBar(getSnackBar(status: connectionStatus));
      } else {
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context)
            .showSnackBar(getSnackBar(status: connectionStatus, error: true));
      }
    });
  }

  void onConnectButtonPressed(BuildContext context) {
    if (connectionStatus == ConnectionStatus.connected) {
      disconnect(context);
      return;
    }
    if (connectionStatus == ConnectionStatus.connecting) {
      cancel(context);
      return;
    }
    if (connectionStatus == ConnectionStatus.disconected) {
      showDialog(context: context, child: ConnectionDialog()).then((value) {
        if (value == true) {
          connect(context);
        }
      });
    }
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
            FlatButton(
                child: Icon(
                  Icons.devices,
                  size: 64,
                  color: Theme.of(context).colorScheme.primaryVariant,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DeviceScreen()));
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Device',
                  style: Theme.of(context).textTheme.headline4,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 6),
                  child: Tooltip(
                    message: statusMap[connectionStatus].toolTipText,
                    child: FlatButton(
                      child: Icon(
                        statusMap[connectionStatus].icon,
                        color: statusMap[connectionStatus].color,
                        size: 48,
                      ),
                      onPressed: () => onConnectButtonPressed(context),
                    ),
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
