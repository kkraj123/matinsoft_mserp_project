/// success : true
/// data : {"user":{"id":45,"name":"Tata Group Pvt Ltd","email":"tata@gmail.com"},"wallet":{"total_balance":"10,500.00","available_balance":"9,500.00","in_active_loans":"1,500.00","total_balance_raw":"10500.00","available_balance_raw":"9500.00","in_active_loans_raw":"1500.00"},"statistics":{"this_month_expenses":"10,000.00","last_month_expenses":"0.00","total_expenses":"10,000.00","this_month_expenses_raw":"10000.00","last_month_expenses_raw":0,"total_expenses_raw":"10000.00","family_members_count":2},"family_members":[{"id":6,"member_id":52,"member_name":"Ashim Rai","member_email":"ashimrai903@gmail.com","member_pic":null,"relationship":"Brother","wallet_balance":"0.00","wallet_balance_raw":"0.00","is_self":false},{"id":10,"member_id":55,"member_name":"Kkraj Rajbanshi","member_email":"kkraj321@gmail.com","member_pic":null,"relationship":"Brother","wallet_balance":"0.00","wallet_balance_raw":0,"is_self":false}],"recent_expenses":[{"id":1,"amount":"10,000.00","amount_raw":"10000.00","description":"this is the karam expense","expense_date":"2025-12-07","expense_date_formatted":"Dec 07, 2025","category":{"id":25,"name":"medical","icon":"ri-folder-line","color":"#6c757d"}}],"expenses_by_category":[{"category_id":25,"category_name":"medical","category_icon":"ri-folder-line","category_color":"#6c757d","total":10000,"total_formatted":"10,000.00","count":1}]}

class FamilyDashboardResponse {
  FamilyDashboardResponse({
      bool? success, 
      FamilyDataObj? data,}){
    _success = success;
    _data = data;
}

  FamilyDashboardResponse.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _data = json['data'] != null ? FamilyDataObj.fromJson(json['data']) : null;
  }
  bool? _success;
  FamilyDataObj? _data;
FamilyDashboardResponse copyWith({  bool? success,
  FamilyDataObj? data,
}) => FamilyDashboardResponse(  success: success ?? _success,
  data: data ?? _data,
);
  bool? get success => _success;
  FamilyDataObj? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// user : {"id":45,"name":"Tata Group Pvt Ltd","email":"tata@gmail.com"}
/// wallet : {"total_balance":"10,500.00","available_balance":"9,500.00","in_active_loans":"1,500.00","total_balance_raw":"10500.00","available_balance_raw":"9500.00","in_active_loans_raw":"1500.00"}
/// statistics : {"this_month_expenses":"10,000.00","last_month_expenses":"0.00","total_expenses":"10,000.00","this_month_expenses_raw":"10000.00","last_month_expenses_raw":0,"total_expenses_raw":"10000.00","family_members_count":2}
/// family_members : [{"id":6,"member_id":52,"member_name":"Ashim Rai","member_email":"ashimrai903@gmail.com","member_pic":null,"relationship":"Brother","wallet_balance":"0.00","wallet_balance_raw":"0.00","is_self":false},{"id":10,"member_id":55,"member_name":"Kkraj Rajbanshi","member_email":"kkraj321@gmail.com","member_pic":null,"relationship":"Brother","wallet_balance":"0.00","wallet_balance_raw":0,"is_self":false}]
/// recent_expenses : [{"id":1,"amount":"10,000.00","amount_raw":"10000.00","description":"this is the karam expense","expense_date":"2025-12-07","expense_date_formatted":"Dec 07, 2025","category":{"id":25,"name":"medical","icon":"ri-folder-line","color":"#6c757d"}}]
/// expenses_by_category : [{"category_id":25,"category_name":"medical","category_icon":"ri-folder-line","category_color":"#6c757d","total":10000,"total_formatted":"10,000.00","count":1}]

class FamilyDataObj {
  FamilyDataObj({
      User? user, 
      Wallet? wallet, 
      Statistics? statistics, 
      List<FamilyMembers>? familyMembers, 
      List<RecentExpenses>? recentExpenses, 
      List<ExpensesByCategory>? expensesByCategory,}){
    _user = user;
    _wallet = wallet;
    _statistics = statistics;
    _familyMembers = familyMembers;
    _recentExpenses = recentExpenses;
    _expensesByCategory = expensesByCategory;
}

