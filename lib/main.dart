import 'dart:ffi';
import 'package:flutter/material.dart';

void main() => runApp(GniTools());

class GniTools extends StatefulWidget {
  @override
  _GniToolsState createState() => _GniToolsState();
}

class _GniToolsState extends State<GniTools> {
  Setting _selectedSetting = settings[1];

  void _select(Setting setting) {
    setState(() {
      _selectedSetting = setting;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Guarani Tools'),
          actions: <Widget>[
            IconButton(
                icon: Icon(settings[0].icon),
                onPressed: () => _select(settings[0])),
            IconButton(
                icon: Icon(settings[1].icon),
                onPressed: () => _select(settings[1])),
            IconButton(
                icon: Icon(settings[2].icon),
                onPressed: () => _select(settings[2])),
            IconButton(
                icon: Icon(settings[3].icon),
                onPressed: () => _select(settings[3]))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(5),
          child: ScreenCard(setting: _selectedSetting),
        ),
      ),
    );
  }
}

class Setting {
  const Setting({@required this.title, @required this.icon, this.body});
  final String title;
  final IconData icon;
  final Widget body;
}

const List<Setting> settings = const <Setting>[
  const Setting(
    title: 'Configuration',
    icon: Icons.settings,
    body: ConfigurationPage(),
  ),
  const Setting(
    title: 'Control',
    icon: Icons.control_point,
    body: SizedBox.shrink(),
  ),
  const Setting(
    title: 'Processing',
    icon: Icons.data_usage,
    body: SizedBox.shrink(),
  ),
  const Setting(
      title: 'Visualization',
      icon: Icons.scatter_plot_rounded,
      body: SizedBox.shrink())
];

class ScreenCard extends StatelessWidget {
  const ScreenCard({Key key, this.setting}) : super(key: key);
  final Setting setting;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //color: Colors.white,
      body: Center(
        child: setting.body,
      ),
    );
  }
}

// #### Not Implemented Page ####

class NotImplementedPage extends StatelessWidget {
  const NotImplementedPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Go Back'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}

// #### Configuration Page ####

class ConfigurationItem {
  const ConfigurationItem({this.title, this.icon, this.body});
  final String title;
  final IconData icon;
  final Widget body;
}

const List<ConfigurationItem> cfgItems = <ConfigurationItem>[
  ConfigurationItem(
      title: 'Sensors',
      icon: Icons.poll_outlined,
      body: SensorConfigurationPage()),
  ConfigurationItem(
    title: 'System',
    icon: Icons.system_update,
    body: NotImplementedPage(),
  ),
  ConfigurationItem(
    title: 'GPS',
    icon: Icons.gps_fixed_rounded,
    body: NotImplementedPage(),
  ),
  ConfigurationItem(
    title: 'Recording',
    icon: Icons.reorder,
    body: NotImplementedPage(),
  )
];

class ConfigurationCard extends StatelessWidget {
  const ConfigurationCard({this.item});
  final ConfigurationItem item;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.headline5;
    return MaterialButton(
      height: 200,
      elevation: 1,
      color: Colors.grey[300],
      onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => item.body)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            item.icon,
            size: 64,
            color: textStyle.color,
          ),
          Text(
            item.title,
            style: textStyle,
          )
        ],
      ),
    );
  }
}

class ConfigurationPage extends StatelessWidget {
  const ConfigurationPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GridView.count(
          padding: const EdgeInsets.all(20),
          shrinkWrap: true,
          primary: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          crossAxisSpacing: 20,
          childAspectRatio: 1.2,
          mainAxisSpacing: 10,
          children: <Widget>[
            ConfigurationCard(
              item: cfgItems[0],
            ),
            ConfigurationCard(
              item: cfgItems[1],
            ),
            ConfigurationCard(
              item: cfgItems[2],
            ),
            ConfigurationCard(
              item: cfgItems[3],
            ),
          ],
        ),
      ),
    );
  }
}

// ######## Sensor configuration page ########

class CancelAlertDialog {
  const CancelAlertDialog();
  void _onDefault(context) {
    Navigator.of(context).pop();
  }

  void _onDiscard(context) {
    Navigator.of(context).pop();
  }

  void _onCancel(context) {
    Navigator.of(context).pop();
  }

  void display(BuildContext context) {
    const TextStyle textStyle = TextStyle(fontWeight: FontWeight.bold);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.warning,
                    color: Colors.amber[300],
                  ),
                ),
                Text('Reset'),
              ],
            ),
            content: Text('Do you wish to reset the sensors configuration?'),
            actions: <FlatButton>[
              FlatButton(
                child: Text(
                  'Default Configuraiton',
                  style: textStyle,
                ),
                onPressed: () => _onDefault(context),
              ),
              FlatButton(
                child: Text(
                  'Discard Changes',
                  style: textStyle,
                ),
                onPressed: () => _onDiscard(context),
              ),
              FlatButton(
                child: Text(
                  'Cancel',
                  style: textStyle,
                ),
                onPressed: () => _onCancel(context),
              ),
            ],
          );
        });
  }
}

