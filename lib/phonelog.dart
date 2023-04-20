import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:ringmeup/notification_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './calllog.dart';
import 'package:flutter_sms/flutter_sms.dart';
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
    // TODO: implement initState
    super.initState();
    notification.initNotification();
    //WidgetsBinding.instance.addObserver(this);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
       onRefresh: refresh,
        child: Column(
          children: [
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
                          onPressed: () {
                           /*
                           if(title=call || title=sms)
                           1 title: call / sms
                           2 name
                           3 reminder time
                           4 created time
                           */
                          NotificationServices().setNotification(
                              title: 'Call Reminder',
                              body: 'You Have To Call '+snapshot.data!.elementAt(index).name.toString(),
                              scheduleTime:DateTime.now().add(Duration
                                (minutes: 30)),
                          );
                          Fluttertoast.showToast(
                              msg: "Reminder is Set For After 30-Min",
                              toastLength: Toast.LENGTH_SHORT,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.white,
                              textColor: Colors.deepPurpleAccent,
                              fontSize: 16.0
                          );
                        },child:
                        Text("SET 30 Min"),
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
                                                       onPressed: (){
                                                     NotificationServices().setNotification(
                                                         title: 'Call Reminder',
                                                         body: 'You Have To ''Call '+snapshot.data!.elementAt(index).name.toString(),
                                                         scheduleTime: DateTime.now().add(Duration(seconds: 2)),
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
                                                       title: 'Call Reminder',
                                                       body: 'You Have To Call '+snapshot.data!.elementAt(index).name.toString(),
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
                                                             title: 'Call Reminder',
                                                             body: 'You Have To Call '+snapshot.data!.elementAt(index).name.toString(),
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
                                                         title: 'Call Reminder',
                                                         body: 'You Have To Call '+snapshot.data!.elementAt(index).name.toString(),
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