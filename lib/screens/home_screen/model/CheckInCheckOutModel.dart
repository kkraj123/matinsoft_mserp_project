class CheckInCheckOutModel {
  final String status;
  final String message;
  final Attendance attendance;

  CheckInCheckOutModel({
    required this.status,
    required this.message,
    required this.attendance,
  });

  factory CheckInCheckOutModel.fromJson(Map<String, dynamic> json) {
    return CheckInCheckOutModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      attendance: json['attendance'] != null
          ? Attendance.fromJson(json['attendance'])
          : Attendance.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'attendance': attendance.toJson(),
    };
  }

  /// Returns an empty model (useful for initializing safely)
  factory CheckInCheckOutModel.empty() {
    return CheckInCheckOutModel(
      status: '',
      message: '',
      attendance: Attendance.empty(),
    );
  }
}

class Attendance {
  final int id;
  final int userId;
  final int companyId;
  final String attendanceDate;
  final String checkInAt;
  final String checkOutAt;
  final double? checkInLatitude;
  final double? checkOutLatitude;
  final double? checkInLongitude;
  final double? checkOutLongitude;
  final String note;
  final String editRemark;
  final int attendanceStatus;
  final int createdBy;
  final int updatedBy;
  final String createdAt;
  final String updatedAt;

  Attendance({
    required this.id,
    required this.userId,
    required this.companyId,
    required this.attendanceDate,
    required this.checkInAt,
    required this.checkOutAt,
    this.checkInLatitude,
    this.checkOutLatitude,
    this.checkInLongitude,
    this.checkOutLongitude,
    required this.note,
    required this.editRemark,
    required this.attendanceStatus,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      companyId: json['company_id'] ?? 0,
      attendanceDate: json['attendance_date'] ?? '',
      checkInAt: json['check_in_at'] ?? '',
      checkOutAt: json['check_out_at'] ?? '',
      checkInLatitude: (json['check_in_latitude'] != null)
          ? double.tryParse(json['check_in_latitude'].toString())
          : null,
      checkOutLatitude: (json['check_out_latitude'] != null)
          ? double.tryParse(json['check_out_latitude'].toString())
          : null,
      checkInLongitude: (json['check_in_longitude'] != null)
          ? double.tryParse(json['check_in_longitude'].toString())
          : null,
      checkOutLongitude: (json['check_out_longitude'] != null)
          ? double.tryParse(json['check_out_longitude'].toString())
          : null,
      note: json['note'] ?? '',
      editRemark: json['edit_remark'] ?? '',
      attendanceStatus: json['attendance_status'] ?? 0,
      createdBy: json['created_by'] ?? 0,
      updatedBy: json['updated_by'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'company_id': companyId,
      'attendance_date': attendanceDate,
      'check_in_at': checkInAt,
      'check_out_at': checkOutAt,
      'check_in_latitude': checkInLatitude,
      'check_out_latitude': checkOutLatitude,
      'check_in_longitude': checkInLongitude,
      'check_out_longitude': checkOutLongitude,
      'note': note,
      'edit_remark': editRemark,
      'attendance_status': attendanceStatus,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Empty fallback model for safety
  factory Attendance.empty() {
    return Attendance(
      id: 0,
      userId: 0,
      companyId: 0,
      attendanceDate: '',
      checkInAt: '',
      checkOutAt: '',
      checkInLatitude: null,
      checkOutLatitude: null,
      checkInLongitude: null,
      checkOutLongitude: null,
      note: '',
      editRemark: '',
      attendanceStatus: 0,
      createdBy: 0,
      updatedBy: 0,
      createdAt: '',
      updatedAt: '',
    );
  }
}
