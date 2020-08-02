import 'package:flutter/material.dart';
import 'Device/DeviceCard.dart';

class ConfigurationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 300,
      child: Table(
        children: [TableRow(children: [])],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guarani Tools'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.devices), onPressed: () => {}),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => {},
          ),
          IconButton(
            icon: Icon(Icons.file_copy),
            onPressed: () => {},
          ),
          IconButton(
            icon: Icon(Icons.scatter_plot_rounded),
            onPressed: () => {},
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => {},
          )
        ],
      ),
      body: Center(
        child: Wrap(
          runSpacing: 24,
          spacing: 24,
          direction: Axis.horizontal,
          children: <Widget>[
            DeviceCard(),
          ],
        ),
      ),
    );
  }
}
