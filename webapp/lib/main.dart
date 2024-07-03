// ignore_for_file: use_build_context_synchronously, unused_field

import 'dart:convert';

import 'package:controler/dataenter.dart';
import 'package:controler/download_csi.dart';
import 'package:controler/fullregistraction_csi.dart';
import 'package:controler/csi2.dart';
import 'package:controler/menter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'circle1.dart'; // Importing circular indicator widget 1
import 'circle2.dart'; // Importing circular indicator widget 2

// Import dart:html for web-specific functionality

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double totalUsers = 0;
  double registeredUsers = 0;
  double shiveData = 0;
  double shivaDatatotal = 0;
  double ddrData = 0;
  double totalnewuser = 0;
  double ddrDatatotal = 0;
  double totalmen = 0;
  double totalwomen = 0;
  bool isLoading = true;
  final ScrollController _sideScrollController = ScrollController();
  final ScrollController _bottomScrollController = ScrollController();
  List<String> institutes = [];
  List<String> mentors = [];
  bool isLoading7 = true;
  @override
  void initState() {
    super.initState();
    fetchData(); // Fetching data when the widget initializes
  }

  Future<void> _fetchDataFromAPI2() async {
    final response = await http.get(Uri.https(
      '6udmxpz3sdcrnt6zcd5vfb644e0zqezb.lambda-url.ap-south-1.on.aws',
      '/path/to/endpoint',
      {
        'type': 'list',
        'need': 'complete',
      },
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

  void _showmentorDialog(BuildContext context) {
    String? selectedmentor;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Sort by Mentor'),
              content: _buildDropdown(
                mentors,
                selectedmentor,
                'Select Mentor',
                (String? value) {
                  setState(() {
                    selectedmentor = value;
                  });
                },
              ),
              actions: [
                Visibility(
                  visible: selectedmentor != null,
                  child: Column(
                    children: [
                      // TextButton(
                      //   onPressed: () {
                      //     Navigator.of(context).pop();
                      //   },
                      //   child: Text('Cancel'),
                      // ),
                      TextButton(
                        onPressed: () {
                          if (selectedmentor != null) {
                            // Split selected mentor's name into first name and last name
                            List<String> mentorNameParts =
                                selectedmentor!.split(' ');
                            String firstName = mentorNameParts[0];
                            String lastName = mentorNameParts.length > 1
                                ? mentorNameParts.sublist(1).join(' ')
                                : '';

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CSVViewer12(
                                  type: 'Query',
                                  need: 'mentor',
                                  download: 'menter',
                                  fname: selectedmentor.toString(),
                                  lname: lastName,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text('Confirm'),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showmentorDialogWrapper(BuildContext context) async {
    await _fetchDataFromAPI2();
    _showmentorDialog(context);
  }

  Future<void> _fetchDataFromAPI() async {
    final response = await http.get(Uri.https(
      '6udmxpz3sdcrnt6zcd5vfb644e0zqezb.lambda-url.ap-south-1.on.aws',
      '/path/to/endpoint',
      {
        'type': 'list',
        'need': 'complete',
      },
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
      isLoading7 = false;
    });
  }

  void _showCollegeDialog(BuildContext context) {
    String? selectedCollege;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Sort by College'),
              content: _buildDropdown(
                institutes,
                selectedCollege,
                'Select College',
                (String? value) {
                  setState(() {
                    selectedCollege = value;
                  });
                },
              ),
              actions: [
                Visibility(
                  visible: selectedCollege != null,
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          if (selectedCollege != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CSVViewer1(
                                  type: 'Query',
                                  need: 'college',
                                  name: selectedCollege!,
                                  download: 'collage',
                                  status: true,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text('All Students'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          if (selectedCollege != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CSVViewer1(
                                  type: 'Query',
                                  need: 'college',
                                  name: selectedCollege!,
                                  download: 'collage',
                                  status: false,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text('Register Students'),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
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

  Future<void> _showCollegeDialogWrapper(BuildContext context) async {
    await _fetchDataFromAPI();
    _showCollegeDialog(context);
  }

  // Function to fetch data from API
  Future<void> fetchData() async {
    final response = await http.get(Uri.https(
      '6udmxpz3sdcrnt6zcd5vfb644e0zqezb.lambda-url.ap-south-1.on.aws', // Your API endpoint
      '/path/to/endpoint', // Your endpoint path
      {'type': 'total'}, // Parameters for the API request
    ));
    if (response.statusCode == 200) {
      print(response.body);
      final data = jsonDecode(response.body);
      setState(() {
        totalUsers = data['totalUsers'] ?? 0;
        shiveData = data['shiveData'] ?? 0;
        totalmen = data['totalmen'] ?? 0;
        totalwomen = data['totalwomen'] ?? 0;
        totalnewuser = data['newRegistratio_total'] ?? 0;

        shivaDatatotal = data['shivadatatotal'] ?? 0;
        ddrData = data['ddrData'] ?? 0;
        ddrDatatotal = data['ddrdata'] ?? 0;
        registeredUsers = data['registeredUsers'] ?? 0;
        isLoading = false; // Setting isLoading to false after data is fetched
      });
    } else {
      print('Failed to load data'); // Handling failure to load data
      // Handle errors, display error message, or retry option
    }
  }

  // Function to handle refreshing data
  Future<void> _refreshData() async {
    setState(() {
      isLoading = true; // Setting isLoading to true before refreshing data
    });
    await fetchData(); // Refreshing data
  }

  // Placeholder function for confirming data
  void _confirmData(String scannedData) async {
    try {
      final response = await http.get(Uri.https(
        '6udmxpz3sdcrnt6zcd5vfb644e0zqezb.lambda-url.ap-south-1.on.aws',
        '/path/to/endpoint',
        {
          'type': 'id',
          'id': '$scannedData',
        },
      ));
      if (response.statusCode == 200) {
        print(response.body);
        final jsonData = json.decode(response.body);
        setState(() {
          _firstname = jsonData['First Name'].toString();
          _lastname = jsonData['Last Name'].toString();
          _gender = jsonData['Gender'].toString();
          _attendance = jsonData['Attendance'];
          _id1 = jsonData['Team ID'].toString();
          _id = jsonData['id'].toString();

          _designation = jsonData['designation'].toString();
          _email = jsonData['email'].toString();
          _mobile = jsonData['Mobile number'].toString();

          _Name_of_the_institute = jsonData['Name of the institute'].toString();
          _mentorname = jsonData['Mentorname(s)'].toString();
        });
        if (_attendance == false) {
          showResponseDialog(context, jsonData);
        } else {
          showResponseDialog(context, jsonData);

          final after = const Text('Already registered');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Response'),
                content: after,
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Send OK message to server
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        print(response.body);
        throw Exception('Failed to send data');
      }
    } catch (error) {
      print('Error sending data: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to send data: ID NOT FOUND'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

// Placeholder variables for user data
  String _firstname = '';
  String _lastname = '';
  String _id1 = '';
  String _id = '';

  String _mobile = '';
  String _gender = '';
  bool _attendance = false;
  String _designation = '';
  String _Name_of_the_institute = '';
  String _email = '';
  String _mentorname = '';

// Custom dialog to display user data
  void showResponseDialog(
      BuildContext context, Map<String, dynamic> responseData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Students Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Username: ${_firstname + ' ' + _lastname}'),
                Text('Gender: $_gender'),
                Text('Team id: $_id1'),
                Text('Name of the institute: $_Name_of_the_institute'),
                Text('Destination: $_designation'),
                Text('Mentor Name: $_mentorname'),
                Text('mobile No: $_mobile'),
                Text('Email: $_email'),
                Text('Attedance: $_attendance'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // if (_attendance == false) {
                //   sendOkMessage();
                // }
                ;
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double percentage =
        registeredUsers != 0 ? (registeredUsers / totalUsers) * 100 : 0;
    double percentage11 =
        ddrDatatotal != 0 ? (ddrData / ddrDatatotal) * 100 : 0;
    double percentage2 =
        shivaDatatotal != 0 ? (shiveData / shivaDatatotal) * 100 : 0;
    TextEditingController manualCodeController = TextEditingController();

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 39, 3, 59),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Center(
                        child: Text(
                          'Registration Status',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 170),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 83, 175, 221),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextField(
                                controller: manualCodeController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter your data',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 300),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: ElevatedButton(
                            onPressed: () {
                              _confirmData(manualCodeController.text);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: const Color.fromARGB(255, 214, 24, 24),
                              onPrimary: Colors.black,
                            ),
                            child: const Text(
                              'Confirm',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 100.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 255, 254, 254),
                                width: 2.0,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(60.0),
                            ),
                            child: Container(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 100),
                                      child: Row(
                                        children: [
                                          Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text(
                                                  'Total Students',
                                                  style: TextStyle(
                                                      fontSize: 30.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                CircleIndicator(
                                                  radius: 150.0,
                                                  percent: percentage / 100,
                                                  progressColor:
                                                      const Color.fromARGB(
                                                          255, 177, 14, 14),
                                                  centerText:
                                                      '${percentage.toStringAsFixed(1)}%',
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  '($registeredUsers / $totalUsers)',
                                                  style: const TextStyle(
                                                    fontSize: 20.0,
                                                  ),
                                                ),
                                                const Text(
                                                  '(Total Registration)',
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                              ],
                                            ),
                                          ),
                                          Center(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    TextButton(
                                                        onPressed: () {},
                                                        child: const Icon(
                                                          Icons.boy_outlined,
                                                          size: 75,
                                                        )),
                                                    Text(
                                                      '$totalmen',
                                                      style: const TextStyle(
                                                          fontSize: 30,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    TextButton(
                                                        onPressed: () {},
                                                        child: const Icon(
                                                          Icons.girl_outlined,
                                                          size: 75,
                                                        )),
                                                    Text(
                                                      '$totalwomen',
                                                      style: const TextStyle(
                                                          fontSize: 30,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 50,
                                          ),
                                          Column(
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  downloadCSV('Query', 'total',
                                                      'totalregis', context);

                                                  // _downloadCSV('Query',
                                                  //     'total','totalregis'); // Pass your desired type here
                                                },
                                                child: const Text('Download'),
                                              ),
                                              SizedBox(
                                                height: 40,
                                              ),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CSVViewer(
                                                                type: 'Query',
                                                                need: 'total',
                                                                download:
                                                                    'total',
                                                              )),
                                                    );
                                                  },
                                                  child: const Text('View')),
                                            ],
                                          ),

                                          /// _________________________________________________________________________________________________________________________colum__________________________________
                                          SizedBox(
                                            width: 40,
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'Spot Registration Count',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                '$totalnewuser',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(height: 10,),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        // _confirmData(manualCodeController.text);
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ManualDataEntryScreen()),
                                                        );
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: const Color
                                                            .fromARGB(
                                                            255, 214, 24, 24),
                                                        onPrimary: Colors.black,
                                                      ),
                                                      child: const Text(
                                                        'Enter Spot Registration',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 17),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 100.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 2.0,
                                    ),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(60.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          const Text(
                                            'SSSJKL Registration',
                                            style: TextStyle(
                                                fontSize: 30.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          CircleIndicator2(
                                            radius: 100.0,
                                            percent: percentage2 / 100,
                                            progressColor: Colors.green,
                                            centerText:
                                                '${percentage2.toStringAsFixed(1)}%',
                                          ),
                                          Text(
                                            '($shiveData / $shivaDatatotal)',
                                            style: const TextStyle(
                                              fontSize: 20.0,
                                            ),
                                          ),
                                          const Text(
                                            '(SSSJKLTotal Registration)',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(30.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 50,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    downloadCSV(
                                                        'Query',
                                                        'shiveData',
                                                        'sssjkl',
                                                        context);
                                                  },
                                                  child: const Text('Download'),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    CSVViewer(
                                                                      type:
                                                                          'Query',
                                                                      need:
                                                                          'shiveData',
                                                                      download:
                                                                          'sssjkl',
                                                                    )),
                                                      );
                                                    },
                                                    child: const Text('View')),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 2.0,
                                    ),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(60.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          const Text(
                                            'SSI Registration',
                                            style: TextStyle(
                                                fontSize: 30.0,
                                                fontWeight: FontWeight.bold),
                                          ),

                                          CircleIndicator2(
                                            radius: 100.0,
                                            percent: percentage11 / 100,
                                            progressColor: Colors.orange,
                                            centerText:
                                                '${percentage11.toStringAsFixed(1)}%',
                                          ),
                                          // const SizedBox(height: 10),
                                          const SizedBox(width: 30),

                                          Text(
                                            '($ddrData / $ddrDatatotal)',
                                            style: const TextStyle(
                                              fontSize: 20.0,
                                            ),
                                          ),
                                          const Text(
                                            '(SSITotal Registration)',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(30.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    downloadCSV(
                                                        'Query',
                                                        'ddrData',
                                                        'ssi',
                                                        context); // Pass your desired type here
                                                  },
                                                  child: const Text('Download'),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    CSVViewer(
                                                                      type:
                                                                          'Query',
                                                                      need:
                                                                          'ddrData',
                                                                      download:
                                                                          'ssi',
                                                                    )),
                                                      );
                                                    },
                                                    child: const Text('View')),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Container(
                          width: double.maxFinite,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Center the row horizontally
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _showCollegeDialogWrapper(context);
                                    //  showCollegeDialog(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onPrimary: Colors.black,
                                  ),
                                  child: const Text('sort by College'),
                                ),
                                // const SizedBox(width: 20),
                                // ElevatedButton(
                                //   onPressed: () {},
                                //   style: ElevatedButton.styleFrom(
                                //     primary: Colors.white,
                                //     onPrimary: Colors.black,
                                //   ),
                                //   child: const Text('Sort by Name'),
                                // ),
                                const SizedBox(width: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    //      Navigator.push(
                                    //                    context,
                                    //                    MaterialPageRoute(builder: (context) => YourWidget()),
                                    //                 );
                                    _showmentorDialogWrapper(context);
                                    //  showCollegeDialog(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onPrimary: Colors.black,
                                  ),
                                  child: const Text('Mentor List'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.3,
//                         child: ElevatedButton(
//                           onPressed: () {
// //                               // _confirmData(manualCodeController.text);
// // Navigator.push(
// //         context,
// //         MaterialPageRoute(builder: (context) => FirebaseDataScreen()),
// //       );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             primary: const Color.fromARGB(255, 214, 24, 24),
//                             onPrimary: Colors.black,
//                           ),
//                           child: const Text(
//                             'Enter sport Registraction111',
//                             style: TextStyle(color: Colors.white, fontSize: 17),
//                           ),
//                         ),
//                       ),
                     ],
                  ),
                ),
        ));
  }
}

////
///
///
// void _showCollegeDialog(BuildContext context) {
//   String? selectedCollege; // Variable to store the selected college

// void _showCollegeDialog(BuildContext context) {
//   String? selectedCollege; // Variable to store the selected college
//   List<String> collegeList = institutes; // Use the fetched list of colleges

//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           return AlertDialog(
//             title: Text('Sort by College'),
//             content: _buildDropdown(
//               collegeList, // Pass the fetched list of colleges
//               selectedCollege,
//               'Select College',
//               (String? value) {
//                 setState(() {
//                   selectedCollege = value; // Update selected college
//                 });
//               },
//             ),
//             actions: [
//               Visibility(
//                 visible: selectedCollege!= null,
//                 child: Column(
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         if (selectedCollege!= null) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => CSVViewer1(
//                                 type: 'Query',
//                                 need: 'college',
//                                 name: selectedCollege!, // Use selected college
//                                 download: 'collage',
//                                 status: true,
//                               ),
//                             ),
//                           );
//                         }
//                       },
//                       child: Text('All Students'),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         if (selectedCollege!= null) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => CSVViewer1(
//                                 type: 'Query',
//                                 need: 'college',
//                                 name: selectedCollege!, // Use selected college
//                                 download: 'collage',
//                                 status: false,
//                               ),
//                             ),
//                           );
//                         }
//                       },
//                       child: Text('Register Students'),
//                     ),
//                   ],
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('Cancel'),
//               ),
//             ],
//           );
//         },
//       );
//     },
//   );
// }

// // Call the _fetchDataFromAPI function before showing the dialog
// Future<void> _showCollegeDialogWrapper(BuildContext context) async {
//   await _fetchDataFromAPI();
//   _showCollegeDialog(context);
// }

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
// Future<void> _fetchDataFromAPI() async {
//   final response = await http.get(Uri.https(
//     '6udmxpz3sdcrnt6zcd5vfb644e0zqezb.lambda-url.ap-south-1.on.aws', // Your API endpoint
//     '/path/to/endpoint', // Your endpoint path
//     {
//       'type': 'list',
//       'need': 'complete',
//     }, // Parameters for the API request
//   ));

//   if (response.statusCode == 200) {
//     print(response.body);
//     final jsonData = jsonDecode(response.body);
//     setState(() {
//       institutes = List<String>.from(jsonData['college']);
//       mentors = List<String>.from(jsonData['mentor']);
//       // Adding 'Other' options for institutes and mentors
//       institutes.add('Other');
//       mentors.add('Other');
//     });
//   } else {
//     print('Failed to fetch data from API');
//   }

//   setState(() {
//     isLoading = false;
//   });
// }
// }

// void _showMentorListDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       String? selectedMentor; // Variable to store the selected mentor

//       return StatefulBuilder(
//         builder: (context, setState) {
//           return AlertDialog(
//             title: Text('Mentor List'),
//             content: DropdownButton<String>(
//               value: selectedMentor,
//               items: ['Prabhu P', 'Joseph Sathiadhas', 'Nirosh Kumar H', 'Nil']
//                   .map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: (String? value) {
//                 setState(() {
//                   selectedMentor = value; // Update selected mentor
//                 });
//               },
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('Cancel'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   print('$selectedMentor');
//                   if (selectedMentor != null) {
//                     // Split selected mentor's name into first name and last name
//                     List<String> mentorNameParts = selectedMentor!.split(' ');
//                     String firstName = mentorNameParts[0];
//                     String lastName = mentorNameParts.length > 1
//                         ? mentorNameParts.sublist(1).join(' ')
//                         : '';

//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => CSVViewer12(
//                           type: 'Query',
//                           need: 'mentor',
//                           download: 'menter',
//                           fname:selectedMentor.toString(),
//                           lname: lastName,
                          
//                         ),
//                       ),
//                     );
//                   }
//                 },
//                 child: Text('Confirm'),
//               ),
//             ],
//           );
//         },
//       );
//     },
//   );
// }
