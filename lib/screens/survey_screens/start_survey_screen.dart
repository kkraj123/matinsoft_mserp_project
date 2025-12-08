import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mserp/customeDesigns/custom_snackbar.dart';
import 'package:mserp/customeDesigns/custom_toolbar.dart';
import 'package:mserp/networkSupport/ErrorHandler.dart';
import 'package:mserp/networkSupport/base/GlobalApiResponseState.dart';
import 'package:mserp/screens/survey_screens/bloc/survey_bloc.dart';
import 'package:mserp/screens/survey_screens/model/SurveyListResponse.dart';
import 'package:mserp/screens/survey_screens/model/SurveyResponseList.dart';
import 'package:mserp/screens/survey_screens/survey_repo/survey_repository.dart';
import 'package:mserp/supports/LoadingDialog.dart';
import 'package:mserp/themes/app_cololors.dart';
import 'package:mserp/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:country_picker/country_picker.dart';

/// ================= Start Survey Screen =================

class StartSurveyScreen extends StatelessWidget {
  final Survey surveyObj;

  const StartSurveyScreen({
    super.key,
    required this.surveyObj,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SurveyRepository>(
          create: (context) => SurveyRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                SurveyBloc(surveyRepository: SurveyRepository()),
          ),
        ],
        child: StartSurveyView(
          surveyObj: surveyObj,
        ),
      ),
    );
  }
}

/// ================= Start Survey View =================

class StartSurveyView extends StatefulWidget {
  final Survey surveyObj;
  final SurveyResponseItem? existingResponse;
  final bool isEditMode;
  const StartSurveyView({
    super.key,
    required this.surveyObj,
    this.existingResponse,
    this.isEditMode = false,
  });

  @override
  State<StartSurveyView> createState() => _StartSurveyViewState();
}

class _StartSurveyViewState extends State<StartSurveyView> {
  final Map<dynamic, dynamic> answers = {}; // store answers by question id
  final Map<int, String> filePaths = {};

  List<Map<String, dynamic>> _formatAnswersForApi() {
    return answers.entries
        .where((entry) {
      return !filePaths.containsKey(entry.key);
    })
        .map((entry) {
      return {'question_id': entry.key, 'answer': entry.value};
    })
        .toList();
  }

  bool _shouldShowQuestion(Question question) {
    if (question.logicJson == null) {
      return true;
    }

    try {
      final logic = question.logicJson as Map<String, dynamic>;

      // Get the trigger question ID
      final triggerQuestionId =
      int.tryParse(logic['trigger_question_id'].toString());
      if (triggerQuestionId == null) {
        return true;
      }

      final triggerAnswer = answers[triggerQuestionId] ??
          filePaths[triggerQuestionId];

      if (triggerAnswer == null) {
        return false;
      }

      final operator = logic['operator']?.toString().toLowerCase() ?? 'equal';
      final expectedValue = logic['value'];

      // Apply logic based on operator
      switch (operator) {
        case 'equal':
        case '==':
        case 'equals':
          return _compareValues(triggerAnswer, expectedValue, isEqual: true);

        case 'not_equal':
        case '!=':
        case 'not_equals':
          return _compareValues(triggerAnswer, expectedValue, isEqual: false);

        case 'contains':
          if (triggerAnswer is List) {
            return triggerAnswer.contains(expectedValue);
          }
          return triggerAnswer
              .toString()
              .toLowerCase()
              .contains(expectedValue.toString().toLowerCase());

        case 'greater_than':
        case '>':
          final num1 = num.tryParse(triggerAnswer.toString());
          final num2 = num.tryParse(expectedValue.toString());
          if (num1 != null && num2 != null) {
            return num1 > num2;
          }
          return false;

        case 'less_than':
        case '<':
          final num1 = num.tryParse(triggerAnswer.toString());
          final num2 = num.tryParse(expectedValue.toString());
          if (num1 != null && num2 != null) {
            return num1 < num2;
          }
          return false;

        default:
          return true; // Unknown operator, show by default
      }
    } catch (e) {
      print('Error evaluating logic for question ${question.questionId}: $e');
      return true;
    }
  }

