// Import required packages
import 'package:apicall/model.dart'; // Custom model class for data representation
import 'package:apicall/network.dart'; // Network service class for API calls
import 'package:flutter/material.dart'; // Flutter's material design package for UI elements
import 'package:http/http.dart' as http;

// Define a stateful widget for the homepage
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// State class for managing the HomePage's logic and UI
class _HomePageState extends State<HomePage> {
  // Declare a late-initialized Future for fetching data
  late Future<List<DataModel>> getData;

  // List to hold filtered data based on the search query
  List<DataModel> filterData = [];

  @override
  void initState() {
    super.initState();

    // Fetch data using the NetworkService's fetchData method
    getData = NetworkService.fetchData(http.Client());
    // Once data is fetched, update the filterData list using setState
    getData.then(
      (value) => setState(
        () {
          filterData = value;
        },
      ),
    );
  }

  // Method to filter data based on the search query
  void searchQuery(String query) {
    // Process the fetched data and filter it based on the query
    getData.then(
      (data) {
        setState(
          () {
            filterData = data
                .where(
                  (element) => (element.title!.toLowerCase().contains(
                          query.toLowerCase()) || // Match query in title
                      element.body!.toLowerCase().contains(
                            query.toLowerCase(),
                          )), // Match query in body
                )
                .toList(); // Convert filtered results into a list
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar title
        title: const Text("Api Search "),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: SafeArea(
          // Column layout for search field and data display
          child: Column(children: [
            // TextField for search functionality
            TextField(
              onChanged: (value) {
                // Call searchQuery whenever the input changes
                searchQuery(value);
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                hintText: "Search", // Placeholder text
                prefixIcon: Icon(Icons.search), // Search icon
              ),
            ),
            const SizedBox(
              height: 12, // Spacing between search field and data list
            ),
            // Expanded widget to allow the list to take up remaining space
            Expanded(
              child: RefreshIndicator(
                // This is the RefreshIndicator widget that shows a pull-to-refresh UI.
                // It triggers the onRefresh callback when the user swipes down on the screen.
                onRefresh: () async {
                  // Print a message when the refresh is triggered to indicate the start of data fetching.
                  debugPrint("Refresh triggered! Data Fetching");

                  // Simulate a delay of 2 seconds to mock data fetching.
                  await Future.delayed(const Duration(seconds: 2));

                  // Call the getData function to fetch the actual data.
                  await getData;

                  // After data fetching, call setState to rebuild the widget tree with the new data.
                  setState(() {});

                  // Print a message after the data has been refreshed and UI updated.
                  debugPrint("Refresh Data!");
                },
                child: FutureBuilder(
                  future: getData, // Use the fetched data future
                  builder: (context, snapshot) {
                    // Check if the snapshot has data
                    if (snapshot.hasData) {
                      return filterData.isEmpty
                          ? const Center(
                              // Display if no data matches the query
                              child: Text(
                                "No Data Found☹",
                                style: TextStyle(fontSize: 20),
                              ),
                            )
                          : ListView.builder(
                              // Build a list view for displaying filtered data
                              itemCount: filterData.length, // Number of items
                              itemBuilder: (context, index) {
                                final data = filterData[index];
                                return ListTile(
                                  title: Text(
                                    data.title.toString(), // Display the title
                                    textAlign: TextAlign.justify,
                                  ),
                                  leading: CircleAvatar(
                                    // Display the ID in a circular avatar
                                    child: Text(data.id.toString()),
                                  ),
                                );
                              },
                            );
                    } else if (snapshot.hasError) {
                      // Show an error message if an error occurs
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                    // Show a loading indicator while fetching data
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
