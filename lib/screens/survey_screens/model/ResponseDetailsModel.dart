import 'dart:convert';

ResponseDetailsModel responseDetailsModelFromJson(String str) =>
    ResponseDetailsModel.fromJson(json.decode(str));

String responseDetailsModelToJson(ResponseDetailsModel data) =>
    json.encode(data.toJson());

class ResponseDetailsModel {
  String? status;
  String? message;
  ResponseData? data;

  ResponseDetailsModel({
    this.status,
    this.message,
    this.data,
  });

  factory ResponseDetailsModel.fromJson(Map<String, dynamic> json) =>
      ResponseDetailsModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : ResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class ResponseData {
  int? id;
  int? companyId;
  int? surveyId;
  int? userId;
  String? ipAddress;
  List<Answer>? answers;
  DateTime? submittedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  SurveyDeail? survey;
  User? user;

  ResponseData({
    this.id,
    this.companyId,
    this.surveyId,
    this.userId,
    this.ipAddress,
    this.answers,
    this.submittedAt,
    this.createdAt,
    this.updatedAt,
    this.survey,
    this.user,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    id: json["id"],
    companyId: json["company_id"],
    surveyId: json["survey_id"],
    userId: json["user_id"],
    ipAddress: json["ip_address"],
    answers: json["answers"] == null
        ? null
        : List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
    submittedAt: json["submitted_at"] == null
        ? null
        : DateTime.parse(json["submitted_at"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    survey: json["survey"] == null ? null : SurveyDeail.fromJson(json["survey"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company_id": companyId,
    "survey_id": surveyId,
    "user_id": userId,
    "ip_address": ipAddress,
    "answers": answers == null
        ? null
        : List<dynamic>.from(answers!.map((x) => x.toJson())),
    "submitted_at": submittedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "survey": survey?.toJson(),
    "user": user?.toJson(),
  };
}

class Answer {
  int? id;
  int? responseId;
  int? questionId;
  String? answerText;
  dynamic answerJson;
  String? filePath;
  String? fileName;
  String? fileUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? fileUrlGenerated;
  DetailsQuestion? question;

  Answer({
    this.id,
    this.responseId,
    this.questionId,
    this.answerText,
    this.answerJson,
    this.filePath,
    this.fileName,
    this.fileUrl,
    this.createdAt,
    this.updatedAt,
    this.fileUrlGenerated,
    this.question,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
    id: json["id"],
    responseId: json["response_id"],
    questionId: json["question_id"],
    answerText: json["answer_text"],
    answerJson: json["answer_json"],
    filePath: json["file_path"],
    fileName: json["file_name"],
    fileUrl: json["file_url"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    fileUrlGenerated: json["file_url_generated"],
    question:
    json["question"] == null ? null : DetailsQuestion.fromJson(json["question"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "response_id": responseId,
    "question_id": questionId,
    "answer_text": answerText,
    "answer_json": answerJson,
    "file_path": filePath,
    "file_name": fileName,
    "file_url": fileUrl,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "file_url_generated": fileUrlGenerated,
    "question": question?.toJson(),
  };
}

class DetailsQuestion {
  int? id;
  int? surveyId;
  String? type;
  String? label;
  List<dynamic>? optionsJson;
  bool? required;
  int? orderNo;
  dynamic logicJson;
  DateTime? createdAt;
  DateTime? updatedAt;

  DetailsQuestion({
    this.id,
    this.surveyId,
    this.type,
    this.label,
    this.optionsJson,
    this.required,
    this.orderNo,
    this.logicJson,
    this.createdAt,
    this.updatedAt,
  });

  factory DetailsQuestion.fromJson(Map<String, dynamic> json) => DetailsQuestion(
    id: json["id"],
    surveyId: json["survey_id"],
    type: json["type"],
    label: json["label"],
    optionsJson: json["options_json"] == null
        ? null
        : List<dynamic>.from(json["options_json"]),
    required: json["required"],
    orderNo: json["order_no"],
    logicJson: json["logic_json"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "survey_id": surveyId,
    "type": type,
    "label": label,
    "options_json":
    optionsJson == null ? null : List<dynamic>.from(optionsJson!),
    "required": required,
    "order_no": orderNo,
    "logic_json": logicJson,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class SurveyDeail {
  int? id;
  int? companyId;
  String? title;
  String? description;
  String? slug;
  DateTime? startDate;
  DateTime? endDate;
  dynamic settingsJson;
  String? status;
  bool? isPrivate;
  String? privateToken;
  bool? restrictByIp;
  int? privateValue;        // "private": 0
  int? ipRestriction;       // "ip_restriction": 0
  bool? singleSubmission;
  bool? isTemplate;
  int? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  SurveyDeail({
    this.id,
    this.companyId,
    this.title,
    this.description,
    this.slug,
    this.startDate,
    this.endDate,
    this.settingsJson,
    this.status,
    this.isPrivate,
    this.privateToken,
    this.restrictByIp,
    this.privateValue,
    this.ipRestriction,
    this.singleSubmission,
    this.isTemplate,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory SurveyDeail.fromJson(Map<String, dynamic> json) => SurveyDeail(
    id: json["id"],
    companyId: json["company_id"],
    title: json["title"],
    description: json["description"],
    slug: json["slug"],
    startDate:
    json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
    endDate:
    json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
    settingsJson: json["settings_json"],
    status: json["status"],
    isPrivate: json["is_private"],
    privateToken: json["private_token"],
    restrictByIp: json["restrict_by_ip"],
    privateValue: json["private"],
    ipRestriction: json["ip_restriction"],
    singleSubmission: json["single_submission"],
    isTemplate: json["is_template"],
    createdBy: json["created_by"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company_id": companyId,
    "title": title,
    "description": description,
    "slug": slug,
    "start_date": startDate?.toIso8601String(),
    "end_date": endDate?.toIso8601String(),
    "settings_json": settingsJson,
    "status": status,
    "is_private": isPrivate,
    "private_token": privateToken,
    "restrict_by_ip": restrictByIp,
    "private": privateValue,
    "ip_restriction": ipRestriction,
    "single_submission": singleSubmission,
    "is_template": isTemplate,
    "created_by": createdBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class User {
  int? id;
  int? companyId;
  int? officeTimeId;
  int? departmentId;
  int? userGroupId;
  int? designationId;
  String? name;
  String? firstName;
  String? middleName;
  String? lastName;
  String? email;
  bool? emailOptOut;
  String? emailUnsubscribeToken;
  String? emailUnsubscribeTokenExpiresAt;
  String? gender;
  String? phone;
  String? userType;
  String? emailVerifiedAt;
  String? pic;
  int? isEnableLogin;
  bool? isActive;
  bool? loginDisabled;
  String? balance;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    this.id,
    this.companyId,
    this.officeTimeId,
    this.departmentId,
    this.userGroupId,
    this.designationId,
    this.name,
    this.firstName,
    this.middleName,
    this.lastName,
    this.email,
    this.emailOptOut,
    this.emailUnsubscribeToken,
    this.emailUnsubscribeTokenExpiresAt,
    this.gender,
    this.phone,
    this.userType,
    this.emailVerifiedAt,
    this.pic,
    this.isEnableLogin,
    this.isActive,
    this.loginDisabled,
    this.balance,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    companyId: json["company_id"],
    officeTimeId: json["office_time_id"],
    departmentId: json["department_id"],
    userGroupId: json["user_group_id"],
    designationId: json["designation_id"],
    name: json["name"],
    firstName: json["first_name"],
    middleName: json["middle_name"],
    lastName: json["last_name"],
    email: json["email"],
    emailOptOut: json["email_opt_out"],
    emailUnsubscribeToken: json["email_unsubscribe_token"],
    emailUnsubscribeTokenExpiresAt:
    json["email_unsubscribe_token_expires_at"],
    gender: json["gender"],
    phone: json["phone"],
    userType: json["user_type"],
    emailVerifiedAt: json["email_verified_at"],
    pic: json["pic"],
    isEnableLogin: json["is_enable_login"],
    isActive: json["is_active"],
    loginDisabled: json["login_disabled"],
    balance: json["balance"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company_id": companyId,
    "office_time_id": officeTimeId,
    "department_id": departmentId,
    "user_group_id": userGroupId,
    "designation_id": designationId,
    "name": name,
    "first_name": firstName,
    "middle_name": middleName,
    "last_name": lastName,
    "email": email,
    "email_opt_out": emailOptOut,
    "email_unsubscribe_token": emailUnsubscribeToken,
    "email_unsubscribe_token_expires_at":
    emailUnsubscribeTokenExpiresAt,
    "gender": gender,
    "phone": phone,
    "user_type": userType,
    "email_verified_at": emailVerifiedAt,
    "pic": pic,
    "is_enable_login": isEnableLogin,
    "is_active": isActive,
    "login_disabled": loginDisabled,
    "balance": balance,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