  bool _compareValues(dynamic answer, dynamic expected,
      {required bool isEqual}) {
    if (answer is List) {
      final result = answer.contains(expected);
      return isEqual ? result : !result;
    }

    if (answer is num || expected is num) {
      final ans = num.tryParse(answer.toString());
      final exp = num.tryParse(expected.toString());
      if (ans != null && exp != null) {
        final result = ans == exp;
        return isEqual ? result : !result;
      }
    }

    final answerStr = answer.toString().trim().toLowerCase();
    final expectedStr = expected.toString().trim().toLowerCase();
    final result = answerStr == expectedStr;

    return isEqual ? result : !result;
  }

  bool _validateVisibleQuestions() {
    for (var question in widget.surveyObj.questions) {
      if (!_shouldShowQuestion(question)) continue;

      if (question.required) {
        final answer = answers[question.questionId] ??
            filePaths[question.questionId];

        if (answer == null ||
            (answer is String && answer.isEmpty) ||
            (answer is List && answer.isEmpty)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please answer: ${question.label}'),
              backgroundColor: Colors.red,
            ),
          );
          return false;
        }
      }
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkPrimaryColor
          : AppColors.colorWhite,
      appBar: const CustomToolbar(title: "Start Survey"),
      body: BlocListener<SurveyBloc, GlobalApiResponseState>(
        listener: (context, state) {
          switch (state.status) {
            case GlobalApiStatus.loading:
              LoadingDialog.show(
                context,
                key: const ObjectKey("Response loading....."),
              );
              break;
            case GlobalApiStatus.completed:
              LoadingDialog.hide(context);
              if (state is SurveyAnswerStateSuccess) {
                showCustomSnackBar(
                  context,
                  backgroundColor: Colors.green,
                  message: state.data.message,
                  icon: Icons.check,
                );
                Navigator.of(context).pop();
              }
              break;
            case GlobalApiStatus.error:
              LoadingDialog.hide(context);
              ErrorHandler.errorHandle(
                state.message,
                "Something Wrong",
                context,
              );
            default:
              LoadingDialog.hide(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: widget.surveyObj.questions.length + 1,
            itemBuilder: (context, index) {
              // Submit button at the end
              if (index == widget.surveyObj.questions.length) {
                return InkWell(
                  onTap: () {
                    if (!_validateVisibleQuestions()) {
                      return;
                    }

                    final formattedAnswers = _formatAnswersForApi();
                    if (formattedAnswers.isEmpty && filePaths.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please answer at least one question'),
                        ),
                      );
                      return;
                    }

                    context.read<SurveyBloc>().add(
                      PostSurveyResponse(
                        surveyId: widget.surveyObj.surveyId,
                        answerBody: formattedAnswers,
                        filePaths: filePaths.isNotEmpty ? filePaths : null,
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkPrimaryLightColor
                          : Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "Submit Survey",
                        style: TextStyle(color: AppColors.colorWhite),
                      ),
                    ),
                  ),
                );
              }

              final question = widget.surveyObj.questions[index];

              if (!_shouldShowQuestion(question)) {
                return const SizedBox.shrink(); // Hide question
              }

              return SurveyQuestionWidget(
                question: question,
                currentAnswer: answers[question.questionId] ??
                    filePaths[question.questionId],
                onChanged: (value) {
                  setState(() {
                    // Separate file and regular answers
                    if (question.type == 'file' || question.type == 'image') {
                      filePaths[question.questionId] = value;
                      answers.remove(question.questionId);
                    } else {
                      answers[question.questionId] = value;
                    }
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

/// ================= Survey Question Widget =================
/// ================= Survey Question Widget =================

class SurveyQuestionWidget extends StatelessWidget {
  final Question question;
  final dynamic currentAnswer;
  final Function(dynamic) onChanged;

  const SurveyQuestionWidget({
    super.key,
    required this.question,
    required this.currentAnswer,
    required this.onChanged,
  });

  // Helper method to build question label with required indicator
  Widget _buildQuestionLabel(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 16,
          color: themeProvider.isDarkMode ? Colors.white : Colors.black,
        ),
        children: [
          TextSpan(text: question.label),
          if (question.required)
            const TextSpan(
              text: ' *',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (question.type) {
      case "text":
      case "email":
      case "phone":
        return _buildTextField(context);

      case "textarea":
        return _buildTextArea(context);

      case "radio":
        return _buildRadioGroup(context);

      case "checkbox":
        return _buildCheckboxGroup(context);

      case "dropdown":
        return _buildDropdown(context);

      case "date":
        return _buildDatePicker(context);

      case "rating":
        return _buildRating(context);

      case "file":
      case "image":
        return _buildFilePicker(context);

      case "country":
        return _buildCountryPicker(context);

      case "label":
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            question.label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        );

      default:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text("Unknown question type: ${question.type}"),
        );
    }
  }

  /// ---------------- Text Field ----------------
  Widget _buildTextField(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final borderColor = themeProvider.isDarkMode
        ? AppColors.colorWhite
        : Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionLabel(context),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: currentAnswer?.toString() ?? '',
          keyboardType: question.type == "phone"
              ? TextInputType.phone
              : question.type == "email"
              ? TextInputType.emailAddress
              : TextInputType.text,
          onChanged: onChanged,
          style: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
          ),
          decoration: InputDecoration(
            hintText: "Enter your answer",
            hintStyle: TextStyle(
              color: themeProvider.isDarkMode ? Colors.white54 : Colors.grey,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: themeProvider.isDarkMode
                    ? Colors.amber
                    : AppColors.primaryColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  /// ---------------- Text Area ----------------
  Widget _buildTextArea(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final borderColor = themeProvider.isDarkMode
        ? AppColors.colorWhite
        : Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionLabel(context),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: currentAnswer?.toString() ?? '',
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: "Enter your answer",
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: themeProvider.isDarkMode
                    ? Colors.amber
                    : AppColors.primaryColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
          ),
          style: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  /// ---------------- Radio Group ----------------
  Widget _buildRadioGroup(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final borderColor = themeProvider.isDarkMode
        ? AppColors.colorWhite
        : Theme.of(context).primaryColor;
    final options = question.optionsJson;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionLabel(context),
        ...options.map((opt) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 1, color: borderColor),
              ),
              child: RadioListTile(
                title: Text(opt),
                value: opt,
                groupValue: currentAnswer,
                onChanged: onChanged,
              ),
            ),
          );
        }).toList(),
        const SizedBox(height: 20),
      ],
    );
  }

  /// ---------------- Checkbox Group ----------------
  Widget _buildCheckboxGroup(BuildContext context) {
    final options = question.optionsJson;
    List<dynamic> selected = currentAnswer ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionLabel(context),
        ...options.map((opt) {
          return CheckboxListTile(
            title: Text(opt),
            value: selected.contains(opt),
            onChanged: (checked) {
              if (checked == true) {
                selected.add(opt);
              } else {
                selected.remove(opt);
              }
              onChanged(List.from(selected));
            },
          );
        }).toList(),
        const SizedBox(height: 20),
      ],
    );
  }

