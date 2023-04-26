import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:ringmeup/notification_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './calllog.dart';
import 'package:flutter_sms/flutter_sms.dart';

class Person {
  String title;
  String callerName;
  String remTime;

  Person({required this.title, required this.callerName,required this.remTime});

  // Convert the Person object to a JSON map
  Map<String, dynamic> toJson() => {'title': title, 'callerName': callerName,
    'remTime':remTime};

  // Create a Person object from a JSON map
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      title: json['title'],
      callerName: json['callerName'],
      remTime: json['remTime']
    );
  }
}


class phonelog extends StatefulWidget {
  @override
  _phonelogState createState() => _phonelogState();
}

class _phonelogState extends State<phonelog> with  WidgetsBindingObserver {
  CallLogs cl = new CallLogs();
  // late Future<Iterable<CallLogEntry>> logs;
  NotificationServices notification=NotificationServices();
  @override
  void initState(){
    super.initState();
    notification.initNotification();
    cl.getCallLogs();
  }
  //text editing controller for text field
  TextEditingController description = TextEditingController();
  TextEditingController timeinput = TextEditingController();
  Future refresh() async{
    setState(() {
      cl.getCallLogs();});
  }



  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (AppLifecycleState.resumed == state){
      setState(() {
       cl.getCallLogs();
      });
    }
  }

  List<Person> persons = [];
