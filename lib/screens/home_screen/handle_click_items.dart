
import 'package:flutter/material.dart';
import 'package:mserp/constant.dart';
import 'package:mserp/screens/home_screen/model/CategoryItemsResponse.dart';
import 'package:mserp/screens/leave_request_screen/MyLeaveStatusScreen.dart';
import 'package:mserp/screens/survey_screens/survey_screen.dart';
import 'package:mserp/screens/time_leave_request/time_leave_scree.dart';
import 'package:mserp/widget/default_screen.dart';

void clickParentItem(ModulesList parentItem, BuildContext context){
   switch(parentItem.name){
     case Constant.surveys :
       Navigator.push(context, MaterialPageRoute(builder: (context) =>const SurveyScreen()));
       break;
     default :
       Navigator.push(context, MaterialPageRoute(builder: (context) =>const DefaultScreen()));
   }
}

void handleChildrenClickItems(Children child, BuildContext context) {
  switch(child.name){
    case Constant.leaveTime :
      print("click leave time");
      break;
    case Constant.leaveRequest :
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  const MyLeaveStatusScreen()),
      );
      break;
    case Constant.timeLeaves :
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TimeLeaveScree()),
      );
      break;
    default :
      Navigator.push(context, MaterialPageRoute(builder: (context) =>const DefaultScreen()));
  }
}
