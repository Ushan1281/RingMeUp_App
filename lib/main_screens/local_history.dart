import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[ Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: ListTile(
                title: Text("Call Reminder"),
                subtitle: Text("Call Back Ushan Patel after 10 min"),
                trailing: IconButton(icon:Icon(Icons.call,color: Colors.green,),
                  onPressed: () {  },),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              decoration: BoxDecoration(
              color: Colors.grey.shade100,
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: ListTile(
                title: Text("SMS Reminder"),
                subtitle: Text("You have to make SMS for Ushan Patel after 5 "
                    "min"),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: ListTile(
                title: Text("Call Reminder"),
                subtitle: Text("Call Back Smit Patel after 30 min"),
                trailing: IconButton(icon:Icon(Icons.call,color: Colors.green), onPressed:
                    () {  },),
              ),
            ),

          ],
        ),
      ),
]
    );
  }
}
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class local_history extends StatefulWidget {
//   @override
//   _local_historyState createState() => _local_historyState();
// }
//
// class _local_historyState extends State<local_history> {
//   List<String> _myList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadList();
//   }
//
//   // This method loads the list from SharedPreferences
//   _loadList() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String myListString = prefs.getString('myList') ?? '[]';
//     List<String> myList = List<String>.from(jsonDecode(myListString));
//     setState(() {
//       _myList = myList;
//     });
//   }
//
//   // This method saves the list to SharedPreferences
//   _saveList() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String myListString = jsonEncode(_myList);
//     prefs.setString('myList', myListString);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       body: ListView.builder(
//         itemCount: _myList.length,
//         itemBuilder: (BuildContext context, int index) {
//           return ListTile(
//             title: Text(_myList[index]),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: () async {
//           String newItem = await showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               TextEditingController controller = TextEditingController();
//               return AlertDialog(
//                 title: Text('Add Item'),
//                 content: TextField(
//                   controller: controller,
//                   decoration: InputDecoration(hintText: 'Item Name'),
//                 ),
//                 actions: [
//                   TextButton(
//                     child: Text('Cancel'),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                   TextButton(
//                     child: Text('Add'),
//                     onPressed: () {
//                       String itemName = controller.text.trim();
//                       Navigator.of(context).pop(itemName);
//                     },
//                   ),
//                 ],
//               );
//             },
//           );
//           if (newItem != null && newItem.isNotEmpty) {
//             setState(() {
//               _myList.add(newItem);
//             });
//             _saveList();
//           }
//         },
//       ),
//     );
//   }
// }
