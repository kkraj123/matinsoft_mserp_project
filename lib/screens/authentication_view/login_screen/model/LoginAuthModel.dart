class LoginAuthModel {
  final bool? status;
  final String? message;
  final LoginData? data;

  LoginAuthModel({
    this.status,
    this.message,
    this.data,
  });

  // Helper getter for token
  String? get token => data?.accessToken;

  // Helper getter for token type
  String? get tokenType => data?.tokenType;

  // Helper getter for user
  User? get user => data?.user;

  // Helper getter for sidebar menu
  List<SidebarMenu>? get sidebarMenu => data?.sidebarMenu;

  // Helper getter for modules
  List<Module>? get modules => data?.modules;

  // Check if login is successful
  bool get isSuccess => status == true;

  factory LoginAuthModel.fromJson(Map<String, dynamic> json) => LoginAuthModel(
    status: json["status"] as bool?,
    message: json["message"] as String?,
    data: json["data"] == null ? null : LoginData.fromJson(json["data"] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };

  @override
  String toString() {
    return 'LoginAuthModel(status: $status, message: $message, user: ${data?.user?.name})';
  }
}

class LoginData {
  final User? user;
  final String? userType;
  final String? accessToken;
  final String? tokenType;
  final List<Module>? modules;
  final List<SidebarMenu>? sidebarMenu;
  final List<dynamic>? permissions;

  LoginData({
    this.user,
    this.userType,
    this.accessToken,
    this.tokenType,
    this.modules,
    this.sidebarMenu,
    this.permissions,
  });

  // Helper method to check if user is owner
  bool get isOwner => userType == "owner";

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    user: json["user"] == null ? null : User.fromJson(json["user"] as Map<String, dynamic>),
    userType: json["user_type"] as String?,
    accessToken: json["access_token"] as String?,
    tokenType: json["token_type"] as String?,
    modules: json["modules"] == null
        ? null
        : List<Module>.from((json["modules"] as List).map((x) => Module.fromJson(x as Map<String, dynamic>))),
    sidebarMenu: json["sidebar_menu"] == null
        ? null
        : List<SidebarMenu>.from((json["sidebar_menu"] as List).map((x) => SidebarMenu.fromJson(x as Map<String, dynamic>))),
    permissions: json["permissions"] == null
        ? null
        : List<dynamic>.from((json["permissions"] as List).map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "user_type": userType,
    "access_token": accessToken,
    "token_type": tokenType,
    "modules": modules == null
        ? null
        : List<dynamic>.from(modules!.map((x) => x.toJson())),
    "sidebar_menu": sidebarMenu == null
        ? null
        : List<dynamic>.from(sidebarMenu!.map((x) => x.toJson())),
    "permissions": permissions == null
        ? null
        : List<dynamic>.from(permissions!.map((x) => x)),
  };

  @override
  String toString() {
    return 'LoginData(user: $user, userType: $userType, token: ${accessToken != null ? "${accessToken!.substring(0, 10)}..." : null})';
  }
}

class Module {
  final int? id;
  final String? name;
  final String? slug;
  final dynamic description;
  final dynamic icon;
  final dynamic color;
  final bool? isActive;
  final int? sortOrder;

  Module({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.icon,
    this.color,
    this.isActive,
    this.sortOrder,
  });

  factory Module.fromJson(Map<String, dynamic> json) => Module(
    id: json["id"] as int?,
    name: json["name"] as String?,
    slug: json["slug"] as String?,
    description: json["description"],
    icon: json["icon"],
    color: json["color"],
    isActive: json["is_active"] as bool?,
    sortOrder: json["sort_order"] as int?,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "description": description,
    "icon": icon,
    "color": color,
    "is_active": isActive,
    "sort_order": sortOrder,
  };

  @override
  String toString() {
    return 'Module(id: $id, name: $name, slug: $slug)';
  }
}

class SidebarMenu {
  final int? id;
  final String? title;
  final String? icon;
  final String? route;
  final dynamic url;
  final dynamic badge;
  final int? sortOrder;
  final List<dynamic>? children;

  SidebarMenu({
    this.id,
    this.title,
    this.icon,
    this.route,
    this.url,
    this.badge,
    this.sortOrder,
    this.children,
  });

  // Check if menu has children
  bool get hasChildren => children != null && children!.isNotEmpty;

  // Check if menu has a valid route
  bool get hasRoute => route != null && route!.isNotEmpty;

  factory SidebarMenu.fromJson(Map<String, dynamic> json) => SidebarMenu(
    id: json["id"] as int?,
    title: json["title"] as String?,
    icon: json["icon"] as String?,
    route: json["route"] as String?,
    url: json["url"],
    badge: json["badge"],
    sortOrder: json["sort_order"] as int?,
    children: json["children"] == null
        ? null
        : List<dynamic>.from((json["children"] as List).map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "icon": icon,
    "route": route,
    "url": url,
    "badge": badge,
    "sort_order": sortOrder,
    "children": children == null
        ? null
        : List<dynamic>.from(children!.map((x) => x)),
  };

  @override
  String toString() {
    return 'SidebarMenu(id: $id, title: $title, route: $route)';
  }
}

class User {
  final int? id;
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? gender;
  final String? userType;
  final String? pic;
  final bool? isActive;
  final Company? company;
  final String? createdAt;

  User({
    this.id,
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.gender,
    this.userType,
    this.pic,
    this.isActive,
    this.company,
    this.createdAt,
  });

  // Get full name (first + last)
  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return name ?? email ?? 'Unknown User';
  }

  // Check if user has profile picture
  bool get hasProfilePic => pic != null && pic!.isNotEmpty && pic != 'https://mserp.matinsoftech.com/assets/images/avatar.png';

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] as int?,
    name: json["name"] as String?,
    firstName: json["first_name"] as String?,
    lastName: json["last_name"] as String?,
    email: json["email"] as String?,
    phone: json["phone"] as String?,
    gender: json["gender"] as String?,
    userType: json["user_type"] as String?,
    pic: json["pic"] as String?,
    isActive: json["is_active"] as bool?,
    company: json["company"] == null
        ? null
        : Company.fromJson(json["company"] as Map<String, dynamic>),
    createdAt: json["created_at"] as String?,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "phone": phone,
    "gender": gender,
    "user_type": userType,
    "pic": pic,
    "is_active": isActive,
    "company": company?.toJson(),
    "created_at": createdAt,
  };

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, type: $userType)';
  }
}