  FamilyDataObj.fromJson(Map<String, dynamic> json) {
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    _wallet = json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null;
    _statistics = json['statistics'] != null ? Statistics.fromJson(json['statistics']) : null;
    if (json['family_members'] != null) {
      _familyMembers = [];
      json['family_members'].forEach((v) {
        _familyMembers?.add(FamilyMembers.fromJson(v));
      });
    }
    if (json['recent_expenses'] != null) {
      _recentExpenses = [];
      json['recent_expenses'].forEach((v) {
        _recentExpenses?.add(RecentExpenses.fromJson(v));
      });
    }
    if (json['expenses_by_category'] != null) {
      _expensesByCategory = [];
      json['expenses_by_category'].forEach((v) {
        _expensesByCategory?.add(ExpensesByCategory.fromJson(v));
      });
    }
  }
  User? _user;
  Wallet? _wallet;
  Statistics? _statistics;
  List<FamilyMembers>? _familyMembers;
  List<RecentExpenses>? _recentExpenses;
  List<ExpensesByCategory>? _expensesByCategory;
  FamilyDataObj copyWith({  User? user,
  Wallet? wallet,
  Statistics? statistics,
  List<FamilyMembers>? familyMembers,
  List<RecentExpenses>? recentExpenses,
  List<ExpensesByCategory>? expensesByCategory,
}) => FamilyDataObj(  user: user ?? _user,
  wallet: wallet ?? _wallet,
  statistics: statistics ?? _statistics,
  familyMembers: familyMembers ?? _familyMembers,
  recentExpenses: recentExpenses ?? _recentExpenses,
  expensesByCategory: expensesByCategory ?? _expensesByCategory,
);
  User? get user => _user;
  Wallet? get wallet => _wallet;
  Statistics? get statistics => _statistics;
  List<FamilyMembers>? get familyMembers => _familyMembers;
  List<RecentExpenses>? get recentExpenses => _recentExpenses;
  List<ExpensesByCategory>? get expensesByCategory => _expensesByCategory;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    if (_wallet != null) {
      map['wallet'] = _wallet?.toJson();
    }
    if (_statistics != null) {
      map['statistics'] = _statistics?.toJson();
    }
    if (_familyMembers != null) {
      map['family_members'] = _familyMembers?.map((v) => v.toJson()).toList();
    }
    if (_recentExpenses != null) {
      map['recent_expenses'] = _recentExpenses?.map((v) => v.toJson()).toList();
    }
    if (_expensesByCategory != null) {
      map['expenses_by_category'] = _expensesByCategory?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// category_id : 25
/// category_name : "medical"
/// category_icon : "ri-folder-line"
/// category_color : "#6c757d"
/// total : 10000
/// total_formatted : "10,000.00"
/// count : 1

class ExpensesByCategory {
  ExpensesByCategory({
      num? categoryId, 
      String? categoryName, 
      String? categoryIcon, 
      String? categoryColor, 
      num? total, 
      String? totalFormatted, 
      num? count,}){
    _categoryId = categoryId;
    _categoryName = categoryName;
    _categoryIcon = categoryIcon;
    _categoryColor = categoryColor;
    _total = total;
    _totalFormatted = totalFormatted;
    _count = count;
}

  ExpensesByCategory.fromJson(dynamic json) {
    _categoryId = json['category_id'];
    _categoryName = json['category_name'];
    _categoryIcon = json['category_icon'];
    _categoryColor = json['category_color'];
    _total = json['total'];
    _totalFormatted = json['total_formatted'];
    _count = json['count'];
  }
  num? _categoryId;
  String? _categoryName;
  String? _categoryIcon;
  String? _categoryColor;
  num? _total;
  String? _totalFormatted;
  num? _count;
ExpensesByCategory copyWith({  num? categoryId,
  String? categoryName,
  String? categoryIcon,
  String? categoryColor,
  num? total,
  String? totalFormatted,
  num? count,
}) => ExpensesByCategory(  categoryId: categoryId ?? _categoryId,
  categoryName: categoryName ?? _categoryName,
  categoryIcon: categoryIcon ?? _categoryIcon,
  categoryColor: categoryColor ?? _categoryColor,
  total: total ?? _total,
  totalFormatted: totalFormatted ?? _totalFormatted,
  count: count ?? _count,
);
  num? get categoryId => _categoryId;
  String? get categoryName => _categoryName;
  String? get categoryIcon => _categoryIcon;
  String? get categoryColor => _categoryColor;
  num? get total => _total;
  String? get totalFormatted => _totalFormatted;
  num? get count => _count;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['category_id'] = _categoryId;
    map['category_name'] = _categoryName;
    map['category_icon'] = _categoryIcon;
    map['category_color'] = _categoryColor;
    map['total'] = _total;
    map['total_formatted'] = _totalFormatted;
    map['count'] = _count;
    return map;
  }

}

/// id : 1
/// amount : "10,000.00"
/// amount_raw : "10000.00"
/// description : "this is the karam expense"
/// expense_date : "2025-12-07"
/// expense_date_formatted : "Dec 07, 2025"
/// category : {"id":25,"name":"medical","icon":"ri-folder-line","color":"#6c757d"}

class RecentExpenses {
  RecentExpenses({
      num? id, 
      String? amount, 
      String? amountRaw, 
      String? description, 
      String? expenseDate, 
      String? expenseDateFormatted, 
      Category? category,}){
    _id = id;
    _amount = amount;
    _amountRaw = amountRaw;
    _description = description;
    _expenseDate = expenseDate;
    _expenseDateFormatted = expenseDateFormatted;
    _category = category;
}