// Save a list of Person objects to local storage
  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> personsJson = persons.map((p) => jsonEncode(p.toJson())).toList();
    List<String>? personsJsonOld = prefs.getStringList('persons');
    List<String>? newpersonJson = personsJson + personsJsonOld!;
    prefs.setStringList('persons', newpersonJson);
  }
  int selectedValue=0;
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
       onRefresh: refresh,
        child: Column(
          children: [
            // the Future Builder
            FutureBuilder(future:  cl.getCallLogs(),
                builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                return Expanded(
                  child: ListView.builder(itemBuilder: (context, index){
                    return GestureDetector( child: Card(
                      margin: EdgeInsets.all(7).copyWith(
                        left: 15,
                        right: 15
                      ),
                      child: ListTile(
                        title:cl.getTitle(snapshot.data!.elementAt(index)),
                        subtitle: Text(cl.formatDate(DateTime.fromMillisecondsSinceEpoch(snapshot.data!
                            .elementAt(index).timestamp as int)) + "\n" + cl
                            .getTime(snapshot.data!.elementAt(index)
                            .duration!)),
                        isThreeLine: true,
                        trailing: ElevatedButton(
                          onLongPress: (){
                               List<PopupMenuEntry<int>> menuItems = [
                               PopupMenuItem(
                               child: Text('5 Minutes'),
                               value: 5,
                               ),
                               PopupMenuItem(
                               child: Text('10 Minutes'),
                               value: 10,
                               ),
                               PopupMenuItem(
                               child: Text('15 Minutes'),
                               value: 15,
                               ),
                                 PopupMenuItem(
                                   child: Text('30 Minutes'),
                                   value: 30,
                                 ),
                                 PopupMenuItem(
                                   child: Text('45 Minutes'),
                                   value: 45,
                                 ),
                                 PopupMenuItem(
                                   child: Text('60 Minutes'),
                                   value: 60,
                                 ),
                               ];
                               showMenu<int>(
                                 context: context,
                                 position: RelativeRect.fromLTRB(100, 300, 100, 0),
                                 items: menuItems,
                                 initialValue: selectedValue,
                               ).then((value) {
                                 if (value != null) {
                                   selectedValue = value;
                                   // do something with the selected value
                                 }
                               });
                          },
                          onPressed: () async{
                          NotificationServices().setNotification(
                              title: 'Call Reminder',
                              body: 'You Have To Call '+snapshot.data!.elementAt(index).name.toString(),
                              scheduleTime:DateTime.now().add(Duration
                                (seconds: selectedValue!)),
                          );
                          persons.add(Person(title: 'Call Reminder',
                            callerName: '${snapshot.data!.elementAt(index).name.toString()}', remTime: '${'$selectedValue minutes'}',));
                          _saveData();
                          Fluttertoast.showToast(
                              msg: "Reminder is Set For After $selectedValue Minutes",
                              toastLength: Toast.LENGTH_SHORT,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.white,
                              textColor: Colors.deepPurpleAccent,
                              fontSize: 16.0
                          );
                        },child:
                        Text("SET $selectedValue Min"),
                        ),
                      ),
                    ), onTap: (){
                     setState(() {
                       showDialog(
                           context: context,
                           builder: (BuildContext context) => AlertDialog(
                             backgroundColor: Colors.white,
                             elevation: 40,
                             title:  Text('Set Call Back Reminder For',
                               style: TextStyle(
                                   fontFamily: 'Rubik',
                                   fontSize: 20,
                                   fontWeight: FontWeight.bold,
                                   color: Colors.black
                               ),),
                             content:  Column(
                                 mainAxisSize: MainAxisSize.min,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: <Widget>[
                                   Container(
                                     height: 300,
                                     width: 345,
                                     decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(12),
                                       color:Colors.white,
                                     ),
                                     child: Center(
                                       child: Column(
                                         children: [
                                           Text(snapshot.data!.elementAt(index).name.toString(),
                                             style: TextStyle(
                                                 fontFamily: 'Rubik',
                                                 fontSize: 20,
                                                 fontWeight: FontWeight.bold,
                                                 color: Colors.black54
                                             ),
                                           ),
                                           SizedBox(height: 5,),
                                           Text(snapshot.data!.elementAt
                                             (index).number.toString(),
                                                 style: TextStyle(
                                                 fontFamily: 'Rubik',
                                                 fontSize: 20,
                                                 fontWeight: FontWeight.bold,
                                                 color: Colors.black54
                                             ),),
                                           Text('After...',
                                             style: TextStyle(
                                                 fontFamily: 'Rubik',
                                                 fontSize: 20,
                                                 fontWeight: FontWeight.bold,
                                                 color: Colors.black,
                                                 height: 1.5
                                             ),),
                                           SizedBox(height: 20,),
                                           Padding(
                                             padding: const EdgeInsets.symmetric
                                               (horizontal: 20),
                                             child: Row(
                                               children: [
                                                 Container(
                                                   child: ElevatedButton(
                                                       onPressed: ()async{
                                                     NotificationServices().setNotification(
                                                         title: 'Call Reminder',
                                                         body: 'You Have To Call '+snapshot.data!.elementAt(index).name.toString(),
                                                         scheduleTime: DateTime.now().add(Duration(seconds: 2)),
                                                     );
                                                     persons.add(Person(title: 'Call Reminder',callerName: '${snapshot.data!.elementAt(index).name.toString()}', remTime: '${'5 minutes'}',));
                                                       _saveData();
                                                     Fluttertoast.showToast(
                                                         msg: "Reminder is Set For After 5-Min",
                                                         toastLength: Toast.LENGTH_SHORT,
                                                         timeInSecForIosWeb: 3,
                                                         backgroundColor: Colors.white,
                                                         textColor: Colors.deepPurpleAccent,
                                                         fontSize: 16.0
                                                     );
                                                     Navigator.pop(context);
                                                      }, child: Text("5 Min..",
                                                     style:TextStyle(
                                                         fontFamily: "Rubik",
                                                         fontSize: 16,
                                                         fontWeight: FontWeight.bold,
                                                         color: Colors.white
                                                     ),
                                                   ),
                                                   ),
                                                 ),
                                                 SizedBox(width: 20,),
                                                 ElevatedButton(onPressed: (){
                                                   NotificationServices().setNotification(
                                                       title: 'Call Reminder',
                                                       body: 'You Have To Call '+snapshot.data!.elementAt(index).name.toString(),
                                                       scheduleTime: DateTime.now().add(Duration(minutes: 10))
                                                   );
                                                   persons.add(Person(title: 'Call Reminder',callerName: '${snapshot.data!.elementAt(index).name.toString()}', remTime: '${'10 minutes'}',));
                                                   _saveData();
                                                   Fluttertoast.showToast(
                                                       msg: "Reminder is Set For After 10-Min",
                                                       toastLength: Toast.LENGTH_SHORT,
                                                       timeInSecForIosWeb: 3,
                                                       backgroundColor: Colors.white,
                                                       textColor: Colors.deepPurpleAccent,
                                                       fontSize: 16.0
                                                   );
                                                   Navigator.pop(context);
                                                 }, child:
                                                 Text("10 Min..",
                                                   style:TextStyle(
                                                       fontFamily: "Rubik",
                                                       fontSize: 16,
                                                       fontWeight: FontWeight.bold,
                                                       color: Colors.white
                                                   ),
                                                 ))
                                               ],
                                             ),
                                           ),
                                           Padding(
                                             padding: const EdgeInsets.symmetric
                                               (horizontal: 20),
                                             child: Row(
                                               children: [
                                                 Container(
                                                   child: ElevatedButton(
                                                       onPressed: (){
                                                         NotificationServices().setNotification(
                                                             title: 'Call Reminder',
                                                             body: 'You Have To Call '+snapshot.data!.elementAt(index).name.toString(),
                                                             scheduleTime:
                                                             DateTime.now().add(Duration(minutes: 30))
                                                         );
                                                         persons.add(Person(title: 'Call Reminder',callerName: '${snapshot.data!.elementAt(index).name.toString()}', remTime: '${'30'' minutes'}',));
                                                         _saveData();
                                                         Fluttertoast.showToast(
                                                             msg: "Reminder is Set For After 30-Min",
                                                             toastLength: Toast.LENGTH_SHORT,
                                                             timeInSecForIosWeb: 3,
                                                             backgroundColor: Colors.white,
                                                             textColor: Colors.deepPurpleAccent,
                                                             fontSize: 16.0
                                                         );
                                                         Navigator.pop(context);
                                                   }, child:
                                                   Text("30 Min..",
                                                     style:TextStyle(
                                                         fontFamily: "Rubik",
                                                         fontSize: 16,
                                                         fontWeight: FontWeight.bold,
                                                         color: Colors.white
                                                     ),
                                                   )),
                                                 ),
                                                 SizedBox(width: 20,),
                                                 ElevatedButton(
                                                     onPressed: (){
                                                       NotificationServices().setNotification(
                                                         title: 'Call Reminder',
                                                         body: 'You Have To Call '+snapshot.data!.elementAt(index).name.toString(),
                                                         scheduleTime: DateTime.now().add(Duration(hours: 1))
                                                       );
                                                       persons.add(Person(title: 'Call Reminder', callerName: '${snapshot.data!.elementAt(index).name.toString()}', remTime: '${'1 Hours'}',));
                                                       _saveData();
                                                       Fluttertoast.showToast(
                                                           msg: "Reminder is Set For After 1-Hr..",
                                                           toastLength: Toast.LENGTH_SHORT,
                                                           timeInSecForIosWeb: 3,
                                                           backgroundColor: Colors.white,
                                                           textColor: Colors.deepPurpleAccent,
                                                           fontSize: 16.0
                                                       );
                                                       Navigator.pop(context);
                                                     }, child: Text("1 Hr....",
                                                       style:TextStyle(
                                                       fontFamily: "Rubik",
                                                       fontSize: 16,
                                                       fontWeight: FontWeight.bold,
                                                       color: Colors.white
                                                   ),
                                                 ))
                                               ],
                                             ),
                                           ),
                                            SizedBox(height: 20,),
                                           InkWell(
                                             onTap: () async{
                                               String mes = "I'II call you back later";
                                               List<String> recipents =
                                               [snapshot.data!.elementAt
                                                 (index).number.toString()];
                                               String _result = await sendSMS(message: mes, recipients: recipents, sendDirect: true)
                                                   .catchError((onError) {
                                                 print(onError);
                                               });
                                               print(_result);
                                               Fluttertoast.showToast(
                                                   msg: "SMS Sent!",
                                                   toastLength: Toast.LENGTH_SHORT,
                                                   timeInSecForIosWeb: 3,
                                                   backgroundColor: Colors.white,
                                                   textColor: Colors.deepPurpleAccent,
                                                   fontSize: 16.0
                                               );
                                             },
                                             child: Container(
                                               height: 30,
                                               decoration: BoxDecoration(
                                                   borderRadius: BorderRadius.all
                                                     (Radius.circular(3)),
                                                   color: Colors.cyan.shade100
                                               ),
                                               child: Center(
                                                 child: Text("I'II call you back later",
                                                   style: TextStyle(
                                                       fontFamily: "Rubik",
                                                       fontSize: 20,
                                                       color: Colors.black,
                                                   ),
                                                 ),
                                               ),
                                             ),
                                           ),
                                           SizedBox(height: 10,),
                                           InkWell(
                                             onTap: () async{
                                               String mes = "Can't talk now,Message me.";
                                               List<String> recipents =
                                               [snapshot.data!.elementAt
                                                 (index).number.toString()];
                                               String _result = await sendSMS(message: mes, recipients: recipents, sendDirect: true)
                                                   .catchError((onError) {
                                                 print(onError);
                                               });
                                               print(_result);
                                               Fluttertoast.showToast(
                                                   msg: "SMS Sent!",
                                                   toastLength: Toast.LENGTH_SHORT,
                                                   timeInSecForIosWeb: 3,
                                                   backgroundColor: Colors.white,
                                                   textColor: Colors.deepPurpleAccent,
                                                   fontSize: 16.0
                                               );
                                             },
                                             child: Container(
                                               height: 30,
                                               decoration: BoxDecoration(
                                                   borderRadius: BorderRadius.all
                                                     (Radius.circular(3)),
                                                   color: Colors.cyan.shade100
                                               ),
                                               child: Center(
                                                 child: Text("Can't talk now,"
                                                     "Message me.",
                                                   style: TextStyle(
                                                     fontFamily: "Rubik",
                                                     fontSize: 20,
                                                     color: Colors.black,
                                                   ),
                                                 ),
                                               ),
                                             ),
                                           ),
                                           SizedBox(height: 5,),
                                         ],
                                       ),
                                     ),
                                   )
                                 ]
                             ),
                           ));
                     }
                     );
                    },
                    );
                  }, itemCount: snapshot.data.toString().length,
                  ),
                );
              }else{
                bool _ppp=true;
                bool text=false;
                if(snapshot.connectionState==ConnectionState.done){
                  _ppp=false;
                  text=true;
                }
                return Column(
                  children: [
                    Center(child: Visibility(
                      visible: _ppp,
                      child: CircularProgressIndicator(),
                    )),
                    Center(
                      child: Visibility(
                        visible: text,
                        child: Text("No Phone Call-Logs"),
                      ),
                    )
                  ],
                );
              }
            })
          ],
        ),
      ),
    );
  }
}