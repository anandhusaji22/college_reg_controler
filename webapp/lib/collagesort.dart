// import 'package:controler/csi2.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class YourWidget extends StatefulWidget {
//   @override
//   _YourWidgetState createState() => _YourWidgetState();
// }

// class _YourWidgetState extends State<YourWidget> {
//   List<String> institutes = [];
//   List<String> mentors = [];
//   bool isLoading = true;

//   Future<void> _fetchDataFromAPI2() async {
//     final response = await http.get(Uri.https(
//       '6udmxpz3sdcrnt6zcd5vfb644e0zqezb.lambda-url.ap-south-1.on.aws', 
//       '/path/to/endpoint', 
//       {
//         'type': 'list',
//         'need': 'complete',
//       }, 
//     ));

//     if (response.statusCode == 200) {
//       print(response.body);
//       final jsonData = jsonDecode(response.body);
//       setState(() {
//         institutes = List<String>.from(jsonData['college']);
//         mentors = List<String>.from(jsonData['mentor']);
//         // Adding 'Other' options for institutes and mentors
//         institutes.add('Other');
//         mentors.add('Other');
//       });
//     } else {
//       print('Failed to fetch data from API');
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   void _showmentorDialog(BuildContext context) {
//     String? selectedmentor; 

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title: Text('Sort by Mentor'),
//               content: _buildDropdown(
//                 mentors, 
//                 selectedmentor,
//                 'Select Mentor',
//                 (String? value) {
//                   setState(() {
//                     selectedmentor = value; 
//                   });
//                 },
//               ),
//               actions: [
//                 Visibility(
//                   visible: selectedmentor!= null,
//                   child: Column(
//                     children: [
//                       TextButton(
//                         onPressed: () {
//                           if (selectedmentor!= null) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => CSVViewer1(
//                                   type: 'Query',
//                                   need: 'college',
//                                   name: selectedmentor!, 
//                                   download: 'collage',
//                                   status: true,
//                                 ),
//                               ),
//                             );
//                           }
//                         },
//                         child: Text('All Students'),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           if (selectedmentor!= null) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => CSVViewer1(
//                                   type: 'Query',
//                                   need: 'college',
//                                   name: selectedmentor!, 
//                                   download: 'collage',
//                                   status: false,
//                                 ),
//                               ),
//                             );
//                           }
//                         },
//                         child: Text('Register Students'),
//                       ),
//                     ],
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('Cancel'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
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

//   Future<void> _showmentorDialogWrapper(BuildContext context) async {
//     await _fetchDataFromAPI2();
//     _showmentorDialog(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Your App'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             _showCollegeDialogWrapper(context);
//           },
//           child: Text('Show Dialog'),
//         ),
//       ),
//     );
//   }
// }