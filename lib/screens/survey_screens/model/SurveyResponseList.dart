
import 'dart:convert';

SurveyResponseList surveyResponseListFromJson(String str) =>
    SurveyResponseList.fromJson(json.decode(str));

String surveyResponseListToJson(SurveyResponseList data) =>
    json.encode(data.toJson());

class SurveyResponseList {
  final String? status;
  final String? message;
  final SurveyResponseData? data;

  SurveyResponseList({
    this.status,
    this.message,
    this.data,
  });

  factory SurveyResponseList.fromJson(Map<String, dynamic> json) =>
      SurveyResponseList(
        status: json["status"],
        message: json["message"],
        data: json["data"] != null
            ? SurveyResponseData.fromJson(json["data"])
            : null,
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class SurveyResponseData {
  final int? currentPage;
  final List<SurveyResponseItem>? data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<PageLink>? links;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final String? prevPageUrl;
  final int? to;
  final int? total;

  SurveyResponseData({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory SurveyResponseData.fromJson(Map<String, dynamic> json) =>
      SurveyResponseData(
        currentPage: json["current_page"],
        data: (json["data"] as List<dynamic>?)
            ?.map((x) => SurveyResponseItem.fromJson(x))
            .toList(),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: (json["links"] as List<dynamic>?)
            ?.map((x) => PageLink.fromJson(x))
            .toList(),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": data?.map((x) => x.toJson()).toList(),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": links?.map((x) => x.toJson()).toList(),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class SurveyResponseItem {
  final int? id;
  final int? companyId;
  final int? surveyId;
  final int? userId;
  final String? ipAddress;
  final dynamic answers;
  final String? submittedAt;
  final String? createdAt;
  final String? updatedAt;
  final AnswerSurvey? survey;
  final User? user;

  SurveyResponseItem({
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

  factory SurveyResponseItem.fromJson(Map<String, dynamic> json) =>
      SurveyResponseItem(
        id: json["id"],
        companyId: json["company_id"],
        surveyId: json["survey_id"],
        userId: json["user_id"],
        ipAddress: json["ip_address"],
        answers: json["answers"],
        submittedAt: json["submitted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        survey: json["survey"] != null ? AnswerSurvey.fromJson(json["survey"]) : null,
        user: json["user"] != null ? User.fromJson(json["user"]) : null,
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company_id": companyId,
    "survey_id": surveyId,
    "user_id": userId,
    "ip_address": ipAddress,
    "answers": answers,
    "submitted_at": submittedAt,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "survey": survey?.toJson(),
    "user": user?.toJson(),
  };
}

class AnswerSurvey {
  final int? id;
  final int? companyId;
  final String? title;
  final String? description;
  final String? slug;
  final String? startDate;
  final String? endDate;
  final SurveySettings? settingsJson;
  final String? status;
  final bool? isPrivate;
  final String? privateToken;
  final bool? restrictByIp;
  final int? privateField;
  final int? ipRestriction;
  final bool? singleSubmission;
  final bool? isTemplate;
  final int? createdBy;
  final String? createdAt;
  final String? updatedAt;

  AnswerSurvey({
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
    this.privateField,
    this.ipRestriction,
    this.singleSubmission,
    this.isTemplate,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory AnswerSurvey.fromJson(Map<String, dynamic> json) => AnswerSurvey(
    id: json["id"],
    companyId: json["company_id"],
    title: json["title"],
    description: json["description"],
    slug: json["slug"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    settingsJson: json["settings_json"] != null
        ? SurveySettings.fromJson(json["settings_json"])
        : null,
    status: json["status"],
    isPrivate: json["is_private"],
    privateToken: json["private_token"],
    restrictByIp: json["restrict_by_ip"],
    privateField: json["private"],
    ipRestriction: json["ip_restriction"],
    singleSubmission: json["single_submission"],
    isTemplate: json["is_template"],
    createdBy: json["created_by"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company_id": companyId,
    "title": title,
    "description": description,
    "slug": slug,
    "start_date": startDate,
    "end_date": endDate,
    "settings_json": settingsJson?.toJson(),
    "status": status,
    "is_private": isPrivate,
    "private_token": privateToken,
    "restrict_by_ip": restrictByIp,
    "private": privateField,
    "ip_restriction": ipRestriction,
    "single_submission": singleSubmission,
    "is_template": isTemplate,
    "created_by": createdBy,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class SurveySettings {
  final bool? anonymous;
  final bool? notifyAdmin;

  SurveySettings({
    this.anonymous,
    this.notifyAdmin,
  });

  factory SurveySettings.fromJson(Map<String, dynamic> json) => SurveySettings(
    anonymous: json["anonymous"],
    notifyAdmin: json["notify_admin"],
  );

  Map<String, dynamic> toJson() => {
    "anonymous": anonymous,
    "notify_admin": notifyAdmin,
  };
}

class User {
  final int? id;
  final int? companyId;
  final int? officeTimeId;
  final int? departmentId;
  final int? userGroupId;
  final int? designationId;
  final String? name;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? email;
  final bool? emailOptOut;
  final String? emailUnsubscribeToken;
  final String? emailUnsubscribeTokenExpiresAt;
  final String? gender;
  final String? phone;
  final String? userType;
  final String? emailVerifiedAt;
  final String? pic;
  final int? isEnableLogin;
  final bool? isActive;
  final bool? loginDisabled;
  final String? balance;
  final String? createdAt;
  final String? updatedAt;

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
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
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
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class PageLink {
  final String? url;
  final String? label;
  final int? page;
  final bool? active;

  PageLink({
    this.url,
    this.label,
    this.page,
    this.active,
  });

  factory PageLink.fromJson(Map<String, dynamic> json) => PageLink(
    url: json["url"],
    label: json["label"],
    page: json["page"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "page": page,
    "active": active,
  };
}
