import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../notification_manager.dart';
import '../phonelog.dart';



class sms extends StatefulWidget {
  const sms({Key? key}) : super(key: key);

  @override
  State<sms> createState() => _smsState();
}

class _smsState extends State<sms> {
  List<String> _myList = [];
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];
  final scrollDirection = Axis.vertical;
  AutoScrollController controller = AutoScrollController();

  @override
  void initState() {
    super.initState();
    loadSms();
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
  }

  void loadSms() async{
    var permission = await Permission.sms.status;
    if (permission.isGranted) {
      final messages = await _query.querySms(
        kinds: [SmsQueryKind.inbox, SmsQueryKind.draft,SmsQueryKind.sent,],
      );
      // Look up the contact associated with the sender's phone number
      debugPrint('sms inbox messages: ${messages.length}');
      setState(() => _messages = messages);
    } else {
      await Permission.sms.request();
    }
  }
// This method saves the list to SharedPreferences
  _saveList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      String myListString = jsonEncode(_myList);
    prefs.setString('myList', myListString);
  }

  Future refresh() async{
    setState(() {
      loadSms();
    });
  }

  TextEditingController smsContain=TextEditingController();

  List<Person> persons = [];
// Save a list of Person objects to local storage
  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> personsJson = persons.map((p) => jsonEncode(p.toJson())).toList();
    List<String>? personsJsonOld = prefs.getStringList('persons');
    List<String>? newpersonJson = personsJson + personsJsonOld!;
    prefs.setStringList('persons', newpersonJson);
  }
  String? selectedValue='SMS Message';

  void smsBomber(){


    for (int i = 0; i < 5; i++) {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
          onRefresh: refresh,
          child: ListView.builder(
            scrollDirection: scrollDirection,
            controller: controller,
            itemCount: _messages.length,
            itemBuilder: (BuildContext context,index) {
              var message = _messages[index];
              return InkWell(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.grey.shade200
                  ),
                  child: ListTile(
                    title: Text('${message.sender} [${message.date}]'),
                    subtitle: Text('${message.body}'),
                  ),
                ),
                onTap:(){
                  setState(() {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          backgroundColor: Colors.white,
                          elevation: 40,
                          title:  Text("To: ${message.sender.toString()}",
                            style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                            ),textAlign: TextAlign.center,),
                          content:  Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  // height: 300,
                                   width: 355,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color:Colors.white,
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        // Row(
                                        //   children: [
                                        //     Text('Select a message',
                                        //       style: TextStyle(
                                        //         fontWeight: FontWeight.bold,
                                        //         fontSize: 12,
                                        //         color: Colors.black26
                                        //       ),
                                        //     )
                                        //   ],
                                        // ),
                                        // Container(
                                        //   height:36,
                                        //   width: 236,
                                        //   decoration: BoxDecoration(
                                        //     border:Border.all(),
                                        //     borderRadius: BorderRadius.circular(2),
                                        //
                                        //   ),
                                        // ),
                                        Row(
                                          children: [
                                            Text("Select a message"),
                                          ],
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius: BorderRadius
                                                .circular(5.0),
                                            color: Colors.grey.shade200
                                          ),
                                          child: DropdownButtonFormField(
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                              ),
                                              icon:Icon(Icons
                                                  .keyboard_arrow_down_outlined, color:Colors.grey,),

                                              value: selectedValue,

                                              onChanged: (String? newValue) {
                                                setState(() async {
                                                  selectedValue = newValue!;
                                                  refresh();
                                                  String mes = newValue;
                                                  List<String> recipents =
                                                  [message.sender.toString()];
                                                  String _result = await sendSMS(message: mes, recipients: recipents, sendDirect: true)
                                                      .catchError((onError) {
                                                    print(onError);
                                                    Fluttertoast.showToast(
                                                        msg: "SMS Sent!",
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        timeInSecForIosWeb: 3,
                                                        backgroundColor: Colors.white,
                                                        textColor: Colors.deepPurpleAccent,
                                                        fontSize: 16.0
                                                    );

                                                  });
                                                });
                                              },
                                            items: <String>[
                                              'SMS Message',
                                              'Email',
                                              'Phone Call',
                                            ].map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value,
                                                style: TextStyle(
                                                  color: Colors.grey
                                                ),),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text("0r",style: TextStyle
                                            (color:Colors.grey,fontSize: 15),),
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              height: 45,
                                              width: 160,
                                              decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(4.0),
                                                border: Border.all()
                                              ),
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "Send a custom message"
                                                ),
                                                controller: smsContain,

                                              ),
                                            ),
                                            SizedBox(width: 2,),
                                            SizedBox(
                                              height: 43,
                                              width: 70,
                                              child: ElevatedButton(
                                                onPressed: () async{
                                                  String mes = smsContain.text;
                                                  List<String> recipents =
                                                  [message.sender.toString()];
                                                  String _result = await sendSMS(message: mes, recipients: recipents, sendDirect: true)
                                                      .catchError((onError) {
                                                    print(onError);
                                                  });
                                                  print(_result);

                                                  // for (int i = 0; i <= 10; i++) {
                                                  //   String mes = smsContain.text;
                                                  //   List<String> recipents =
                                                  //   [message.sender.toString()];
                                                  //   String _result = await sendSMS(message: mes, recipients: recipents, sendDirect: true)
                                                  //       .catchError((onError) {
                                                  //     print(onError);
                                                  //   });
                                                  // }
                                                  Fluttertoast.showToast(
                                                      msg: "SMS Sent!",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      timeInSecForIosWeb: 3,
                                                      backgroundColor: Colors.white,
                                                      textColor: Colors.deepPurpleAccent,
                                                      fontSize: 16.0
                                                  );
                                                }, child:
                                              Text('Send',style: TextStyle
                                                (fontSize: 15),),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors
                                                    .greenAccent[700]
                                              ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                          children: [
                                            Text("Set Reminder for SMS *",
                                              style: TextStyle(
                                                fontSize: 15
                                              ),)
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Padding(
                                          padding: const EdgeInsets.symmetric
                                            (horizontal: 10),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                height:50,
                                                width: 100,
                                                child: ElevatedButton(
                                                  onPressed: (){
                                                    NotificationServices().setNotification(
                                                      title: 'SMS Reminder',
                                                      body: 'You Have To SMS '+message.sender.toString(),
                                                      scheduleTime:
                                                      DateTime.now().add
                                                        (Duration(minutes: 5)),
                                                    );
                                                    persons.add(Person(title:
                                                    'SMS Reminder',callerName:
                                                    '${message.sender.toString()}', remTime: '${'5 minutes'}',));
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
                                              SizedBox(width: 10,),
                                              SizedBox(
                                                height:50,
                                                width: 100,
                                                child: ElevatedButton(onPressed: (){
                                                  NotificationServices().setNotification(
                                                      title: 'SMS Reminder',
                                                      body: 'You Have To SMS '+message.sender.toString(),
                                                      scheduleTime: DateTime.now().add(Duration(minutes: 10))
                                                  );
                                                  persons.add(Person(title:
                                                  'SMS Reminder',callerName:
                                                  '${message.sender.toString()
                                                  }', remTime: '${'10 minutes'}',));
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
                                                )),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        Padding(
                                          padding: const EdgeInsets.symmetric
                                            (horizontal: 10),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                height:50,
                                                width: 100,
                                                child: ElevatedButton(
                                                    onPressed: (){
                                                      NotificationServices()
                                                          .setNotification(
                                                          title: 'SMS Reminder',
                                                          body: 'You Have To SMS '+message.sender.toString(),
                                                          scheduleTime:
                                                          DateTime.now().add(Duration(minutes: 30))
                                                      );
                                                      persons.add(Person(title:
                                                      'SMS Reminder',callerName:
                                                      '${message.sender
                                                          .toString()}',
                                                        remTime: '${'30 minutes'}',));
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
                                              SizedBox(width: 10,),
                                              SizedBox(
                                                height:50,
                                                width: 100,
                                                child: ElevatedButton(
                                                    onPressed: (){
                                                      NotificationServices().setNotification(
                                                          title: 'SMS Reminder',
                                                          body: 'You Have To SMS '+message.sender.toString(),
                                                          scheduleTime: DateTime.now().add(Duration(hours: 1))
                                                      );
                                                      persons.add(Person(title: 'SMS Reminder',callerName: '${message.sender.toString()}', remTime: '${'1 ''Hours'}',));
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
                                                    }, child:
                                                Text("1 Hr....",
                                                  style:TextStyle(
                                                      fontFamily: "Rubik",
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white
                                                  ),
                                                )),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 50,
                                          width: 180,
                                          decoration: BoxDecoration(
                                          ),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'Or set custom timer',
                                                hintStyle: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold
                                                )
                                            ),
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold
                                            ),

                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ]
                          ),
                        )
                    );
                  });
                },
              );
            },
          ),
        ),
      );
  }
}