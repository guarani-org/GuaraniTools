import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Device.dart';

class ConnectionDialog extends StatefulWidget {
  @override
  _ConnectionDialogState createState() => _ConnectionDialogState();
}

class _ConnectionDialogState extends State<ConnectionDialog> {
  DeviceSettings deviceSettings = DeviceSettings();
  final inputIpController = TextEditingController();
  final inputPortController = TextEditingController();

  bool _inputValid = false;

  String _inputValidation(value) {
    if (value.isEmpty) {
      return 'Enter a value';
    }
    return null;
  }

  @override
  void dispose() {
    inputIpController.dispose();
    inputPortController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.wifi),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Connection Settings'),
          ),
        ],
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            validator: _inputValidation,
            controller: inputIpController,
            inputFormatters: [
              LengthLimitingTextInputFormatter(15),
            ],
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Ip Address',
              hintText: 'xxx.xxx.xxx.xxx',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            validator: _inputValidation,
            controller: inputPortController,
            inputFormatters: [
              LengthLimitingTextInputFormatter(5),
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Port',
              hintText: '8080',
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                color: Colors.red[800],
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => {Navigator.of(context).pop()},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                color: Colors.green[800],
                child: Text(
                  'Connect',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    deviceSettings.ip = inputIpController.text;
                    deviceSettings.port = int.parse(inputPortController.text);
                    _inputValid = true;
                  });
                  if (true == _inputValid) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
