import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'dart:html' as html;

class CSVViewer1 extends StatefulWidget {
  final String type;
  final String need;
  final String name;
  final bool status;
  final String download;

  CSVViewer1({
    Key? key,
    required this.type,
    required this.need,
    required this.name,
    required this.status,
    required this.download,
  }) : super(key: key);

  @override
  _CSVViewer1State createState() => _CSVViewer1State();
}

class _CSVViewer1State extends State<CSVViewer1> {
  List<List<dynamic>> csvData = [];
  bool _isLoading = true;
  final ScrollController _sideScrollController = ScrollController();
  final ScrollController _bottomScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchCSVData();
  }

  Future<void> fetchCSVData() async {
    final response = await http.get(
      Uri.https(
        '6udmxpz3sdcrnt6zcd5vfb644e0zqezb.lambda-url.ap-south-1.on.aws',
        '/path/to/endpoint',
        {
          'type': widget.type,
          'need': widget.need,
          'name': widget.name,
          'status': widget.status.toString(),
        },
      ),
    );
    if (response.statusCode == 200) {
      final csvString = response.body;
      List<List<dynamic>> parsedCSV = CsvToListConverter().convert(csvString);
      setState(() {
        csvData = parsedCSV;
        _isLoading = false;
      });
    } else {
      print('Failed to load CSV');
    }
  }

  Future<void> _downloadCSV() async {
    try {
      final response = await http.get(
        Uri.https(
          '6udmxpz3sdcrnt6zcd5vfb644e0zqezb.lambda-url.ap-south-1.on.aws',
          '/path/to/endpoint',
          {
            'type': widget.type,
            'need': widget.need,
                      'name': widget.name,
                                'status': widget.status.toString(),


          },
        ),
      );

      final blob = html.Blob([response.bodyBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      final anchor = html.AnchorElement(href: url.toString())
        ..setAttribute('download', '_${widget.name}_${widget.download}.csv');


      anchor.click();

      html.Url.revokeObjectUrl(url);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('CSV file downloaded successfully'),
        ),
      );
    } catch (e) {
      print('Error downloading CSV: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to download CSV file'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CSV Viewer'),
      ),
      body: Column(
        children: [
          if (_isLoading)
            Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          if (!_isLoading && csvData.isNotEmpty)
            Expanded(
              child: Scrollbar(
                controller: _sideScrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _sideScrollController,
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    controller: _bottomScrollController,
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columns: _buildColumns(),
                      rows: _buildRows(),
                    ),
                  ),
                ),
              ),
            ),
          SizedBox(height: 16), // Add some space between the table and the button
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _downloadCSV,
        backgroundColor: Colors.grey[200], // Set button color to greywhite
        child: Icon(Icons.file_download),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    if (csvData.isNotEmpty) {
      return List.generate(
        csvData[0].length,
        (index) => DataColumn(
          label: Text(
            csvData[0][index].toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    return [];
  }

  List<DataRow> _buildRows() {
    List<DataRow> rows = [];
    for (int i = 1; i < csvData.length; i++) {
      List<DataCell> cells = [];
      for (int j = 0; j < csvData[i].length; j++) {
        cells.add(DataCell(Text(csvData[i][j].toString())));
      }
      rows.add(DataRow(cells: cells));
    }
    return rows;
  }
}
