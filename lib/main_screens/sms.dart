import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../notification_manager.dart';



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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   leading:  BackButton(
        //     color: Colors.black,
        //     onPressed: (){
        //       Navigator.pop(context);
        //     }
        //   ),
        //   backgroundColor: Colors.white,
        //   title: Text("SMS",
        //     style: TextStyle(
        //         fontFamily: 'Rubik',
        //         fontSize: 25,
        //         fontWeight: FontWeight.bold,
        //         color: Colors.black
        //     ),),
        // ),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: ListView.builder(
            // shrinkWrap: true,
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
                          title:  Text('  Set SMS Reminder For',
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
                                        Text(message.sender.toString(),
                                          style: TextStyle(
                                              fontFamily: 'Rubik',
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54
                                          ),
                                        ),
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
                                                  onPressed: (){

                                                    NotificationServices().setNotification(
                                                      title: 'SMS Reminder',
                                                      body: 'You Have To SMS '+message.sender.toString(),
                                                      scheduleTime:
                                                      DateTime.now().add
                                                        (Duration(minutes: 5)),
                                                    );
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
                                                    title: 'SMS Reminder',
                                                    body: 'You Have To SMS '+message.sender.toString(),
                                                    scheduleTime: DateTime.now().add(Duration(minutes: 10))
                                                );
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
                                                          title: 'SMS Reminder',
                                                          body: 'You Have To SMS '+message.sender.toString(),
                                                          scheduleTime:
                                                          DateTime.now().add(Duration(minutes: 30))
                                                      );
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
                                                        title: 'SMS Reminder',
                                                        body: 'You Have To SMS '+message.sender.toString(),
                                                        scheduleTime: DateTime.now().add(Duration(hours: 1))
                                                    );
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
                                              ))
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        InkWell(
                                          onTap: () async{
                                            String mes = "Can't talk nowMessage me.";
                                            List<String> recipents =
                                            [message.sender.toString()];
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
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 230,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all
                                                (Radius.circular(3)),

                                            ),
                                            child: Text("Can't talk now "
                                                "Message me.",
                                              style: TextStyle(
                                                  fontFamily: "Rubik",
                                                  fontSize: 20,
                                                  color: Colors.black
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                       InkWell(
                                         child: Container(
                                           width: 200,
                                           decoration: BoxDecoration(
                                             borderRadius: BorderRadius.all(Radius.circular(8),),
                                             color: Colors.cyan.shade100
                                         ),
                                           child: TextField(
                                             controller: smsContain,
                                             textInputAction: TextInputAction.go,
                                             onSubmitted: (value) async{
                                               String mes = smsContain.text;
                                               List<String> recipents =
                                               [message.sender.toString()];
                                               String _result = await sendSMS(message: mes, recipients: recipents, sendDirect: true)
                                                   .catchError((onError) {
                                                 print(onError);
                                               });
                                               print(smsContain.text);
                                               print(_result);
                                               Fluttertoast.showToast(
                                                   msg: "SMS Sent!",
                                                   toastLength: Toast.LENGTH_SHORT,
                                                   timeInSecForIosWeb: 3,
                                                   backgroundColor: Colors.white,
                                                   textColor: Colors.deepPurpleAccent,
                                                   fontSize: 16.0
                                               );
                                               Navigator.pop(context);
                                             },
                                             textAlign: TextAlign.center,
                                             decoration: InputDecoration(
                                               border: InputBorder.none,
                                               hintText: "Enter a Custom Message",
                                             ),
                                           ),
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