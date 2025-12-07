import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mserp/customeDesigns/custom_toolbar.dart';
import 'package:mserp/networkSupport/base/GlobalApiResponseState.dart';
import 'package:mserp/screens/survey_screens/bloc/survey_bloc.dart';
import 'package:mserp/screens/survey_screens/model/ResponseDetailsModel.dart';
import 'package:mserp/screens/survey_screens/model/SurveyResponseList.dart';
import 'package:mserp/screens/survey_screens/survey_repo/survey_repository.dart';
import 'package:mserp/screens/survey_screens/update_survey_screen.dart';
import 'package:mserp/themes/app_cololors.dart';
import 'package:mserp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class ResponseDetailsScreen extends StatelessWidget {
  final SurveyResponseItem surveyResponseItem;

  const ResponseDetailsScreen({super.key, required this.surveyResponseItem});

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
        child: ResponseDetailsView(surveyResponseItem: surveyResponseItem),
      ),
    );
  }
}

class ResponseDetailsView extends StatefulWidget {
  final SurveyResponseItem surveyResponseItem;

  const ResponseDetailsView({super.key, required this.surveyResponseItem});

  @override
  State<ResponseDetailsView> createState() => _ResponseDetailsViewState();
}

class _ResponseDetailsViewState extends State<ResponseDetailsView> {
  @override
  void initState() {
    super.initState();
    context.read<SurveyBloc>().add(
      FetchResponseDetails(userId: widget.surveyResponseItem.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.primaryDarkColor
          : AppColors.colorWhite,
      appBar: const CustomToolbar(title: "Response Details"),
      body: BlocBuilder<SurveyBloc, GlobalApiResponseState>(
        builder: (context, state) {
          if (state.status == GlobalApiStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == GlobalApiStatus.completed) {
            return detailsView(state.data.data, isDark);
          } else if (state.status == GlobalApiStatus.error) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget detailsView(ResponseData responseData, bool isDark) {
    final userName = responseData.user?.name;
    final title = (userName == null || userName.isEmpty)
        ? "User: Guest"
        : "User: $userName";

    final submittedAt = responseData.submittedAt;
    final isEditable = submittedAt != null
        ? DateTime.now().difference(submittedAt).inDays < 1
        : false;

    return SingleChildScrollView(
      reverse: false,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Submission Info",
              style: TextStyle(
                color: isDark
                    ? AppColors.colorWhite
                    : Theme.of(context).primaryColor,
              ),
              textScaler: const TextScaler.linear(1.3),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 1,
                  color: isDark
                      ? AppColors.colorWhite
                      : Theme.of(context).primaryColor,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10, left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.colorWhite
                            : AppColors.colorBlack,
                      ),
                      textScaler: const TextScaler.linear(1.1),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "IP Address: ${responseData.ipAddress}",
                      style: TextStyle(
                        color: isDark
                            ? AppColors.colorWhite
                            : AppColors.colorBlack,
                      ),
                      textScaler: const TextScaler.linear(1.1),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Submitted At: ${responseData.submittedAt.toString().split(' ')[0]}",
                      style: TextStyle(
                        color: isDark
                            ? AppColors.colorWhite
                            : AppColors.colorBlack,
                      ),
                      textScaler: const TextScaler.linear(1.1),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Answers",
                  style: TextStyle(
                    color: isDark
                        ? AppColors.colorWhite
                        : Theme.of(context).primaryColor,
                  ),
                  textScaler: const TextScaler.linear(1.3),
                ),
                isEditable
                    ? InkWell(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateSurveyScreen(responseDetails: responseData),
                      ),
                    );
                    if (result == true) {
                      context.read<SurveyBloc>().add(
                        FetchResponseDetails(userId: widget.surveyResponseItem.id),
                      );
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isDark
                          ? AppColors.darkPrimaryLightColor
                          : Theme.of(context).primaryColor,
                    ),
                    child: const Center(
                      child: Text("Edit", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                )
                    : Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey, // Disabled color
                  ),
                  child: const Center(
                    child: Text(
                      "Expired",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )

              ],
            ),
            const SizedBox(height: 10),
            // Dynamic answers list
            ...responseData.answers!.map((answer) {
              return _buildAnswerCard(answer, isDark);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerCard(Answer answer, bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: isDark ? AppColors.colorWhite : Theme.of(context).primaryColor,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Label
            Text(
              "${answer.question!.label}",
              style: TextStyle(
                color: isDark ? AppColors.colorWhite : AppColors.colorBlack,
                fontWeight: FontWeight.bold,
              ),
              textScaler: const TextScaler.linear(1.1),
            ),
            const SizedBox(height: 8),
            // Answer based on type
            _buildAnswerContent(answer, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerContent(Answer answer, bool isDark) {
    final type = answer.question!.type;
    final answerText = answer.answerText;

    // Handle empty answers
    if (answerText == null || answerText.isEmpty) {
      return Text(
        "No answer provided",
        style: TextStyle(
          color: isDark ? AppColors.colorWhite.withOpacity(0.6) : Colors.grey,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    switch (type) {
      case 'text':
      case 'textarea':
      case 'email':
      case 'phone':
      case 'country':
        return Text(
          answerText,
          style: TextStyle(
            color: isDark ? AppColors.colorWhite : AppColors.colorBlack,
          ),
        );

      case 'radio':
      case 'dropdown':
        return Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Theme.of(context).primaryColor,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              answerText,
              style: TextStyle(
                color: isDark ? AppColors.colorWhite : AppColors.colorBlack,
              ),
            ),
          ],
        );

      case 'checkbox':
        // Parse JSON array for checkbox answers
        try {
          final List<dynamic> selectedOptions = jsonDecode(answerText);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: selectedOptions.map((option) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_box,
                      color: Theme.of(context).primaryColor,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      option.toString(),
                      style: TextStyle(
                        color: isDark
                            ? AppColors.colorWhite
                            : AppColors.colorBlack,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        } catch (e) {
          return Text(
            answerText,
            style: TextStyle(
              color: isDark ? AppColors.colorWhite : AppColors.colorBlack,
            ),
          );
        }

      case 'rating':
        final rating = int.tryParse(answerText) ?? 0;
        return Row(
          children: List.generate(5, (index) {
            return Icon(
              index < rating ? Icons.star : Icons.star_border,
              color: Colors.amber,
              size: 24,
            );
          }),
        );

      case 'date':
        return Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: Theme.of(context).primaryColor,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              answerText,
              style: TextStyle(
                color: isDark ? AppColors.colorWhite : AppColors.colorBlack,
              ),
            ),
          ],
        );

      case 'file':
      case 'attachment':
        return InkWell(
          onTap: () {
            // Handle file download/view
            if (answer.fileUrlGenerated != null) {
              // Open URL in browser or download
              // You can use url_launcher package
            }
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.attach_file,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    answer.fileName ?? answerText,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.colorWhite
                          : AppColors.colorBlack,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.download,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ],
            ),
          ),
        );

      case 'image':
        if (answer.fileUrlGenerated != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              answer.fileUrlGenerated!,
              fit: BoxFit.contain,
              height: 100,
              width: 100,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 50),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
            ),
          );
        }
        return Text(
          "No image uploaded",
          style: TextStyle(
            color: isDark ? AppColors.colorWhite.withOpacity(0.6) : Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        );

      case 'label':
        // Labels are typically just text displays, not answers
        return const SizedBox.shrink();

      default:
        return Text(
          answerText,
          style: TextStyle(
            color: isDark ? AppColors.colorWhite : AppColors.colorBlack,
          ),
        );
    }
  }
}
