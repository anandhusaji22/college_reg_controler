// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';



// class CollegeNameScreen extends StatefulWidget {
//   @override
//   _CollegeNameScreenState createState() => _CollegeNameScreenState();
// }

// class _CollegeNameScreenState extends State
// {
//   late String _selectedCollege;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Choose College'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             StreamBuilder(
//               stream: FirebaseFirestore.instance.collection('colleges').snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return CircularProgressIndicator();
//                 }
//                 List<String> collegeNames = [];
//                 for (int i = 0; i < snapshot.data!.docs.length; i++) {
//                   var college = snapshot.data!.docs[i];
//                   collegeNames.add(college['name']);
//                 }
//                 return DropdownButton(
//                   hint: Text('Select College'),
//                   value: _selectedCollege,
//                   onChanged: (newValue) {
//                     setState(() {
//                       _selectedCollege = newValue!;
//                     });
//                   },
//                   items: collegeNames.map(
//                     (String collegeName) {
//                       return DropdownMenuItem(
//                         value: collegeName,
//                         child: Text(collegeName),
//                       );
//                     },
//                   ).toList(),
//                 );
//               },
//             ),
//             SizedBox(height: 20),
//             Text(
//               _selectedCollege ?? 'No college selected',
//               style: TextStyle(fontSize: 20),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
