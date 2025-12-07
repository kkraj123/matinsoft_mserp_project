import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mserp/customeDesigns/custom_toolbar.dart';
import 'package:mserp/networkSupport/base/GlobalApiResponseState.dart';
import 'package:mserp/screens/authentication_view/login_screen/model/LoginAuthModel.dart';
import 'package:mserp/screens/survey_screens/bloc/survey_bloc.dart';
import 'package:mserp/screens/survey_screens/response_details_screen.dart';
import 'package:mserp/screens/survey_screens/start_survey_screen.dart';
import 'package:mserp/screens/survey_screens/survey_repo/survey_repository.dart';
import 'package:mserp/supports/share_preference_manager.dart';
import 'package:mserp/themes/app_cololors.dart';
import 'package:mserp/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'model/SurveyListResponse.dart';
import 'model/SurveyResponseList.dart' hide Survey;

class SurveyResponseScreen extends StatelessWidget {
  final Survey surveyObj;

  const SurveyResponseScreen({super.key, required this.surveyObj});

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
        child: SurveyResponseView(surveyObj: surveyObj),
      ),
    );
  }
}

class SurveyResponseView extends StatefulWidget {
  final Survey surveyObj;

  const SurveyResponseView({super.key, required this.surveyObj});

  @override
  State<SurveyResponseView> createState() => _SurveyResponseViewState();
}

class _SurveyResponseViewState extends State<SurveyResponseView> {
  final ScrollController _scrollController = ScrollController();
  final List<SurveyResponseItem> _responseList = [];
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  LoginAuthModel? oAuth;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<SurveyBloc>().add(
      GetSurveyResponseList(
          surveyId: widget.surveyObj.surveyId, pageCount: 1),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9 &&
        !_isLoadingMore &&
        _hasMoreData) {
      _loadMoreData();
    }
  }

  void _loadMoreData() {
    setState(() {
      _isLoadingMore = true;
    });
    context.read<SurveyBloc>().add(
      GetSurveyResponseList(
          surveyId: widget.surveyObj.surveyId, pageCount: _currentPage + 1),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy hh:mm a').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor:
      isDark ? AppColors.darkPrimaryColor : AppColors.colorWhite,
      appBar: const CustomToolbar(title: "Survey Response Details"),
      body: BlocConsumer<SurveyBloc, GlobalApiResponseState>(
        listener: (context, state) {
          if (state is SurveyResponseListStateSuccess) {
            setState(() {
              if (_currentPage == 1) {
                _responseList.clear();
              }
              if(state.data.data.data != null){
                _responseList.addAll(state.data.data.data);
              }

              /*if (state.data.surveyResponseList.data?.data != null) {
                _responseList.addAll(state.data.surveyResponseList.data!.data!);
              }*/

              _currentPage = state.data.data?.currentPage ?? 1;
              _hasMoreData = _currentPage <
                  (state.data.data?.lastPage ?? 1);
              _isLoadingMore = false;
            });
          } else if (state.status == GlobalApiStatus.error) {
            setState(() {
              _isLoadingMore = false;
            });
          }
        },
        builder: (context, state) {
          if (state.status == GlobalApiStatus.loading && _currentPage == 1) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == GlobalApiStatus.error && _responseList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentPage = 1;
                        _hasMoreData = true;
                      });
                      context.read<SurveyBloc>().add(
                        GetSurveyResponseList(
                            surveyId: widget.surveyObj.surveyId,
                            pageCount: 1),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (_responseList.isEmpty) {
            return Center(
              child: Text(
                'No responses found',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _responseList.length + (_hasMoreData ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _responseList.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final response = _responseList[index];
              final userName = response.user?.name ?? 'Anonymous';
              final submittedDate = _formatDate(response.submittedAt);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkPrimaryLightColor : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => ResponseDetailsScreen(surveyResponseItem: response,)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar
                        CircleAvatar(
                          backgroundColor: isDark
                              ? AppColors.primaryColor.withOpacity(0.3)
                              : AppColors.primaryColor.withOpacity(0.1),
                          child: Text(
                            userName[0].toUpperCase(),
                            style: TextStyle(
                              color: isDark ? Colors.white : AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 14,
                                    color: isDark ? Colors.white60 : Colors.black54,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      submittedDate,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: isDark ? Colors.white60 : Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        /*if(oAuth!.data!.user!.userType!.contains("employee"))
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>  StartSurveyScreen(
                                surveyObj: widget.surveyObj,
                                existingResponse: response,
                                isEditMode: true,
                              )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Icon(Icons.edit, size: 20,color: isDark ? Colors.white : Colors.black,),
                            ),
                          ),*/
                        // Trailing arrow
                        Icon(
                          Icons.chevron_right,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
              );

            },
          );
        },
      ),
    );
  }
}