  RecentExpenses.fromJson(dynamic json) {
    _id = json['id'];
    _amount = json['amount'];
    _amountRaw = json['amount_raw'];
    _description = json['description'];
    _expenseDate = json['expense_date'];
    _expenseDateFormatted = json['expense_date_formatted'];
    _category = json['category'] != null ? Category.fromJson(json['category']) : null;
  }
  num? _id;
  String? _amount;
  String? _amountRaw;
  String? _description;
  String? _expenseDate;
  String? _expenseDateFormatted;
  Category? _category;
RecentExpenses copyWith({  num? id,
  String? amount,
  String? amountRaw,
  String? description,
  String? expenseDate,
  String? expenseDateFormatted,
  Category? category,
}) => RecentExpenses(  id: id ?? _id,
  amount: amount ?? _amount,
  amountRaw: amountRaw ?? _amountRaw,
  description: description ?? _description,
  expenseDate: expenseDate ?? _expenseDate,
  expenseDateFormatted: expenseDateFormatted ?? _expenseDateFormatted,
  category: category ?? _category,
);
  num? get id => _id;
  String? get amount => _amount;
  String? get amountRaw => _amountRaw;
  String? get description => _description;
  String? get expenseDate => _expenseDate;
  String? get expenseDateFormatted => _expenseDateFormatted;
  Category? get category => _category;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['amount'] = _amount;
    map['amount_raw'] = _amountRaw;
    map['description'] = _description;
    map['expense_date'] = _expenseDate;
    map['expense_date_formatted'] = _expenseDateFormatted;
    if (_category != null) {
      map['category'] = _category?.toJson();
    }
    return map;
  }

}

/// id : 25
/// name : "medical"
/// icon : "ri-folder-line"
/// color : "#6c757d"

class Category {
  Category({
      num? id, 
      String? name, 
      String? icon, 
      String? color,}){
    _id = id;
    _name = name;
    _icon = icon;
    _color = color;
}

  Category.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _icon = json['icon'];
    _color = json['color'];
  }
  num? _id;
  String? _name;
  String? _icon;
  String? _color;
Category copyWith({  num? id,
  String? name,
  String? icon,
  String? color,
}) => Category(  id: id ?? _id,
  name: name ?? _name,
  icon: icon ?? _icon,
  color: color ?? _color,
);
  num? get id => _id;
  String? get name => _name;
  String? get icon => _icon;
  String? get color => _color;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['icon'] = _icon;
    map['color'] = _color;
    return map;
  }

}

/// id : 6
/// member_id : 52
/// member_name : "Ashim Rai"
/// member_email : "ashimrai903@gmail.com"
/// member_pic : null
/// relationship : "Brother"
/// wallet_balance : "0.00"
/// wallet_balance_raw : "0.00"
/// is_self : false

class FamilyMembers {
  FamilyMembers({
      num? id, 
      num? memberId, 
      String? memberName, 
      String? memberEmail, 
      dynamic memberPic, 
      String? relationship, 
      String? walletBalance, 
      String? walletBalanceRaw, 
      bool? isSelf,}){
    _id = id;
    _memberId = memberId;
    _memberName = memberName;
    _memberEmail = memberEmail;
    _memberPic = memberPic;
    _relationship = relationship;
    _walletBalance = walletBalance;
    _walletBalanceRaw = walletBalanceRaw;
    _isSelf = isSelf;
}