class SensorConfigurationPage extends StatelessWidget {
  const SensorConfigurationPage({Key key}) : super(key: key);

  void _showReset(context) {
    final CancelAlertDialog alert = CancelAlertDialog();
    alert.display(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          if (value == 2) {
            Navigator.pop(context);
          }
          if (value == 1) {
            //reset
            _showReset(context);
          }
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              color: Colors.green[700],
            ),
            title: Text('Apply'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restore),
            title: Text(
              'Reset',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.cancel,
              color: Colors.red[700],
            ),
            title: Text('cancel'),
          ),
        ],
      ),
      body: Center(
        child: GridView.count(
          padding: const EdgeInsets.all(20),
          shrinkWrap: true,
          primary: true,
          crossAxisCount: 2,
          children: <Widget>[sensorsConfig[0]],
        ),
      ),
    );
  }
}

List<SensorConfiguration> sensorsConfig = <SensorConfiguration>[
  SensorConfiguration(
    name: 'Accelerometer',
    partNumber: 'LSM9DS1',
    attributes: [
      SensorAttribute(name: 'decimation'),
      SensorAttribute(name: 'zAxisOutputEnable'),
      SensorAttribute(name: 'yAxisOutputEnable'),
      SensorAttribute(name: 'xAxisOutputEnable'),
      SensorAttribute(name: 'outputDataRate'),
      SensorAttribute(name: 'fullScale'),
      SensorAttribute(name: 'bandwidthSelection'),
      SensorAttribute(name: 'antialisingFilterBandwidthSelection'),
      SensorAttribute(name: 'highResolutionMode'),
      SensorAttribute(name: 'digitalFilterCutoffFrequency'),
      SensorAttribute(name: 'filteredDataSelection'),
      SensorAttribute(name: 'highPassFilterEnable'),
      SensorAttribute(name: 'bdu'),
      SensorAttribute(name: 'ble')
    ],
  ),
];

class SensorAttribute {
  SensorAttribute({this.name, this.value});
  final String name;
  Uint8 value;
}

class SensorCalibration {
  List<double> x;
  List<double> y;
  List<double> z;
}

class SensorConfiguration extends StatefulWidget {
  SensorConfiguration(
      {this.name,
      this.partNumber,
      this.bus,
      this.address,
      this.calibration,
      this.attributes});

  final List<SensorAttribute> attributes;
  final String bus;
  final Uint8 address;
  final SensorCalibration calibration;
  final String name;
  final String partNumber;

  @override
  _SensorConfigurationState createState() => _SensorConfigurationState(
      name: name,
      address: address,
      attributes: attributes,
      bus: bus,
      calibration: calibration,
      partNumber: partNumber);
}

class _SensorConfigurationState extends State<SensorConfiguration> {
  _SensorConfigurationState(
      {this.name,
      this.partNumber,
      this.bus,
      this.address,
      this.calibration,
      this.attributes});

  List<SensorAttribute> attributes;
  String bus;
  Uint8 address;
  SensorCalibration calibration;
  String name;
  String partNumber;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: Colors.grey[300],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Icon(Icons.scatter_plot_sharp),
          ),
          Text(
            name,
            style: Theme.of(context).textTheme.headline6,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Flexible(
              child: TextField(
                controller: TextEditingController(text: bus),
                decoration: const InputDecoration(
                  hintText: '/dev/i2c-1',
                  helperText: 'Bus',
                  border: UnderlineInputBorder(),
                ),
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Flexible(
              child: TextField(
                style: Theme.of(context).textTheme.bodyText2,
                controller: TextEditingController(text: partNumber),
                decoration: const InputDecoration(
                  hintText: 'LSM9DS01',
                  helperText: 'Part Number',
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Flexible(
              child: TextField(
                style: Theme.of(context).textTheme.bodyText2,
                controller: TextEditingController(text: address.toString()),
                decoration: const InputDecoration(
                  hintText: '0x00',
                  helperText: 'Address',
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisSpacing: 8,
                crossAxisCount: 8,
                children: List.generate(attributes.length, (index) {
                  return TextField(
                    style: Theme.of(context).textTheme.bodyText2,
                    controller: TextEditingController(
                        text: attributes[index].value.toString()),
                    decoration: const InputDecoration(
                        hintText: '0x00',
                        helperText: "attribute",
                        border: UnderlineInputBorder()),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