class Company {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;

  Company({
    this.id,
    this.name,
    this.email,
    this.phone,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"] as int?,
    name: json["name"] as String?,
    email: json["email"] as String?,
    phone: json["phone"] as String?,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
  };

  @override
  String toString() {
    return 'Company(id: $id, name: $name)';
  }
}

// Extension for easy JSON parsing
extension LoginAuthModelExtensions on LoginAuthModel {
  // Get authorization header
  Map<String, String> get authHeader {
    return {
      'Authorization': '$tokenType $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // Check if user can access a specific module
  bool canAccessModule(String moduleSlug) {
    if (modules == null) return false;
    return modules!.any((module) => module.slug == moduleSlug && module.isActive == true);
  }

  // Get module by slug
  Module? getModuleBySlug(String slug) {
    return modules?.firstWhere(
          (module) => module.slug == slug && module.isActive == true,
      orElse: () => Module(),
    );
  }

  // Get sidebar menu item by route
  SidebarMenu? getSidebarMenuItemByRoute(String route) {
    return sidebarMenu?.firstWhere(
          (menu) => menu.route == route,
      orElse: () => SidebarMenu(),
    );
  }
}

// Extension for User
extension UserExtensions on User {
  // Check if user is active
  bool get isActiveUser => isActive == true;

  // Get formatted phone number
  String get formattedPhone {
    if (phone == null || phone!.isEmpty) return 'N/A';
    return phone!;
  }

  // Get formatted created date
  String get formattedCreatedDate {
    if (createdAt == null || createdAt!.isEmpty) return 'N/A';
    try {
      final date = DateTime.tryParse(createdAt!);
      return date != null
          ? '${date.day}/${date.month}/${date.year}'
          : createdAt!;
    } catch (e) {
      return createdAt!;
    }
  }
}