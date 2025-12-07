
class SurveyListResponse {
  final String status;
  final String message;
  final SurveyData data;

  SurveyListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SurveyListResponse.fromJson(Map<String, dynamic> json) {
    return SurveyListResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: SurveyData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class SurveyData {
  final int currentPage;
  final List<Survey> surveys;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<PaginationLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  SurveyData({
    required this.currentPage,
    required this.surveys,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory SurveyData.fromJson(Map<String, dynamic> json) {
    return SurveyData(
      currentPage: json['current_page'] as int,
      surveys: (json['data'] as List)
          .map((survey) => Survey.fromJson(survey as Map<String, dynamic>))
          .toList(),
      firstPageUrl: json['first_page_url'] as String,
      from: json['from'] as int,
      lastPage: json['last_page'] as int,
      lastPageUrl: json['last_page_url'] as String,
      links: (json['links'] as List)
          .map((link) => PaginationLink.fromJson(link as Map<String, dynamic>))
          .toList(),
      nextPageUrl: json['next_page_url'] as String?,
      path: json['path'] as String,
      perPage: json['per_page'] as int,
      prevPageUrl: json['prev_page_url'] as String?,
      to: json['to'] as int,
      total: json['total'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': surveys.map((survey) => survey.toJson()).toList(),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': links.map((link) => link.toJson()).toList(),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }
}

class Survey {
  final int surveyId;
  final int companyId;
  final String title;
  final String? description;
  final String slug;
  final String? startDate;
  final String? endDate;
  final Map<String, dynamic>? settingsJson;
  final String status;
  final bool isPrivate;
  final String? privateToken;
  final bool restrictByIp;
  final int ipRestriction;
  final bool singleSubmission;
  final bool isTemplate;
  final int createdBy;
  final String createdAt;
  final String updatedAt;
  final List<Question> questions;

  Survey({
    required this.surveyId,
    required this.companyId,
    required this.title,
    this.description,
    required this.slug,
    this.startDate,
    this.endDate,
    this.settingsJson,
    required this.status,
    required this.isPrivate,
    this.privateToken,
    required this.restrictByIp,
    required this.ipRestriction,
    required this.singleSubmission,
    required this.isTemplate,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.questions,
  });

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      surveyId: json['id'] as int,
      companyId: json['company_id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      slug: json['slug'] as String,
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      settingsJson: json['settings_json'] as Map<String, dynamic>?,
      status: json['status'] as String,
      isPrivate: json['is_private'] as bool,
      privateToken: json['private_token'] as String?,
      restrictByIp: json['restrict_by_ip'] as bool,
      // private: json['private'] as int,
      ipRestriction: json['ip_restriction'] as int,
      singleSubmission: json['single_submission'] as bool,
      isTemplate: json['is_template'] as bool,
      createdBy: json['created_by'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      // creator: Creator.fromJson(json['creator'] as Map<String, dynamic>),
      questions: (json['questions'] as List)
          .map((question) => Question.fromJson(question as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': surveyId,
      'company_id': companyId,
      'title': title,
      'description': description,
      'slug': slug,
      'start_date': startDate,
      'end_date': endDate,
      'settings_json': settingsJson,
      'status': status,
      'is_private': isPrivate,
      'private_token': privateToken,
      'restrict_by_ip': restrictByIp,
      // 'private': private,
      'ip_restriction': ipRestriction,
      'single_submission': singleSubmission,
      'is_template': isTemplate,
      'created_by': createdBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      // 'creator': creator.toJson(),
      'questions': questions.map((question) => question.toJson()).toList(),
    };
  }
}

class Creator {
  final int creatorId;
  final String name;

  Creator({
    required this.creatorId,
    required this.name,
  });

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      creatorId: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': creatorId,
      'name': name,
    };
  }
}

class Question {
  final int questionId;
  final int surveyId;
  final String type;
  final String label;
  final List<dynamic> optionsJson;
  final bool required;
  final int orderNo;
  final dynamic logicJson;
  final String createdAt;
  final String updatedAt;

  Question({
    required this.questionId,
    required this.surveyId,
    required this.type,
    required this.label,
    required this.optionsJson,
    required this.required,
    required this.orderNo,
    this.logicJson,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionId: json['id'] as int,
      surveyId: json['survey_id'] as int,
      type: json['type'] as String,
      label: json['label'] as String,
      optionsJson: json['options_json'] as List<dynamic>,
      required: json['required'] as bool,
      orderNo: json['order_no'] as int,
      logicJson: json['logic_json'],
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': questionId,
      'survey_id': surveyId,
      'type': type,
      'label': label,
      'options_json': optionsJson,
      'required': required,
      'order_no': orderNo,
      'logic_json': logicJson,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class PaginationLink {
  final String? url;
  final String label;
  final int? page;
  final bool active;

  PaginationLink({
    this.url,
    required this.label,
    this.page,
    required this.active,
  });

  factory PaginationLink.fromJson(Map<String, dynamic> json) {
    return PaginationLink(
      url: json['url'] as String?,
      label: json['label'] as String,
      page: json['page'] as int?,
      active: json['active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'page': page,
      'active': active,
    };
  }
}