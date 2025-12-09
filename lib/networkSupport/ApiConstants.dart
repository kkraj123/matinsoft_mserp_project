
class ApiConstants {
  static const bool isProductionMode = true;
  static String baseUrl = "https://app.sajiloscale.com/";
  // static String baseUrl = "https://mserp.matinsoftech.com/";

  //authentication
  static String authUrl = "api/login";
  static String checkInCheckOutEndPoint = "api/company/check-in-out";
  static String attendanceEndPoint = "api/company/attendance/logs";
  static String logoutEndPoint = "api/logout";


  //leave request api
  static String leaveTypeEndPoint = "api/company/leave-types";
  static String leaveRequestEndPoint = "api/company/leaves-requests";
  //time leave request
  static String timeLeaveRequestEndPoint = "api/company/time-leaves";

  //home page api
 static String categoryItemsEndPoint = "api/company/sidebar-modules";

 //survey api
  static String surveyListEndPoint = "api/company/surveys";
  static String responseApiEndPoint = "api/company/survey-responses";
  static String updateSurveyResponse = "api/company/survey-responses";
  static String getResponseService = "api/company/survey-responses";

  //profile
  static String profileEndPoint = "api/company/profile";


  //family dashboard
  static String familyDashboardEndPoint = "api/company/family/user-dashboard";

}

