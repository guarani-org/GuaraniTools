import 'package:flutter/material.dart';

class FileItem {
  FileItem({this.dateTime, this.name, this.size});
  DateTime dateTime;
  int size;
  String name;
}

List<FileItem> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return FileItem(
        dateTime: DateTime.now(), name: 'Rec#000_File $index', size: index);
  });
}

class DeviceFilesCard extends StatefulWidget {
  @override
  _DeviceFilesCardState createState() => _DeviceFilesCardState();
}

class _DeviceFilesCardState extends State<DeviceFilesCard> {
  List<FileItem> _data = generateItems(8);
  Widget _buildRecordFilesTable() {
    return DataTable(
        columns: const <DataColumn>[
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Size')),
          DataColumn(label: Text('Name')),
        ],
        rows: _data
            .map((e) => DataRow(
                  cells: <DataCell>[
                    DataCell(Text(e.dateTime.toString())),
                    DataCell(Text(e.size.toString())),
                    DataCell(Text(e.name))
                  ],
                ))
            .toList());
  }

  // creates the recording expansion tile containing all files;
  Widget recording(String name) {
    return ExpansionTile(
      title: Text(name),
      leading: IconButton(
        tooltip: 'Download all',
        icon: Icon(Icons.file_download),
        onPressed: () => {},
      ),
      children: [_buildRecordFilesTable()],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Files',
            style: Theme.of(context).textTheme.headline4,
          ),
          recording('Rec#000'),
          recording('Rec#001'),
          recording('Rec#002')
        ],
      ),
    );
  }
}