  FamilyMembers.fromJson(dynamic json) {
    _id = json['id'];
    _memberId = json['member_id'];
    _memberName = json['member_name'];
    _memberEmail = json['member_email'];
    _memberPic = json['member_pic'];
    _relationship = json['relationship'];
    _walletBalance = json['wallet_balance'];
    _walletBalanceRaw = json['wallet_balance_raw'];
    _isSelf = json['is_self'];
  }
  num? _id;
  num? _memberId;
  String? _memberName;
  String? _memberEmail;
  dynamic _memberPic;
  String? _relationship;
  String? _walletBalance;
  String? _walletBalanceRaw;
  bool? _isSelf;
FamilyMembers copyWith({  num? id,
  num? memberId,
  String? memberName,
  String? memberEmail,
  dynamic memberPic,
  String? relationship,
  String? walletBalance,
  String? walletBalanceRaw,
  bool? isSelf,
}) => FamilyMembers(  id: id ?? _id,
  memberId: memberId ?? _memberId,
  memberName: memberName ?? _memberName,
  memberEmail: memberEmail ?? _memberEmail,
  memberPic: memberPic ?? _memberPic,
  relationship: relationship ?? _relationship,
  walletBalance: walletBalance ?? _walletBalance,
  walletBalanceRaw: walletBalanceRaw ?? _walletBalanceRaw,
  isSelf: isSelf ?? _isSelf,
);
  num? get id => _id;
  num? get memberId => _memberId;
  String? get memberName => _memberName;
  String? get memberEmail => _memberEmail;
  dynamic get memberPic => _memberPic;
  String? get relationship => _relationship;
  String? get walletBalance => _walletBalance;
  String? get walletBalanceRaw => _walletBalanceRaw;
  bool? get isSelf => _isSelf;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['member_id'] = _memberId;
    map['member_name'] = _memberName;
    map['member_email'] = _memberEmail;
    map['member_pic'] = _memberPic;
    map['relationship'] = _relationship;
    map['wallet_balance'] = _walletBalance;
    map['wallet_balance_raw'] = _walletBalanceRaw;
    map['is_self'] = _isSelf;
    return map;
  }

}

/// this_month_expenses : "10,000.00"
/// last_month_expenses : "0.00"
/// total_expenses : "10,000.00"
/// this_month_expenses_raw : "10000.00"
/// last_month_expenses_raw : 0
/// total_expenses_raw : "10000.00"
/// family_members_count : 2

class Statistics {
  Statistics({
      String? thisMonthExpenses, 
      String? lastMonthExpenses, 
      String? totalExpenses, 
      String? thisMonthExpensesRaw, 
      num? lastMonthExpensesRaw, 
      String? totalExpensesRaw, 
      num? familyMembersCount,}){
    _thisMonthExpenses = thisMonthExpenses;
    _lastMonthExpenses = lastMonthExpenses;
    _totalExpenses = totalExpenses;
    _thisMonthExpensesRaw = thisMonthExpensesRaw;
    _lastMonthExpensesRaw = lastMonthExpensesRaw;
    _totalExpensesRaw = totalExpensesRaw;
    _familyMembersCount = familyMembersCount;
}

  Statistics.fromJson(dynamic json) {
    _thisMonthExpenses = json['this_month_expenses'];
    _lastMonthExpenses = json['last_month_expenses'];
    _totalExpenses = json['total_expenses'];
    _thisMonthExpensesRaw = json['this_month_expenses_raw'];
    _lastMonthExpensesRaw = json['last_month_expenses_raw'];
    _totalExpensesRaw = json['total_expenses_raw'];
    _familyMembersCount = json['family_members_count'];
  }
  String? _thisMonthExpenses;
  String? _lastMonthExpenses;
  String? _totalExpenses;
  String? _thisMonthExpensesRaw;
  num? _lastMonthExpensesRaw;
  String? _totalExpensesRaw;
  num? _familyMembersCount;
Statistics copyWith({  String? thisMonthExpenses,
  String? lastMonthExpenses,
  String? totalExpenses,
  String? thisMonthExpensesRaw,
  num? lastMonthExpensesRaw,
  String? totalExpensesRaw,
  num? familyMembersCount,
}) => Statistics(  thisMonthExpenses: thisMonthExpenses ?? _thisMonthExpenses,
  lastMonthExpenses: lastMonthExpenses ?? _lastMonthExpenses,
  totalExpenses: totalExpenses ?? _totalExpenses,
  thisMonthExpensesRaw: thisMonthExpensesRaw ?? _thisMonthExpensesRaw,
  lastMonthExpensesRaw: lastMonthExpensesRaw ?? _lastMonthExpensesRaw,
  totalExpensesRaw: totalExpensesRaw ?? _totalExpensesRaw,
  familyMembersCount: familyMembersCount ?? _familyMembersCount,
);
  String? get thisMonthExpenses => _thisMonthExpenses;
  String? get lastMonthExpenses => _lastMonthExpenses;
  String? get totalExpenses => _totalExpenses;
  String? get thisMonthExpensesRaw => _thisMonthExpensesRaw;
  num? get lastMonthExpensesRaw => _lastMonthExpensesRaw;
  String? get totalExpensesRaw => _totalExpensesRaw;
  num? get familyMembersCount => _familyMembersCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['this_month_expenses'] = _thisMonthExpenses;
    map['last_month_expenses'] = _lastMonthExpenses;
    map['total_expenses'] = _totalExpenses;
    map['this_month_expenses_raw'] = _thisMonthExpensesRaw;
    map['last_month_expenses_raw'] = _lastMonthExpensesRaw;
    map['total_expenses_raw'] = _totalExpensesRaw;
    map['family_members_count'] = _familyMembersCount;
    return map;
  }

}

