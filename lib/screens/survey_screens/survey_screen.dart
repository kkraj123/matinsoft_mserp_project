import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mserp/customeDesigns/custom_toolbar.dart';
import 'package:mserp/customeDesigns/no_data_found_screen.dart';
import 'package:mserp/networkSupport/ErrorHandler.dart';
import 'package:mserp/networkSupport/base/GlobalApiResponseState.dart';
import 'package:mserp/screens/survey_screens/bloc/survey_bloc.dart';
import 'package:mserp/screens/survey_screens/model/SurveyListResponse.dart';
import 'package:mserp/screens/survey_screens/start_survey_screen.dart';
import 'package:mserp/screens/survey_screens/survey_repo/survey_repository.dart';
import 'package:mserp/screens/survey_screens/survey_response_screen.dart';
import 'package:mserp/supports/LoadingDialog.dart';
import 'package:mserp/themes/app_cololors.dart';
import 'package:mserp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class SurveyScreen extends StatelessWidget {
  const SurveyScreen({super.key});

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
        child: const SurveyListView(),
      ),
    );
  }
}

class SurveyListView extends StatefulWidget {
  const SurveyListView({super.key});

  @override
  State<SurveyListView> createState() => _SurveyListViewState();
}

class _SurveyListViewState extends State<SurveyListView> {
  List<Survey> surveyList = [];
  int currentPage = 1;
  int totalPages = 1;
  int totalItems = 0;
  bool isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<SurveyBloc>().add(GetSurveyList(pageCount: currentPage));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!isLoadingMore && currentPage < totalPages) {
        _loadMoreSurveys();
      }
    }
  }

  void _loadMoreSurveys() {
    setState(() {
      isLoadingMore = true;
      currentPage++;
    });
    context.read<SurveyBloc>().add(GetSurveyList(pageCount: currentPage));
  }

  void _refreshSurveys() {
    setState(() {
      surveyList.clear();
      currentPage = 1;
    });
    context.read<SurveyBloc>().add(GetSurveyList(pageCount: currentPage));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkPrimaryColor
          : AppColors.colorWhite,
      appBar: const CustomToolbar(title: "Survey Management"),
      body: BlocListener<SurveyBloc, GlobalApiResponseState>(
        listener: (context, state) {
          switch (state.status) {
            case GlobalApiStatus.loading:
              if (!isLoadingMore) {
                LoadingDialog.show(
                  context,
                  key: const ObjectKey("Survey list"),
                );
              }
              break;
            case GlobalApiStatus.completed:
              LoadingDialog.hide(context);
              if (state is SurveyListStateSuccess) {
                setState(() {
                  if (isLoadingMore) {
                    surveyList.addAll(state.data.data.surveys);
                    isLoadingMore = false;
                  } else {
                    surveyList = state.data.data.surveys;
                  }
                  totalPages = state.data.data.lastPage;
                  totalItems = state.data.data.total;
                  print("Survey list count: ${surveyList.length}");
                });
              }
              break;
            case GlobalApiStatus.error:
              LoadingDialog.hide(context);
              setState(() {
                isLoadingMore = false;
              });
              ErrorHandler.errorHandle(
                state.message,
                "Something Wrong",
                context,
              );
              break;
            default:
              LoadingDialog.hide(context);
          }
        },
        child: surveyList.isEmpty
            ? const SizedBox.shrink()
            : RefreshIndicator(
                onRefresh: () async {
                  _refreshSurveys();
                },
                child: Column(
                  children: [
                    // Survey List
                    Expanded(
                      child: surveyList.isEmpty
                          ? Center(
                              child: Center(
                                child: NoDataFoundScreen(
                                  isDark: isDark,
                                  emptyText:
                                      "Create your first survey to get started",
                                ),
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(16),
                              itemCount:
                                  surveyList.length + (isLoadingMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == surveyList.length) {
                                  return _buildLoadingMoreIndicator();
                                }
                                return _buildSurveyCard(
                                  surveyList[index],
                                  isDark,
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }

  Widget _buildSurveyCard(Survey survey, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkPrimaryLightColor : AppColors.colorWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset:const Offset(0, 4),
              spreadRadius: 1,
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            print("Survey tapped: ${survey.title}");
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        survey.title,
                        textScaler:const TextScaler.linear(1.2),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.colorWhite
                              : AppColors.colorBlack,
                        ),
                      ),
                    ),
                    // _buildStatusChip(survey.status, isDark),
                  ],
                ),

                // Description
                if (survey.description != null &&
                    survey.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    survey.description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.colorGray
                          : AppColors.colorBlack.withAlpha(120),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                const SizedBox(height: 12),

                // Info Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.help_outline,
                      size: 16,
                      color: isDark
                          ? AppColors.colorGray
                          : AppColors.colorBlack.withAlpha(120),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${survey.questions.length} Questions',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.colorGray
                            : AppColors.colorBlack.withAlpha(120),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (survey.isPrivate)
                      Icon(
                        Icons.lock_outline,
                        size: 16,
                        color: isDark ? AppColors.colorGray : AppColors.colorGray,
                      ),

                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StartSurveyScreen(surveyObj: survey),
                          ),
                        );
                      },
                      child: Container(
                        width: 110,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color : isDark
                              ? AppColors.colorWhite
                              : Theme.of(context).primaryColor.withOpacity(0.8), width: 1)
                        ),
                        child: Center(
                          child: Text(
                            "Start Survey",
                            style: TextStyle(color: isDark ? Colors.white : Theme.of(context).primaryColor),
                            textScaler:const TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SurveyResponseScreen(surveyObj: survey),
                          ),
                        );
                      },
                      child: Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: isDark
                              ? AppColors.colorWhite
                              : Theme.of(context).primaryColor,width: 1)
                        ),
                        child: Center(
                          child: Text(
                            "Response",
                            style: TextStyle(color: isDark ? Colors.white : Theme.of(context).primaryColor),
                            textScaler:const TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, bool isDark) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'published':
        backgroundColor = Colors.green.withOpacity(0.2);
        textColor = Colors.green;
        break;
      case 'draft':
        backgroundColor = Colors.orange.withOpacity(0.2);
        textColor = Colors.orange;
        break;
      case 'closed':
        backgroundColor = Colors.red.withOpacity(0.2);
        textColor = Colors.red;
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.2);
        textColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  String _formatDateRange(String? startDate, String? endDate) {
    if (startDate == null && endDate == null) return 'No date set';

    String formatDate(String? date) {
      if (date == null) return '';
      try {
        final dt = DateTime.parse(date);
        return '${dt.day}/${dt.month}/${dt.year}';
      } catch (e) {
        return date;
      }
    }

    if (startDate != null && endDate != null) {
      return '${formatDate(startDate)} - ${formatDate(endDate)}';
    } else if (startDate != null) {
      return 'From ${formatDate(startDate)}';
    } else {
      return 'Until ${formatDate(endDate)}';
    }
  }
}
