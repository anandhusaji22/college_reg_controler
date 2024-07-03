import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'dart:html' as html;

class CSVViewer12 extends StatefulWidget {
  final String type;
  final String need;
  final String fname;
  final String lname;
  final String download;

  CSVViewer12( 
      {required this.type,
      required this.need,
      required this.fname,
      required this.lname,
      required this.download});

  @override
  _CSVViewer12State createState() => _CSVViewer12State();
}

class _CSVViewer12State extends State<CSVViewer12> {
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
        'fname': widget.fname,
        'lname': widget.lname,
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
           'fname': widget.fname,
        'lname': widget.lname,
        },
      ));

      final blob = html.Blob([response.bodyBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      final anchor = html.AnchorElement(href: url.toString())
        ..setAttribute('download', '${widget.fname}_${widget.lname}_${widget.download}.csv');

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




///
///
///
////
///
////
///
///
///
///
///import 'package:flutter/material.dart';

// // Predefined options for Gender, Name of Institution, and Mentor Name
// final List<String> genders = ['Male', 'Female', 'Not Specified'];
// final List<String> institutes = ['Institute A', 'Institute B', 'Institute C','Other'];
// final List<String> mentors = ['Mentor 1', 'Mentor 2', 'Mentor 3'];
// final List<String> Destination= ['Mentor', 'Student'];

// class ManualDataEntryScreen extends StatefulWidget {
//   @override
//   _ManualDataEntryScreenState createState() => _ManualDataEntryScreenState();
// }

// class _ManualDataEntryScreenState extends State<ManualDataEntryScreen> {
//   // Text editing controllers
//   final TextEditingController firstNameController = TextEditingController();
//   final TextEditingController lastNameController = TextEditingController();
//   final TextEditingController attendanceController = TextEditingController();
//   final TextEditingController teamIdController = TextEditingController();
//   final TextEditingController idController = TextEditingController();
//   final TextEditingController designationController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController mobileController = TextEditingController();
//   final TextEditingController otherInstituteController = TextEditingController();
//   final TextEditingController otherMentorController = TextEditingController();
//   final TextEditingController otherDestinationController = TextEditingController();

//   // Variables to store selected values, initialized to null
//   String? selectedGender;
//   String? selectedInstitute;
//   String? selectedMentor;
//   String? selecteddestination;
//   bool showOtherInstitute = false;
//   bool showOtherMentor = false;
//   bool showOtherDestination = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Manual Data Entry'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: _buildTextField(firstNameController, 'First Name'),
//                   ),
//                   SizedBox(width: 10),
//                   Expanded(
//                     child: _buildTextField(lastNameController, 'Last Name'),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10,),
//               Row(
//                 children: [
//                   Expanded(
//                     child: _buildDropdown(genders, selectedGender, 'Gender', (String? value) {
//                       setState(() {
//                         selectedGender = value;
//                       });
//                     }),
//                   ),
//                   SizedBox(width: 10),
//                   Expanded(
//                     child: _buildDropdown(Destination, selecteddestination, 'Designation', (String? value) {
//                       setState(() {
//                         selecteddestination = value;
//                         if (value == 'Other') {
//                           showOtherDestination = true;
//                         } else {
//                           showOtherDestination = false;
//                           otherDestinationController.clear();
//                         }
//                       });
//                     }),
//                   ),
//                 ],
//               ),
//               if (showOtherDestination)
//                 _buildTextField(otherDestinationController, 'Enter Designation'),
//               SizedBox(height: 10),
//               _buildTextField(teamIdController, 'Team ID'),
//               SizedBox(height: 10),
//               _buildTextField(emailController, 'Email'),
//               SizedBox(height: 10),
//               _buildTextField(mobileController, 'Mobile Number'),
//               SizedBox(height: 10),
//               _buildDropdown(institutes, selectedInstitute, 'Name of the Institute', (String? value) {
//                 setState(() {
//                   selectedInstitute = value;
//                   if (value == 'Other') {
//                     showOtherInstitute = true;
//                   } else {
//                     showOtherInstitute = false;
//                     otherInstituteController.clear();
//                   }
//                 });
//               }),
//               SizedBox(height: 10,),
//               if (showOtherInstitute)
//                 _buildTextField(otherInstituteController, 'Enter Institute Name'),
//               SizedBox(height: 10),
//               _buildDropdown(mentors, selectedMentor, 'Mentor Name', (String? value) {
//                 setState(() {
//                   selectedMentor = value;
//                   if (value == 'Other') {
//                     showOtherMentor = true;
//                   } else {
//                     showOtherMentor = false;
//                     otherMentorController.clear();
//                   }
//                 });
//               }),
//               SizedBox(height: 10,),
//               if (showOtherMentor)
//                 _buildTextField(otherMentorController, 'Enter Mentor Name'),
//               SizedBox(height: 20),
//               SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.3,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // Access the data entered
//                     String firstName = firstNameController.text;
//                     String lastName = lastNameController.text;
//                     String attendance = attendanceController.text;
//                     String teamId = teamIdController.text;
//                     String id = idController.text;
//                     String designation = designationController.text;
//                     String email = emailController.text;
//                     String mobile = mobileController.text;

//                     // Do something with the entered data
//                     // e.g., send it to an API, save it locally, etc.
//                   },
//                   style: ElevatedButton.styleFrom(
//                     primary: const Color.fromARGB(255, 214, 24, 24),
//                     onPrimary: Colors.black,
//                   ),
//                   child: const Text (
//                     'Submit',
//                     style: TextStyle(color: Colors.white, fontSize: 17),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(TextEditingController controller, String labelText) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: labelText,
//         border: OutlineInputBorder(),
//         contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       ),
//     );
//   }

//   Widget _buildDropdown(List<String> items, String? value, String labelText, void Function(String?) onChanged) {
//     return DropdownButtonFormField<String>(
//       value: value,
//       items: items.map((item) {
//         return DropdownMenuItem(
//           value: item,
//           child: Text(item),
//         );
//       }).toList(),
//       onChanged: onChanged,
//       decoration: InputDecoration(
//         labelText: labelText,
//         border: OutlineInputBorder(),
//         contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       ),
//     );
//   }
// }