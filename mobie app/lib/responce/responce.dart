import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResponseScreen extends StatefulWidget {
  final Map<String, dynamic> responseData;

  ResponseScreen({Key? key, required this.responseData}) : super(key: key);

  @override
  _ResponseScreenState createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  late String _firstname;
  late String _lastname;
  late String _gender;
  late bool _attendance;
  late String _id1;
  late String _id;
  late String _designation;
  late String _email;
  late String _mobile;
  late String _Name_of_the_institute;
  late String _mentorname;
  late bool _isVegetarian;
  late bool _isNonVegetarian;
  late String _foodSelection;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstname = widget.responseData['First Name'].toString();
    _lastname = widget.responseData['Last Name'].toString();
    _gender = widget.responseData['Gender'].toString();
    _attendance = widget.responseData['Attendance'];
    _id1 = widget.responseData['Team ID'].toString();
    _id = widget.responseData['id'].toString();
    _designation = widget.responseData['designation'].toString();
    _email = widget.responseData['email'].toString();
    _mobile = widget.responseData['Mobile number'].toString();
    _Name_of_the_institute =
        widget.responseData['Name of the institute'].toString();
    _mentorname = widget.responseData['Mentorname(s)'].toString();
    _isVegetarian = widget.responseData['veg'] == 'veg';
    _isNonVegetarian = !_isVegetarian;
    _foodSelection = _isVegetarian ? 'Veg' : 'Non-Veg';

    // Check if already attended, show dialog
    if (_attendance) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showAlreadyRegisteredDialog();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Student Details',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(50.0),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 22),
                    children: [
                      const TextSpan(
                        text: 'User Name: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: '$_firstname' +  ' $_lastname',
                        style: const TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 22),
                    children: [
                      const TextSpan(
                        text: 'Gender: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: '$_gender',
                        style: const TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 22),
                    children: [
                      const TextSpan(
                        text: 'Attendance: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: '$_attendance',
                        style: const TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 22),
                    children: [
                      const TextSpan(
                        text: 'Team ID: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: '$_id1',
                        style: const TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 22),
                    children: [
                      const TextSpan(
                        text: 'ID: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: '$_id',
                        style: const TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 22),
                    children: [
                      const TextSpan(
                        text: 'Designation: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: '$_designation',
                        style: const TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 22),
                    children: [
                      const TextSpan(
                        text: 'Email: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: '$_email',
                        style: const TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 22),
                    children: [
                      const TextSpan(
                        text: 'Mobile Number: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: '$_mobile',
                        style: const TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 22),
                    children: [
                      const TextSpan(
                        text: 'Institute Name: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: '$_Name_of_the_institute',
                        style: const TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 22),
                    children: [
                      const TextSpan(
                        text: 'Mentor Name(s): ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: '$_mentorname',
                        style: const TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                ListTile(
                  title: Text(
                    'Food',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  subtitle: Row(
                    children: [
                      Checkbox(
                        value: _isVegetarian,
                        onChanged: (value) {
                          setState(() {
                            _isVegetarian = value!;
                            _isNonVegetarian = !_isVegetarian;
                            _foodSelection = _isVegetarian ? 'Veg' : 'non veg';
                          });
                        },
                      ),
                      Text('Veg',style: TextStyle(fontSize: 22)),
                      Checkbox(
                        value: _isNonVegetarian,
                        onChanged: (value) {
                          setState(() {
                            _isNonVegetarian = value!;
                            _isVegetarian = !_isNonVegetarian;
                            _foodSelection = _isVegetarian ? 'veg' : 'non veg';
                          });
                        },
                      ),
                      Text('Non-Veg',style: TextStyle(fontSize: 22)),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Food Selection: $_foodSelection',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      sendOkMessage(_foodSelection);
                    },
                    child: Text('Make Enter'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to send OK message to server
  void sendOkMessage(String veg) async {
    setState(() {
      isLoading = true;
    });
    try {
      final now = DateTime.now();
      final response = await http.get(Uri.https(
        '6udmxpz3sdcrnt6zcd5vfb644e0zqezb.lambda-url.ap-south-1.on.aws',
        '/path/to/endpoint',
        {
          'type': 'atte',
          'id': '$_id',
          'update': '$now',
          'veg': veg,
        },
      ));
      if (response.body == 'done') {
        // Show "Done" animation with tick icon
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Done'),
              content: const Row(
                children: [
                  Icon(Icons.check, color: Colors.green,size: 40,),
                  SizedBox(width: 10),
                  Text('Registration Successful'),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.of(context).pop(); // Return to the main screen
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Show "Reupload"
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Failed'),
              content: const Text('Message upload failed. Do you want to reupload?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    sendOkMessage(veg); // Retry uploading
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      print('Error sending OK message: $error');
      // Handle error
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to show dialog indicating already registered
  void showAlreadyRegisteredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Already Registered'),
          content: const Text('This student is already registered.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Return to the main screen
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
