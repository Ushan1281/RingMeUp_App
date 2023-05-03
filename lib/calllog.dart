import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CallLogs{
  // Call Logs with the outgoing and incoming time...........................
  Future<Iterable<CallLogEntry>> getCallLogs(){

    return CallLog.get();
  }
  String formatDate(DateTime dt){

    return DateFormat('d-MMM-y H:m:s').format(dt);
  }

  getTitle(CallLogEntry entry){
    if(entry.name == null)
      return Text(entry.number.toString());
    if(entry.name.toString().isEmpty)
      return Text(entry.number.toString());
    else
      return Text(entry.name.toString());
  }

  String getTime(int duration){

    Duration d1 = Duration(seconds: duration);
    String formatedDuration = "";
    if(d1.inHours > 0){
      formatedDuration += d1.inHours.toString() + "h";
    }
    if(d1.inMinutes > 0){
      formatedDuration += d1.inMinutes.toString() + "m";
    }
    if(d1.inSeconds > 0){
      formatedDuration += d1.inSeconds.toString() + "s";
    }
    if(formatedDuration.isEmpty)
      return "0s";
    return formatedDuration;
  }
}