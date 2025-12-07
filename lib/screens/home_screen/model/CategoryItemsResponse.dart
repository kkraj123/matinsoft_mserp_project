class CategoryItemsResponse {
  CategoryItemsResponse({
    String? status,
    List<ModulesList>? modules,
  }) {
    _status = status;
    _modules = modules;
  }

  CategoryItemsResponse.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    if (json['modules'] != null) {
      _modules = [];
      json['modules'].forEach((v) {
        _modules?.add(ModulesList.fromJson(v));
      });
    }
  }

  String? _status;
  List<ModulesList>? _modules;

  CategoryItemsResponse copyWith({
    String? status,
    List<ModulesList>? modules,
  }) =>
      CategoryItemsResponse(
        status: status ?? _status,
        modules: modules ?? _modules,
      );

  String? get status => _status;
  List<ModulesList>? get modules => _modules;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    if (_modules != null) {
      map['modules'] = _modules?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ModulesList {
  ModulesList({
    String? name,
    String? icon,
    String? route,
    String? url,
    List<Children>? children,
  }) {
    _name = name;
    _icon = icon;
    _route = route;
    _url = url;
    _children = children;
  }

  ModulesList.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _icon = json['icon'];
    _route = json['route'];
    _url = json['url'];
    if (json['children'] != null) {
      _children = [];
      json['children'].forEach((v) {
        _children?.add(Children.fromJson(v));
      });
    }
  }

  String? _name;
  String? _icon;
  String? _route;
  String? _url;
  List<Children>? _children;

  ModulesList copyWith({
    String? name,
    String? icon,
    String? route,
    String? url,
    List<Children>? children,
  }) =>
      ModulesList(
        name: name ?? _name,
        icon: icon ?? _icon,
        route: route ?? _route,
        url: url ?? _url,
        children: children ?? _children,
      );

  String? get name => _name;
  String? get icon => _icon;
  String? get route => _route;
  String? get url => _url;
  List<Children>? get children => _children;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['icon'] = _icon;
    map['route'] = _route;
    map['url'] = _url;
    if (_children != null) {
      map['children'] = _children?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Children {
  Children({
    String? name,
    String? icon,
    String? route,
  }) {
    _name = name;
    _icon = icon;
    _route = route;
  }

  Children.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _icon = json['icon'];
    _route = json['route'];
  }

  String? _name;
  String? _icon;
  String? _route;

  Children copyWith({
    String? name,
    String? icon,
    String? route,
  }) =>
      Children(
        name: name ?? _name,
        icon: icon ?? _icon,
        route: route ?? _route,
      );

  String? get name => _name;
  String? get icon => _icon;
  String? get route => _route;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['icon'] = _icon;
    map['route'] = _route;
    return map;
  }
}