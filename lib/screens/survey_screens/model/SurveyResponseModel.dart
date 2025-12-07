
class SurveyResponseModel {
  final String status;
  final String message;
  final SurveyResponseData data;

  SurveyResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SurveyResponseModel.fromJson(Map<String, dynamic> json) {
    return SurveyResponseModel(
      status: json["status"] ?? "",
      message: json["message"] ?? "",
      data: SurveyResponseData.fromJson(json["data"]),
    );
  }
}

class SurveyResponseData {
  final int surveyId;
  final int companyId;
  final int userId;
  final String submittedAt;
  final String updatedAt;
  final String createdAt;
  final int id;
  final Survey survey;
  final List<Answer> answers;

  SurveyResponseData({
    required this.surveyId,
    required this.companyId,
    required this.userId,
    required this.submittedAt,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.survey,
    required this.answers,
  });

  factory SurveyResponseData.fromJson(Map<String, dynamic> json) {
    return SurveyResponseData(
      surveyId: json["survey_id"],
      companyId: json["company_id"],
      userId: json["user_id"],
      submittedAt: json["submitted_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
      createdAt: json["created_at"] ?? "",
      id: json["id"],
      survey: Survey.fromJson(json["survey"]),
      answers: (json["answers"] as List)
          .map((e) => Answer.fromJson(e))
          .toList(),
    );
  }
}

class Survey {
  final int id;
  final int companyId;
  final String title;
  final String? description;
  final String slug;
  final String startDate;
  final String? endDate;
  final Map<String, dynamic>? settingsJson;
  // final String? settingsJson;
  final String status;
  final bool isPrivate;
  final dynamic privateToken;
  final bool restrictByIp;
  final bool singleSubmission;
  final bool isTemplate;
  final int createdBy;
  final String createdAt;
  final String updatedAt;

  Survey({
    required this.id,
    required this.companyId,
    required this.title,
    required this.description,
    required this.slug,
    required this.startDate,
    required this.endDate,
    required this.settingsJson,
    required this.status,
    required this.isPrivate,
    required this.privateToken,
    required this.restrictByIp,
    required this.singleSubmission,
    required this.isTemplate,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      id: json["id"],
      companyId: json["company_id"],
      title: json["title"] ?? "",
      description: json["description"],
      slug: json["slug"] ?? "",
      startDate: json["start_date"] ?? "",
      endDate: json["end_date"],
      settingsJson: json["settings_json"] != null
          ? Map<String, dynamic>.from(json["settings_json"])
          : null,
      status: json["status"] ?? "",
      isPrivate: json["is_private"] ?? false,
      privateToken: json["private_token"],
      restrictByIp: json["restrict_by_ip"] ?? false,
      singleSubmission: json["single_submission"] ?? false,
      isTemplate: json["is_template"] ?? false,
      createdBy: json["created_by"],
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
    );
  }
}

class Answer {
  final int id;
  final int responseId;
  final int questionId;
  final String? answerText;
  final dynamic answerJson;
  final String? filePath;
  final String? fileName;
  final String createdAt;
  final String updatedAt;
  final Question question;

  Answer({
    required this.id,
    required this.responseId,
    required this.questionId,
    required this.answerText,
    required this.answerJson,
    required this.filePath,
    required this.fileName,
    required this.createdAt,
    required this.updatedAt,
    required this.question,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json["id"],
      responseId: json["response_id"],
      questionId: json["question_id"],
      answerText: json["answer_text"],
      answerJson: json["answer_json"],
      filePath: json["file_path"],
      fileName: json["file_name"],
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
      question: Question.fromJson(json["question"]),
    );
  }
}

class Question {
  final int id;
  final int surveyId;
  final String type;
  final String label;
  final List<String> optionsJson;
  final bool required;
  final int orderNo;
  final dynamic logicJson;
  final String createdAt;
  final String updatedAt;

  Question({
    required this.id,
    required this.surveyId,
    required this.type,
    required this.label,
    required this.optionsJson,
    required this.required,
    required this.orderNo,
    required this.logicJson,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json["id"],
      surveyId: json["survey_id"],
      type: json["type"] ?? "",
      label: json["label"] ?? "",
      optionsJson: json["options_json"] != null
          ? List<String>.from(json["options_json"])
          : [],
      required: json["required"] ?? false,
      orderNo: json["order_no"],
      logicJson: json["logic_json"],
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
    );
  }
}
