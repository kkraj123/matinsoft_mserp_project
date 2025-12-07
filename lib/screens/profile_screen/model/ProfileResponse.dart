/// success : true
/// message : "Profile fetched successfully."
/// data : {"id":45,"company_id":4,"office_time_id":null,"department_id":null,"user_group_id":null,"designation_id":null,"name":"Niraj Yadav","first_name":"Niraj Yadav","middle_name":null,"last_name":null,"email":"tata@gmail.com","email_opt_out":false,"email_unsubscribe_token":null,"email_unsubscribe_token_expires_at":null,"gender":null,"phone":null,"user_type":"owner","email_verified_at":null,"pic":null,"is_enable_login":1,"is_active":true,"login_disabled":false,"balance":"0.00","created_at":"2025-12-02T02:35:14.000000Z","updated_at":"2025-12-02T02:35:14.000000Z"}

class ProfileResponse {
  ProfileResponse({
      bool? success, 
      String? message, 
      ProfileData? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? ProfileData.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  ProfileData? _data;
ProfileResponse copyWith({  bool? success,
  String? message,
  ProfileData? data,
}) => ProfileResponse(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get success => _success;
  String? get message => _message;
  ProfileData? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// id : 45
/// company_id : 4
/// office_time_id : null
/// department_id : null
/// user_group_id : null
/// designation_id : null
/// name : "Niraj Yadav"
/// first_name : "Niraj Yadav"
/// middle_name : null
/// last_name : null
/// email : "tata@gmail.com"
/// email_opt_out : false
/// email_unsubscribe_token : null
/// email_unsubscribe_token_expires_at : null
/// gender : null
/// phone : null
/// user_type : "owner"
/// email_verified_at : null
/// pic : null
/// is_enable_login : 1
/// is_active : true
/// login_disabled : false
/// balance : "0.00"
/// created_at : "2025-12-02T02:35:14.000000Z"
/// updated_at : "2025-12-02T02:35:14.000000Z"

class ProfileData {
  ProfileData({
      num? id, 
      num? companyId, 
      dynamic officeTimeId, 
      dynamic departmentId, 
      dynamic userGroupId, 
      dynamic designationId, 
      String? name, 
      String? firstName, 
      dynamic middleName, 
      dynamic lastName, 
      String? email, 
      bool? emailOptOut, 
      dynamic emailUnsubscribeToken, 
      dynamic emailUnsubscribeTokenExpiresAt, 
      dynamic gender, 
      dynamic phone, 
      String? userType, 
      dynamic emailVerifiedAt, 
      dynamic pic, 
      num? isEnableLogin, 
      bool? isActive, 
      bool? loginDisabled, 
      String? balance, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _companyId = companyId;
    _officeTimeId = officeTimeId;
    _departmentId = departmentId;
    _userGroupId = userGroupId;
    _designationId = designationId;
    _name = name;
    _firstName = firstName;
    _middleName = middleName;
    _lastName = lastName;
    _email = email;
    _emailOptOut = emailOptOut;
    _emailUnsubscribeToken = emailUnsubscribeToken;
    _emailUnsubscribeTokenExpiresAt = emailUnsubscribeTokenExpiresAt;
    _gender = gender;
    _phone = phone;
    _userType = userType;
    _emailVerifiedAt = emailVerifiedAt;
    _pic = pic;
    _isEnableLogin = isEnableLogin;
    _isActive = isActive;
    _loginDisabled = loginDisabled;
    _balance = balance;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  ProfileData.fromJson(dynamic json) {
    _id = json['id'];
    _companyId = json['company_id'];
    _officeTimeId = json['office_time_id'];
    _departmentId = json['department_id'];
    _userGroupId = json['user_group_id'];
    _designationId = json['designation_id'];
    _name = json['name'];
    _firstName = json['first_name'];
    _middleName = json['middle_name'];
    _lastName = json['last_name'];
    _email = json['email'];
    _emailOptOut = json['email_opt_out'];
    _emailUnsubscribeToken = json['email_unsubscribe_token'];
    _emailUnsubscribeTokenExpiresAt = json['email_unsubscribe_token_expires_at'];
    _gender = json['gender'];
    _phone = json['phone'];
    _userType = json['user_type'];
    _emailVerifiedAt = json['email_verified_at'];
    _pic = json['pic'];
    _isEnableLogin = json['is_enable_login'];
    _isActive = json['is_active'];
    _loginDisabled = json['login_disabled'];
    _balance = json['balance'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  num? _companyId;
  dynamic _officeTimeId;
  dynamic _departmentId;
  dynamic _userGroupId;
  dynamic _designationId;
  String? _name;
  String? _firstName;
  dynamic _middleName;
  dynamic _lastName;
  String? _email;
  bool? _emailOptOut;
  dynamic _emailUnsubscribeToken;
  dynamic _emailUnsubscribeTokenExpiresAt;
  dynamic _gender;
  dynamic _phone;
  String? _userType;
  dynamic _emailVerifiedAt;
  dynamic _pic;
  num? _isEnableLogin;
  bool? _isActive;
  bool? _loginDisabled;
  String? _balance;
  String? _createdAt;
  String? _updatedAt;
  ProfileData copyWith({  num? id,
  num? companyId,
  dynamic officeTimeId,
  dynamic departmentId,
  dynamic userGroupId,
  dynamic designationId,
  String? name,
  String? firstName,
  dynamic middleName,
  dynamic lastName,
  String? email,
  bool? emailOptOut,
  dynamic emailUnsubscribeToken,
  dynamic emailUnsubscribeTokenExpiresAt,
  dynamic gender,
  dynamic phone,
  String? userType,
  dynamic emailVerifiedAt,
  dynamic pic,
  num? isEnableLogin,
  bool? isActive,
  bool? loginDisabled,
  String? balance,
  String? createdAt,
  String? updatedAt,
}) => ProfileData(  id: id ?? _id,
  companyId: companyId ?? _companyId,
  officeTimeId: officeTimeId ?? _officeTimeId,
  departmentId: departmentId ?? _departmentId,
  userGroupId: userGroupId ?? _userGroupId,
  designationId: designationId ?? _designationId,
  name: name ?? _name,
  firstName: firstName ?? _firstName,
  middleName: middleName ?? _middleName,
  lastName: lastName ?? _lastName,
  email: email ?? _email,
  emailOptOut: emailOptOut ?? _emailOptOut,
  emailUnsubscribeToken: emailUnsubscribeToken ?? _emailUnsubscribeToken,
  emailUnsubscribeTokenExpiresAt: emailUnsubscribeTokenExpiresAt ?? _emailUnsubscribeTokenExpiresAt,
  gender: gender ?? _gender,
  phone: phone ?? _phone,
  userType: userType ?? _userType,
  emailVerifiedAt: emailVerifiedAt ?? _emailVerifiedAt,
  pic: pic ?? _pic,
  isEnableLogin: isEnableLogin ?? _isEnableLogin,
  isActive: isActive ?? _isActive,
  loginDisabled: loginDisabled ?? _loginDisabled,
  balance: balance ?? _balance,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  num? get companyId => _companyId;
  dynamic get officeTimeId => _officeTimeId;
  dynamic get departmentId => _departmentId;
  dynamic get userGroupId => _userGroupId;
  dynamic get designationId => _designationId;
  String? get name => _name;
  String? get firstName => _firstName;
  dynamic get middleName => _middleName;
  dynamic get lastName => _lastName;
  String? get email => _email;
  bool? get emailOptOut => _emailOptOut;
  dynamic get emailUnsubscribeToken => _emailUnsubscribeToken;
  dynamic get emailUnsubscribeTokenExpiresAt => _emailUnsubscribeTokenExpiresAt;
  dynamic get gender => _gender;
  dynamic get phone => _phone;
  String? get userType => _userType;
  dynamic get emailVerifiedAt => _emailVerifiedAt;
  dynamic get pic => _pic;
  num? get isEnableLogin => _isEnableLogin;
  bool? get isActive => _isActive;
  bool? get loginDisabled => _loginDisabled;
  String? get balance => _balance;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['company_id'] = _companyId;
    map['office_time_id'] = _officeTimeId;
    map['department_id'] = _departmentId;
    map['user_group_id'] = _userGroupId;
    map['designation_id'] = _designationId;
    map['name'] = _name;
    map['first_name'] = _firstName;
    map['middle_name'] = _middleName;
    map['last_name'] = _lastName;
    map['email'] = _email;
    map['email_opt_out'] = _emailOptOut;
    map['email_unsubscribe_token'] = _emailUnsubscribeToken;
    map['email_unsubscribe_token_expires_at'] = _emailUnsubscribeTokenExpiresAt;
    map['gender'] = _gender;
    map['phone'] = _phone;
    map['user_type'] = _userType;
    map['email_verified_at'] = _emailVerifiedAt;
    map['pic'] = _pic;
    map['is_enable_login'] = _isEnableLogin;
    map['is_active'] = _isActive;
    map['login_disabled'] = _loginDisabled;
    map['balance'] = _balance;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}