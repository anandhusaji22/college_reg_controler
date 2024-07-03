// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:controler/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManualDataEntryScreen extends StatefulWidget {
  @override
  _ManualDataEntryScreenState createState() => _ManualDataEntryScreenState();
}

class _ManualDataEntryScreenState extends State<ManualDataEntryScreen> {
  // Text editing controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController attendanceController = TextEditingController();
  final TextEditingController teamIdController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otherInstituteController =
      TextEditingController();
  final TextEditingController otherMentorController = TextEditingController();
  final TextEditingController otherDestinationController =
      TextEditingController();

  // Variables to store selected values, initialized to null
  String? selectedGender;
  String? selectedInstitute;
  String? selectedMentor;
  String? finalinst;
    String? veg;
 String? selectedInstituteValue;
 String? selectedmentorValue;
  String? selecteddestination;
  bool showOtherInstitute = false;
  bool showOtherMentor = false;
  bool showOtherDestination = false;

  // Lists to store institute names and mentor names from API
  List<String> institutes = [];
  List<String> mentors = [];

  // Boolean to show loading indicator
  bool isLoading = true;

  // Timer to check if loading takes more than 10 seconds
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchDataFromAPI();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && _timer == null) {
      _timer = Timer(Duration(seconds: 10), () {
        setState(() {
          isLoading = false;
        });
      });
    }

    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('Manual Data Entry'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                              firstNameController, 'First Name'),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child:
                              _buildTextField(lastNameController, 'Last Name'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                              ['Male', 'Female', 'Not Specified'],
                              selectedGender,
                              'Gender', (String? value) {
                            setState(() {
                              selectedGender = value;
                            });
                          }),
                        ),
                        SizedBox(width: 10),
                       Expanded(
  child: _buildDropdown(
    ['Mentor', 'Member'],
    selecteddestination,
    'Designation', 
    (String? value) {
      setState(() {
        selecteddestination = value;
        print('Selected destination: $selecteddestination'); // Print the selected destination
        if (value == 'Other') {
          showOtherDestination = true;
        } else {
          showOtherDestination = false;
          otherDestinationController.clear();
        }
      });
    }
  ),
),

                      ],
                    ),
                    // if (showOtherDestination)
                    //   _buildTextField(
                    //       otherDestinationController, 'Enter Designation'),
                    // SizedBox(height: 10),
                    // _buildTextField(teamIdController, 'Team ID'),
                    SizedBox(height: 10),
                    _buildTextField(emailController, 'Email'),
                    SizedBox(height: 10),
                    _buildTextField(mobileController, 'Mobile Number'),
                                        const SizedBox(height: 10),

                     _buildDropdown(
                              ['veg', 'non veg', ],
                              veg,
                              'food', (String? value) {
                            setState(() {
                              veg = value;
                            });
                          }),
                    SizedBox(height: 10),
                    _buildDropdown(
                        institutes, selectedInstitute, 'Name of the Institute',
                        (String? value) {
                      setState(() {
                        selectedInstitute = value;
                        if (value == 'Other') {
                          showOtherInstitute = true;
                        } else {
                          showOtherInstitute = false;
                          otherInstituteController.clear();
                        }
                      });
                    }),
                    SizedBox(
                      height: 10,
                    ),
                    if (showOtherInstitute)
                      _buildTextField(
                          otherInstituteController, 'Enter Institute Name'),
                    SizedBox(height: 10),
                    _buildDropdown(mentors, selectedMentor, 'Mentor Name',
                        (String? value) {
                      setState(() {
                        selectedMentor = value;
                        if (value == 'Other') {
                          showOtherMentor = true;
                        } else {
                          showOtherMentor = false;
                          otherMentorController.clear();
                        }
                      });
                    }),
                    SizedBox(
                      height: 10,
                    ),
                    if (showOtherMentor)
                      _buildTextField(
                          otherMentorController, 'Enter Mentor Name'),
                    SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: ElevatedButton(
                        onPressed: () {
                          
 
  if (showOtherInstitute) {
    selectedInstituteValue = otherInstituteController.text;
  } else {
    selectedInstituteValue = selectedInstitute;
  }
  if (showOtherMentor) {
    selectedmentorValue = otherMentorController.text;
  } else {
    selectedmentorValue = selectedMentor;
  }
                         fetchData(context, firstNameController.text, lastNameController.text, attendanceController.text, selectedmentorValue.toString(), idController.text, selecteddestination.toString(), emailController.text, selectedGender.toString(), selectedInstituteValue.toString(), veg.toString(), mobileController.text);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 214, 24, 24),
                          onPrimary: Colors.black,
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String? value, String labelText,
      void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Future<void> _fetchDataFromAPI() async {
    final response = await http.get(Uri.https(
      '6udmxpz3sdcrnt6zcd5vfb644e0zqezb.lambda-url.ap-south-1.on.aws', // Your API endpoint
      '/path/to/endpoint', // Your endpoint path
      {
        'type': 'list',
        'need': 'complete',
      }, // Parameters for the API request
    ));

    if (response.statusCode == 200) {
      print(response.body);
      final jsonData = jsonDecode(response.body);
      setState(() {
        institutes = List<String>.from(jsonData['college']);
        mentors = List<String>.from(jsonData['mentor']);
        // Adding 'Other' options for institutes and mentors
        institutes.add('Other');
        mentors.add('Other');
      });
    } else {
      print('Failed to fetch data from API');
    }

    setState(() {
      isLoading = false;
    });
  }
}





Future<void> fetchData(
  BuildContext context,
  String firstName,
  String lastName,
  String attendance,
  String teamId,
  String id,
  String designation,
  String email,
  String gender,
  String institute,
  String veg,
  String mobile,
) async {
  final now = DateTime.now();

  String data =
      '{"id": "$id","Attendance": "true","Date & Time": "$now","designation": "$designation","email": "$email","First Name": "$firstName $lastName","Gender": "$gender","Last Name": "","Mobile number": "$mobile","Name of the institute": "$institute","Team ID": "$teamId","veg": "$veg"}';

  final response = await http.get(
    Uri.https(
      '6udmxpz3sdcrnt6zcd5vfb644e0zqezb.lambda-url.ap-south-1.on.aws',
      '/path/to/endpoint',
      {
        'type': 'newreg',
        'data': data,
      },
    ),
  );

  if (response.body == "sucesses") {
    print(response.body);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.body),
        duration: const Duration(seconds: 2),
      ),
    );
    // Navigator.pop(context); // Remove current screen from stack
     Navigator.pop(context); // Remove previous screen from stack
    
    //  Navigator.push(
    //                           context,
    //                           MaterialPageRoute(
    //                             builder: (context) =>MyHomePage()
    //                           ),
    //                         ); // Navigate to home screen
  } else {
    print(response.body);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('kk'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
