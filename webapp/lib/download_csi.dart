import 'dart:html' as html; // Import the 'html' library for web-specific functionality
import 'package:flutter/material.dart'; // Import Flutter Material library for UI components
import 'package:http/http.dart' as http; // Import the 'http' package for making HTTP requests

Future<void> downloadCSV(String type, String need, String download,context) async {
  try {
    final response = await http.get(Uri.https(
      '6udmxpz3sdcrnt6zcd5vfb644e0zqezb.lambda-url.ap-south-1.on.aws', // Your API endpoint
      '/path/to/endpoint', // Your endpoint path
      {
        'type': type,
        'need': need,
      }, // Parameters for the API request
    ));

    final blob = html.Blob(
        [response.bodyBytes]); // Create a Blob from response body bytes
    final url =
        html.Url.createObjectUrlFromBlob(blob); // Create URL from Blob

    // Create an anchor element and set download attribute
    final anchor = html.AnchorElement(href: url.toString())
      ..setAttribute('download',
          '$download.csv'); // Set the filename for the downloaded file

    // Simulate click on the anchor element to trigger download
    anchor.click();

    // Revoke the URL to release resources
    html.Url.revokeObjectUrl(url);

    // Show a snackbar indicating successful download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('CSV file downloaded successfully'),
      ),
    );
  } catch (e) {
    // Handle errors and show a snackbar indicating failure
    print('Error downloading CSV: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to download CSV file'),
      ),
    );
  }
}
