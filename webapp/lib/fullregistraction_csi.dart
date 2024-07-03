import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'dart:html' as html;

class CSVViewer extends StatefulWidget {
  final String type;
  final String need;
  final String download;

  CSVViewer({required this.type, required this.need, required this.download});

  @override
  _CSVViewerState createState() => _CSVViewerState();
}

class _CSVViewerState extends State<CSVViewer> {
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
    final response = await http.get(Uri.https(
      '6udmxpz3sdcrnt6zcd5vfb644e0zqezb.lambda-url.ap-south-1.on.aws',
      '/path/to/endpoint',
      {
        'type': widget.type,
        'need': widget.need,
      },
    ));
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
      final response = await http.get(Uri.https(
        '6udmxpz3sdcrnt6zcd5vfb644e0zqezb.lambda-url.ap-south-1.on.aws',
        '/path/to/endpoint',
        {
          'type': widget.type,
          'need': widget.need,
        },
      ));

      final csvString = utf8.decode(response.bodyBytes);
      final blob = html.Blob([csvString]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url.toString())
        ..setAttribute('download', '${widget.download}.csv');

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
      backgroundColor: const Color.fromARGB(255, 208, 206, 206), // Set background color to greywhite
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
    if (csvData.isNotEmpty && csvData.first.isNotEmpty) {
      return List.generate(
        csvData.first.length,
        (index) => DataColumn(
          label: Text(
            csvData.first[index].toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    return [];
  }

  List<DataRow> _buildRows() {
    if (csvData.isNotEmpty && csvData.length > 1) {
      return List.generate(
        csvData.length - 1, // Exclude header row
        (index) {
          return DataRow(
            cells: List.generate(
              csvData[index + 1].length,
              (cellIndex) => DataCell(
                Text(csvData[index + 1][cellIndex].toString()),
              ),
            ),
          );
        },
      );
    }
    return [];
  }
}
