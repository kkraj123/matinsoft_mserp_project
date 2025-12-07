import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mserp/customeDesigns/custom_snackbar.dart';
import 'package:mserp/customeDesigns/custom_toolbar.dart';
import 'package:mserp/networkSupport/ErrorHandler.dart';
import 'package:mserp/networkSupport/base/GlobalApiResponseState.dart';
import 'package:mserp/screens/survey_screens/bloc/survey_bloc.dart';
import 'package:mserp/screens/survey_screens/model/ResponseDetailsModel.dart';
import 'package:mserp/screens/survey_screens/model/SurveyListResponse.dart';
import 'package:mserp/screens/survey_screens/start_survey_screen.dart';
import 'package:mserp/screens/survey_screens/survey_repo/survey_repository.dart';
import 'package:mserp/supports/LoadingDialog.dart';
import 'package:mserp/themes/app_cololors.dart';
import 'package:mserp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class UpdateSurveyScreen extends StatelessWidget {
  final ResponseData responseDetails;

  const UpdateSurveyScreen({
    super.key,
    required this.responseDetails,
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
        child: UpdateSurveyView(
          responseDetails: responseDetails,
        ),
      ),
    );
  }
}

class UpdateSurveyView extends StatefulWidget {
  final ResponseData responseDetails;

  const UpdateSurveyView({
    super.key,
    required this.responseDetails,
  });

  @override
  State<UpdateSurveyView> createState() => _UpdateSurveyViewState();
}

class _UpdateSurveyViewState extends State<UpdateSurveyView> {
  final Map<dynamic, dynamic> answers = {};
  final Map<int, String> filePaths = {};
  late Survey surveyObj;

  @override
  void initState() {
    super.initState();
    _initializeSurveyData();
    _loadExistingAnswers();
  }

  /// Convert ResponseDetailsModel to Survey object for reuse
  void _initializeSurveyData() {
    final surveyDetail = widget.responseDetails.survey;
    final responseData = widget.responseDetails;

    if (surveyDetail != null && responseData.answers != null) {
      // Convert existing answers to Question objects
      List<Question> questions = responseData.answers!.map((answer) {
        final q = answer.question;
        return Question(
          questionId: q?.id ?? 0,
          surveyId: q?.surveyId ?? 0,
          type: q?.type ?? 'text',
          label: q?.label ?? '',
          optionsJson: q?.optionsJson ?? [],
          required: q?.required ?? false,
          orderNo: q?.orderNo ?? 0,
          logicJson: q?.logicJson,
          createdAt: q?.createdAt.toString() ?? '',
          updatedAt: q?.updatedAt.toString() ?? '',
        );
      }).toList();

      surveyObj = Survey(
        surveyId: surveyDetail.id ?? 0,
        companyId: surveyDetail.companyId ?? 0,
        title: surveyDetail.title ?? '',
        description: surveyDetail.description ?? '',
        slug: surveyDetail.slug ?? '',
        startDate: surveyDetail.startDate.toString() ?? '',
        endDate: surveyDetail.endDate.toString() ?? '',
        settingsJson: surveyDetail.settingsJson,
        status: surveyDetail.status ?? '',
        isPrivate: surveyDetail.isPrivate ?? false,
        privateToken: surveyDetail.privateToken,
        restrictByIp: surveyDetail.restrictByIp ?? false,
        singleSubmission: surveyDetail.singleSubmission ?? false,
        isTemplate: surveyDetail.isTemplate ?? false,
        createdBy: surveyDetail.createdBy ?? 0,
        createdAt: surveyDetail.createdAt.toString() ?? '',
        updatedAt: surveyDetail.updatedAt.toString() ?? '',
        questions: questions, ipRestriction: 0,
      );
    }
  }

  /// Pre-fill answers from existing response
  void _loadExistingAnswers() {
    final existingAnswers = widget.responseDetails.answers;

    if (existingAnswers != null) {
      for (var answer in existingAnswers) {
        final questionId = answer.questionId;
        final questionType = answer.question?.type;

        if (questionId != null) {
          // Handle file/image types
          if (questionType == 'file' || questionType == 'image') {
            if (answer.filePath != null) {
              filePaths[questionId] = answer.filePath!;
            }
          }
          // Handle checkbox (answer_json is array)
          else if (questionType == 'checkbox' && answer.answerJson != null) {
            answers[questionId] = answer.answerJson;
          }
          // Handle rating (answer_text might be numeric string)
          else if (questionType == 'rating' && answer.answerText != null) {
            answers[questionId] = int.tryParse(answer.answerText!) ?? 0;
          }
          // Handle all other types (text, radio, dropdown, etc.)
          else if (answer.answerText != null) {
            answers[questionId] = answer.answerText;
          }
        }
      }
    }

    setState(() {}); // Refresh UI with loaded answers
  }

  List<Map<String, dynamic>> _formatAnswersForApi() {
    return answers.entries
        .where((entry) => !filePaths.containsKey(entry.key))
        .map((entry) {
      return {
        'question_id': entry.key,
        'answer': entry.value,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final responseId = widget.responseDetails.id;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkPrimaryColor
          : AppColors.colorWhite,
      appBar: const CustomToolbar(title: "Update Survey"),
      body: BlocListener<SurveyBloc, GlobalApiResponseState>(
        listener: (context, state) {
          switch (state.status) {
            case GlobalApiStatus.loading:
              LoadingDialog.show(
                context,
                key: const ObjectKey("Updating response..."),
              );
              break;
            case GlobalApiStatus.completed:
              LoadingDialog.hide(context);
              if (state is UpdateResponseDetailSuccess) {
                showCustomSnackBar(
                  context,
                  backgroundColor: Colors.green,
                  message: state.data.message ?? "Survey updated successfully",
                  icon: Icons.check,
                );
                Navigator.of(context).pop(true); // Return true to indicate success
              }
              break;
            case GlobalApiStatus.error:
              LoadingDialog.hide(context);
              ErrorHandler.errorHandle(
                state.message,
                "Update Failed",
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
            itemCount: surveyObj.questions.length + 1,
            itemBuilder: (context, index) {
              // Submit button at the end
              if (index == surveyObj.questions.length) {
                return InkWell(
                  onTap: () {
                    final formattedAnswers = _formatAnswersForApi();

                    if (formattedAnswers.isEmpty && filePaths.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please answer at least one question'),
                        ),
                      );
                      return;
                    }

                    if (responseId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invalid response ID'),
                        ),
                      );
                      return;
                    }

                    // Dispatch update event
                    context.read<SurveyBloc>().add(
                      UpdateSurveyResponse(
                        responseId: responseId,
                        surveyId: surveyObj.surveyId,
                        updateAnswers: formattedAnswers,
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
                        "Update Survey",
                        style: TextStyle(
                          color: AppColors.colorWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }

              // Render each question with existing answer
              final question = surveyObj.questions[index];
              return SurveyQuestionWidget(
                question: question,
                currentAnswer: answers[question.questionId] ??
                    filePaths[question.questionId],
                onChanged: (value) {
                  setState(() {
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