  /// ---------------- Dropdown ----------------
  Widget _buildDropdown(BuildContext context) {
    final options = question.optionsJson;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionLabel(context),
        const SizedBox(height: 10),
        DropdownButtonFormField(
          value: currentAnswer,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark
                    ? AppColors.colorWhite
                    : Theme.of(context).primaryColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark
                    ? AppColors.colorWhite
                    : Theme.of(context).primaryColor,
              ),
            ),
          ),
          hint: const Text("Select"),
          items: options
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  /// ---------------- Date Picker ----------------
  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionLabel(context),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              firstDate: DateTime(1950),
              lastDate: DateTime(2100),
              initialDate: DateTime.now(),
            );
            if (picked != null) onChanged(picked.toString().split(' ')[0]);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(currentAnswer ?? "Select Date"),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  /// ---------------- Rating ----------------
  Widget _buildRating(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final borderColor = themeProvider.isDarkMode
        ? AppColors.colorWhite
        : Theme.of(context).primaryColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildQuestionLabel(context),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 1, color: borderColor),
          ),
          child: Row(
            children: List.generate(5, (i) {
              final rating = i + 1;
              return IconButton(
                onPressed: () => onChanged(rating),
                icon: Icon(
                  Icons.star,
                  color: rating <= (currentAnswer ?? 0)
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  /// ---------------- File / Image Picker ----------------
  Widget _buildFilePicker(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final borderColor = themeProvider.isDarkMode
        ? AppColors.colorWhite
        : Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionLabel(context),
        const SizedBox(height: 10),
        InkWell(
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: question.type == "image" ? FileType.image : FileType.any,
            );

            if (result != null && result.files.isNotEmpty) {
              final filePath = result.files.first.path!;
              onChanged(filePath);
              print("Selected File: $filePath");
            }
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: borderColor),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Icon(Icons.upload_file, color: borderColor, size: 30),
                  const SizedBox(width: 10),
                  Container(
                    height: 30,
                    width: 1.5,
                    decoration: BoxDecoration(
                      color: AppColors.colorGray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      currentAnswer == null
                          ? "Upload File"
                          : currentAnswer.toString().split('/').last,
                      style: TextStyle(
                        color: borderColor,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  /// ---------------- Country Picker ----------------
  Widget _buildCountryPicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionLabel(context),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () {
            showCountryPicker(
              context: context,
              onSelect: (value) {
                onChanged(value.name);
              },
            );
          },
          child: Text(currentAnswer ?? "Select Country"),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

/*
class SurveyQuestionWidget extends StatelessWidget {
  final Question question;
  final dynamic currentAnswer;
  final Function(dynamic) onChanged;

  const SurveyQuestionWidget({
    super.key,
    required this.question,
    required this.currentAnswer,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    switch (question.type) {
      case "text":
      case "email":
      case "phone":
        return _buildTextField(context);

      case "textarea":
        return _buildTextArea(context);

      case "radio":
        return _buildRadioGroup(context);

      case "checkbox":
        return _buildCheckboxGroup();

      case "dropdown":
        return _buildDropdown(context);

      case "date":
        return _buildDatePicker(context);

      case "rating":
        return _buildRating(context);

      case "file":
      case "image":
        return _buildFilePicker(context);

      case "country":
        return _buildCountryPicker(context);

      case "label":
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            question.label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        );

      default:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text("Unknown question type: ${question.type}"),
        );
    }
  }

  /// ---------------- Text Field ----------------
  Widget _buildTextField(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final borderColor = themeProvider.isDarkMode
        ? AppColors.colorWhite
        : Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.label,
          style: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: currentAnswer?.toString() ?? '',
          keyboardType: question.type == "phone"
              ? TextInputType.phone
              : question.type == "email"
              ? TextInputType.emailAddress
              : TextInputType.text,
          onChanged: onChanged,
          style: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
          ),
          decoration: InputDecoration(
            hintText: "Enter your answer",
            hintStyle: TextStyle(
              color: themeProvider.isDarkMode ? Colors.white54 : Colors.grey,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: themeProvider.isDarkMode
                    ? Colors.amber
                    : AppColors.primaryColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  /// ---------------- Text Area ----------------
  Widget _buildTextArea(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final borderColor = themeProvider.isDarkMode
        ? AppColors.colorWhite
        : Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question.label),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: currentAnswer?.toString() ?? '',
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: "Enter your answer",
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: themeProvider.isDarkMode
                    ? Colors.amber
                    : AppColors.primaryColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
          ),
          style: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  /// ---------------- Radio Group ----------------
  Widget _buildRadioGroup(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final borderColor = themeProvider.isDarkMode
        ? AppColors.colorWhite
        : Theme.of(context).primaryColor;
    final options = question.optionsJson;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question.label),
        ...options.map((opt) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 1, color: borderColor),
              ),
              child: RadioListTile(
                title: Text(opt),
                value: opt,
                groupValue: currentAnswer,
                onChanged: onChanged,
              ),
            ),
          );
        }).toList(),
        const SizedBox(height: 20),
      ],
    );
  }

  /// ---------------- Checkbox Group ----------------
  Widget _buildCheckboxGroup() {
    final options = question.optionsJson;
    List<dynamic> selected = currentAnswer ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question.label),
        ...options.map((opt) {
          return CheckboxListTile(
            title: Text(opt),
            value: selected.contains(opt),
            onChanged: (checked) {
              if (checked == true) {
                selected.add(opt);
              } else {
                selected.remove(opt);
              }
              onChanged(List.from(selected));
            },
          );
        }).toList(),
        const SizedBox(height: 20),
      ],
    );
  }

  /// ---------------- Dropdown ----------------
  Widget _buildDropdown(BuildContext context) {
    final options = question.optionsJson;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question.label),
        const SizedBox(height: 10),
        DropdownButtonFormField(
          value: currentAnswer,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark
                    ? AppColors.colorWhite
                    : Theme.of(context).primaryColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark
                    ? AppColors.colorWhite
                    : Theme.of(context).primaryColor,
              ),
            ),
          ),
          hint: const Text("Select"),
          items: options
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  /// ---------------- Date Picker ----------------
  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question.label),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              firstDate: DateTime(1950),
              lastDate: DateTime(2100),
              initialDate: DateTime.now(),
            );
            if (picked != null) onChanged(picked.toString().split(' ')[0]);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(currentAnswer ?? "Select Date"),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  /// ---------------- Rating ----------------
  Widget _buildRating(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final borderColor = themeProvider.isDarkMode
        ? AppColors.colorWhite
        : Theme.of(context).primaryColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(question.label),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 1, color: borderColor),
          ),
          child: Row(
            children: List.generate(5, (i) {
              final rating = i + 1;
              return IconButton(
                onPressed: () => onChanged(rating),
                icon: Icon(
                  Icons.star,
                  color: rating <= (currentAnswer ?? 0)
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  /// ---------------- File / Image Picker ----------------
  Widget _buildFilePicker(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final borderColor = themeProvider.isDarkMode
        ? AppColors.colorWhite
        : Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question.label),
        const SizedBox(height: 10),
        InkWell(
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: question.type == "image" ? FileType.image : FileType.any,
            );

            if (result != null && result.files.isNotEmpty) {
              final filePath = result.files.first.path!;
              onChanged(filePath);
              print("Selected File: $filePath");
            }
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: borderColor),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Icon(Icons.upload_file, color: borderColor, size: 30),
                  const SizedBox(width: 10),
                  Container(
                    height: 30,
                    width: 1.5,
                    decoration: BoxDecoration(
                      color: AppColors.colorGray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      currentAnswer == null
                          ? "Upload File"
                          : currentAnswer.toString().split('/').last,
                      style: TextStyle(
                        color: borderColor,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  /// ---------------- Country Picker ----------------
  Widget _buildCountryPicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question.label),
        OutlinedButton(
          onPressed: () {
            showCountryPicker(
              context: context,
              onSelect: (value) {
                onChanged(value.name);
              },
            );
          },
          child: Text(currentAnswer ?? "Select Country"),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}*/
