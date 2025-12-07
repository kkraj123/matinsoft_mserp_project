class LeaveType {
  final int id;
  final String name;
  final String slug;
  final int leaveAllocated;
  final int companyId;
  final int isActive;
  final int isPaid;
  final int earlyExit;
  final int createdBy;
  final int? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  LeaveType({
    required this.id,
    required this.name,
    required this.slug,
    required this.leaveAllocated,
    required this.companyId,
    required this.isActive,
    required this.isPaid,
    required this.earlyExit,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LeaveType.fromJson(Map<String, dynamic> json) {
    return LeaveType(
      id: json["id"],
      name: json["name"],
      slug: json["slug"],
      leaveAllocated: json["leave_allocated"],
      companyId: json["company_id"],
      isActive: json["is_active"],
      isPaid: json["is_paid"],
      earlyExit: json["early_exit"],
      createdBy: json["created_by"],
      updatedBy: json["updated_by"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "leave_allocated": leaveAllocated,
    "company_id": companyId,
    "is_active": isActive,
    "is_paid": isPaid,
    "early_exit": earlyExit,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

/// --- Parser for List Response ----
class LeaveTypeResponse {
  final List<LeaveType> list;

  LeaveTypeResponse({required this.list});

  factory LeaveTypeResponse.fromJson(List<dynamic> jsonList) {
    return LeaveTypeResponse(
      list: jsonList.map((e) => LeaveType.fromJson(e)).toList(),
    );
  }
}
