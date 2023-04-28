import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../phonelog.dart';
class local_history extends StatefulWidget {
  const local_history({Key? key}) : super(key: key);

  @override
  State<local_history> createState() => _local_historyState();
}
class _local_historyState extends State<local_history> {

  // InitState Function which run 1st when app start.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  List<Person> persons = [];
  // Load a list of Person objects from local storage
    Future<List<Person>> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> personsJson = prefs.getStringList('persons')??[];
    return persons=personsJson.map((person) => Person.fromJson(jsonDecode(person))).toList();
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      body:FutureBuilder<List<Person>>(
        future: _loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for the data
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Show an error message if there was an error fetching the data
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: persons.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(persons[index].title),
                  subtitle: Text(persons[index].callerName),
                  trailing: Text(persons[index].remTime),
                );
              },
            );
          }
        },
      )
  );
  }
}
