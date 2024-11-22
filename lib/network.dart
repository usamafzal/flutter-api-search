// Import necessary packages for HTTP requests and JSON decoding
import 'dart:convert'; // For JSON encoding and decoding
import 'package:http/http.dart' as http; // For HTTP requests

import 'model.dart'; // Model Class for Data Representation

// Define a class to handle network-related operations
class NetworkService {
  // Define a static method to fetch data from a remote server
  static Future<List<DataModel>> fetchData() async {
    // URL of the API endpoint
    const url = "https://jsonplaceholder.typicode.com/posts";

    // Make an HTTP GET request to the specified URL
    final response = await http.get(Uri.parse(url));

    // Check if the response status code indicates success (HTTP 200 OK)
    if (response.statusCode == 200) {
      // Parse the response body (JSON) into a list of dynamic objects
      List<dynamic> jsonconvert = jsonDecode(response.body);

      // Convert the list of dynamic objects into a list of DataModel objects
      return jsonconvert.map((e) => DataModel.fromJson(e)).toList();
    } else {
      // Throw an exception if the HTTP request fails
      throw Exception("Error Fetch Data!");
    }
  }
}
