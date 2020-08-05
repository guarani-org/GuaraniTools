import 'package:flutter/material.dart';
import 'Device.dart';
import 'DeviceFilesCard.dart';

class DeviceScreen extends StatefulWidget {
  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

AppBar _buildBar() {
  return AppBar(
    title: Text('Device'),
    actions: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.link,
          size: 36,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.battery_unknown,
          size: 36,
        ),
      ),
    ],
  );
}

class _DeviceScreenState extends State<DeviceScreen> {
  Widget _buildBody(BuildContext context) {
    return Table(
      children: [
        TableRow(children: [
          DeviceFilesCard(),
        ])
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(),
      body: _buildBody(context),
    );
  }
}
