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
    List<String>? personsJson = prefs.getStringList('persons');
    print(personsJson!);
    return persons=personsJson.map((person) => Person.fromJson(jsonDecode(person))).toList();

  }
  Future refresh()async{
    setState(() {
      // Here when the user scroll down the screen it will automatically
      // refresh the Screen and show the new content.
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      body:RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
          itemCount: persons.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(persons[index].title),
              subtitle: Text('${persons[index].callerName}'),
              trailing: Text('After ${persons[index].remTime}'),
            );
          },
        ),
      ),
  );
  }
}