/// total_balance : "10,500.00"
/// available_balance : "9,500.00"
/// in_active_loans : "1,500.00"
/// total_balance_raw : "10500.00"
/// available_balance_raw : "9500.00"
/// in_active_loans_raw : "1500.00"

class Wallet {
  Wallet({
      String? totalBalance, 
      String? availableBalance, 
      String? inActiveLoans, 
      String? totalBalanceRaw, 
      String? availableBalanceRaw, 
      String? inActiveLoansRaw,}){
    _totalBalance = totalBalance;
    _availableBalance = availableBalance;
    _inActiveLoans = inActiveLoans;
    _totalBalanceRaw = totalBalanceRaw;
    _availableBalanceRaw = availableBalanceRaw;
    _inActiveLoansRaw = inActiveLoansRaw;
}

  Wallet.fromJson(dynamic json) {
    _totalBalance = json['total_balance'];
    _availableBalance = json['available_balance'];
    _inActiveLoans = json['in_active_loans'];
    _totalBalanceRaw = json['total_balance_raw'];
    _availableBalanceRaw = json['available_balance_raw'];
    _inActiveLoansRaw = json['in_active_loans_raw'];
  }
  String? _totalBalance;
  String? _availableBalance;
  String? _inActiveLoans;
  String? _totalBalanceRaw;
  String? _availableBalanceRaw;
  String? _inActiveLoansRaw;
Wallet copyWith({  String? totalBalance,
  String? availableBalance,
  String? inActiveLoans,
  String? totalBalanceRaw,
  String? availableBalanceRaw,
  String? inActiveLoansRaw,
}) => Wallet(  totalBalance: totalBalance ?? _totalBalance,
  availableBalance: availableBalance ?? _availableBalance,
  inActiveLoans: inActiveLoans ?? _inActiveLoans,
  totalBalanceRaw: totalBalanceRaw ?? _totalBalanceRaw,
  availableBalanceRaw: availableBalanceRaw ?? _availableBalanceRaw,
  inActiveLoansRaw: inActiveLoansRaw ?? _inActiveLoansRaw,
);
  String? get totalBalance => _totalBalance;
  String? get availableBalance => _availableBalance;
  String? get inActiveLoans => _inActiveLoans;
  String? get totalBalanceRaw => _totalBalanceRaw;
  String? get availableBalanceRaw => _availableBalanceRaw;
  String? get inActiveLoansRaw => _inActiveLoansRaw;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_balance'] = _totalBalance;
    map['available_balance'] = _availableBalance;
    map['in_active_loans'] = _inActiveLoans;
    map['total_balance_raw'] = _totalBalanceRaw;
    map['available_balance_raw'] = _availableBalanceRaw;
    map['in_active_loans_raw'] = _inActiveLoansRaw;
    return map;
  }

}

/// id : 45
/// name : "Tata Group Pvt Ltd"
/// email : "tata@gmail.com"

class User {
  User({
      num? id, 
      String? name, 
      String? email,}){
    _id = id;
    _name = name;
    _email = email;
}

  User.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
  }
  num? _id;
  String? _name;
  String? _email;
User copyWith({  num? id,
  String? name,
  String? email,
}) => User(  id: id ?? _id,
  name: name ?? _name,
  email: email ?? _email,
);
  num? get id => _id;
  String? get name => _name;
  String? get email => _email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['email'] = _email;
    return map;
  }

}