import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ringmeup/main_screens/sms.dart';
import '../phonelog.dart';
import 'package:google_fonts/google_fonts.dart';

import 'local_history.dart';
class reminders extends StatefulWidget {
  const reminders({Key? key}) : super(key: key);

  @override
  State<reminders> createState() => _remindersState();
}
class _remindersState extends State<reminders> with TickerProviderStateMixin{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length:2, vsync: this);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white24,
        elevation: 0,
        toolbarHeight: 140,
        flexibleSpace: Center(
          child: Column(
            children: [
              SizedBox(height: 35,),
              Row(
                children: [
                  SizedBox(width: 90,),
                  Text("RingMeUp",
                    style: GoogleFonts.getFont(
                         'Caveat Brush',
                        fontSize: 40,
                         fontWeight: FontWeight.normal,
                        color: Colors.black,
                        height: 0.10
                    ),),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10,
                        horizontal: 5),
                    child: SizedBox(
                      height: 50,
                      width: 54,
                      child: Image.asset('assets/bell.png',
                        height: 65,
                        width: 62,
                      ),
                    ),
                  ),

                  // SizedBox(width: 80,),
                  //   PopupMenuButton(
                  //     // add icon, by default "3 dot" icon
                  //      icon: Icon(Icons.menu),
                  //       itemBuilder: (context){
                  //         return [
                  //           PopupMenuItem<int>(
                  //             value: 0,
                  //             child: Text("Call-Logs",
                  //               style: TextStyle(
                  //                 fontFamily: 'Rubik',
                  //                 fontSize: 20,
                  //                 fontWeight: FontWeight.bold
                  //               ),
                  //             ),
                  //           ),
                  //
                  //           PopupMenuItem<int>(
                  //             value: 1,
                  //             child: Text("Emails",
                  //               style: TextStyle(
                  //                   fontFamily: 'Rubik',
                  //                   fontSize: 20,
                  //                   fontWeight: FontWeight.bold
                  //               ),),
                  //           ),
                  //
                  //           PopupMenuItem<int>(
                  //             value: 2,
                  //             child: Text("SMS",
                  //               style: TextStyle(
                  //                   fontFamily: 'Rubik',
                  //                   fontSize: 20,
                  //                   fontWeight: FontWeight.bold
                  //               ),),
                  //           ),
                  //           PopupMenuItem<int>(
                  //             value: 3,
                  //             child: Text("WhatsApp-Chat",
                  //               style: TextStyle(
                  //                   fontFamily: 'Rubik',
                  //                   fontSize: 20,
                  //                   fontWeight: FontWeight.bold
                  //               ),),
                  //           ),
                  //         ];
                  //       },
                  //       onSelected:(value){
                  //         if(value == 0){
                  //           Navigator.push(
                  //             context,
                  //             MaterialPageRoute(builder: (context) => PhonelogsScreen()),
                  //           );
                  //         }else if(value == 1){
                  //           Navigator.push(
                  //             context,
                  //             MaterialPageRoute(builder: (context) => email()),
                  //           );
                  //         }else if(value == 2){
                  //           Navigator.push(
                  //             context,
                  //             MaterialPageRoute(builder: (context) => sms()),
                  //           );
                  //         }
                  //         else if(value == 3){
                  //           Navigator.push(
                  //             context,
                  //             MaterialPageRoute(builder: (context) => chat()),
                  //           );
                  //         }
                  //       }
                  //   ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 40,
                  width: 300,
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: const Color.fromRGBO(228, 231, 255, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    controller: tabController,
                    isScrollable: true,
                    unselectedLabelColor:const Color.fromRGBO(227, 227, 227, 1),
                    labelColor:  const Color.fromRGBO(36, 43, 105, 1),
                    tabs: [
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 90),
                      //   child: Tab(
                      //     child: Text(
                      //       'History',
                      //       textAlign: TextAlign.center,
                      //       style: TextStyle(
                      //         fontFamily: 'Maven Pro',
                      //         fontSize: 20,
                      //         fontWeight: FontWeight.bold,
                      //         height: 1.3,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Tab(child: Text(
                          'Call-Logs',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                          fontFamily:'Maven Pro',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: Tab(
                          child: Text(
                              'SMS',
                              textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Maven Pro',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 1,
                width: 330,
                decoration: BoxDecoration(
                    color: Colors.black
                ),
              )
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        dragStartBehavior: DragStartBehavior.start,
        children:  [

          //local_history(),
          phonelog(),
          sms()
        ],
      ),
     );

  }
}
