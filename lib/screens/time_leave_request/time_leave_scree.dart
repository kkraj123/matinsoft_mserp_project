import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mserp/customeDesigns/custom_snackbar.dart';
import 'package:mserp/customeDesigns/custom_toolbar.dart';
import 'package:mserp/customeDesigns/no_data_found_screen.dart';
import 'package:mserp/networkSupport/ErrorHandler.dart';
import 'package:mserp/networkSupport/base/GlobalApiResponseState.dart';
import 'package:mserp/screens/time_leave_request/bloc/time_leave_bloc.dart';
import 'package:mserp/screens/time_leave_request/model/TimeLeaveResponse.dart';
import 'package:mserp/screens/time_leave_request/time_leave_request_screen.dart';
import 'package:mserp/screens/time_leave_request/time_repo/time_repo.dart';
import 'package:mserp/supports/LoadingDialog.dart';
import 'package:mserp/themes/app_cololors.dart';
import 'package:mserp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class TimeLeaveScree extends StatelessWidget {
  const TimeLeaveScree({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<TimeRepository>(
          create: (context) => TimeRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                TimeLeaveBloc(timeRepository: TimeRepository()),
          ),
        ],
        child: const TimeLeaveListView(),
      ),
    );
  }
}

class TimeLeaveListView extends StatefulWidget {
  const TimeLeaveListView({super.key});

  @override
  State<TimeLeaveListView> createState() => _TimeLeaveListViewState();
}

class _TimeLeaveListViewState extends State<TimeLeaveListView> {
  @override
  void initState() {
    super.initState();
    context.read<TimeLeaveBloc>().add(TimeLeaveFetch());
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkPrimaryColor
          : AppColors.colorWhite,
      appBar: const CustomToolbar(title: "My Time Leave Request"),
      body: Builder(
        builder: (pageContext) {
          return BlocBuilder<TimeLeaveBloc, GlobalApiResponseState>(
            builder: (context, state) {
              if (state.status == GlobalApiStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.status == GlobalApiStatus.completed) {
                if (state is TimeLeaveFetchSuccess) {
                  List<TimeLeaveData> leaveList = state.data.data;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const TimeLeaveRequestScreen(),
                                ),
                              );
                              if (result == true) {
                                context.read<TimeLeaveBloc>().add(
                                  TimeLeaveFetch(),
                                );
                              }
                            },
                            child: Container(
                              height: 50,
                              width: 170,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: isDark
                                    ? AppColors.darkPrimaryLightColor
                                    : Theme.of(context).primaryColor,
                              ),
                              child: const Center(
                                child: Text(
                                  "Leave Time Request",
                                  style: TextStyle(color: AppColors.colorWhite),
                                  textScaler: TextScaler.linear(1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Expanded(
                        child: leaveStatusCardView(
                          leaveList,
                          isDark,
                          pageContext,
                        ),
                      ),
                    ],
                  );
                }
              } else if (state.status == GlobalApiStatus.error) {
                return Center(
                  child: Text(
                    state.message,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.colorWhite
                          : AppColors.colorBlack,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

  Widget leaveStatusCardView(
    List<TimeLeaveData> leaveList,
    bool isDark,
    pageContext,
  ) {
    return leaveList.isEmpty
        ? Center(
            child: NoDataFoundScreen(
              isDark: isDark,
              emptyText: "Your time leave request is empty",
            ),
          )
        : ListView.builder(
            itemCount: leaveList.length,
            itemBuilder: (context, index) {
              final leaveObject = leaveList[index];
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      width: 2,
                      color: isDark
                          ? AppColors.colorWhite
                          : AppColors.colorGray.withAlpha(100),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                getStatusIcon(leaveObject.status, isDark),
                                const SizedBox(width: 5),
                                Text(
                                  "${leaveObject.status}",
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.colorWhite
                                        : AppColors.colorBlack,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textScaler: const TextScaler.linear(1.2),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () =>
                                  showDeleteDialog(pageContext, leaveObject),
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    width: 1.2,
                                    color: Colors.red,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          height: 2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: isDark
                                ? AppColors.darkPrimaryLightColor
                                : AppColors.colorGray.withAlpha(100),
                          ),
                        ),
                        const SizedBox(height: 20),

                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: horizontalTextView(
                            "Time Leave Requested Date",
                            formatDate(leaveObject.issueDate),
                            isDark,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: horizontalTextView(
                            "Start Time",
                            "${leaveObject.startTime}",
                            isDark,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: horizontalTextView(
                            "End Time",
                            "${leaveObject.endTime}",
                            isDark,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: horizontalTextView(
                            "Reason",
                            "${leaveObject.reasons}",
                            isDark,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }

  String formatDate(String? dateStr) {
    if (dateStr == null) return '';
    DateTime date = DateTime.parse(dateStr);
    return DateFormat('dd MMM, yyyy').format(date);
  }

  Icon getStatusIcon(String? status, bool isDark) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return const Icon(
          Icons.hourglass_empty,
          color: Colors.orange,
          size: 25,
        );
      case 'approved':
      case 'completed':
        return const Icon(Icons.check_circle, color: Colors.green, size: 25);
      case 'rejected':
        return const Icon(Icons.cancel, color: Colors.red, size: 25);
      default:
        return Icon(
          Icons.info,
          color: isDark ? Colors.white : Colors.black,
          size: 25,
        );
    }
  }

  Widget horizontalTextView(String txt1, String txt2, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          txt1,
          style: TextStyle(
            color: isDark ? AppColors.colorWhite : AppColors.colorGray,
          ),
          textScaler: const TextScaler.linear(1),
        ),
        Text(
          txt2,
          style: TextStyle(
            color: isDark ? AppColors.colorWhite : AppColors.colorBlack,
          ),
          textScaler: const TextScaler.linear(1),
        ),
      ],
    );
  }

  void showDeleteDialog(BuildContext parentContext, TimeLeaveData leaveObject) {
    showDialog(
      context: parentContext,
      builder: (dialogContext) {
        return BlocListener<TimeLeaveBloc, GlobalApiResponseState>(
          bloc: parentContext.read<TimeLeaveBloc>(),
          listener: (context, state) {
            switch (state.status) {
              case GlobalApiStatus.loading:
                // LoadingDialog.show(dialogContext, key:const ObjectKey("loading........"));
                break;

              case GlobalApiStatus.completed:
                LoadingDialog.hide(dialogContext);
                if (state is TimeLeaveRemoveSuccess) {
                  Navigator.of(dialogContext).pop();
                  showCustomSnackBar(
                    parentContext,
                    backgroundColor: Colors.green,
                    message: state.data.message,
                  );

                  parentContext.read<TimeLeaveBloc>().add(TimeLeaveFetch());
                }
                break;

              case GlobalApiStatus.error:
                LoadingDialog.hide(dialogContext);
                ErrorHandler.errorHandle(
                  state.message,
                  "Something Wrong",
                  parentContext,
                );
                break;
              default:
                LoadingDialog.hide(dialogContext);
            }
          },
          child: AlertDialog(
            title: const Text("Remove Time Leave Request"),
            content: const Text(
              "Are you sure you want to remove this time leave request?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  parentContext.read<TimeLeaveBloc>().add(
                    DeleteTimeLeave(leaveTimeId: leaveObject.id),
                  );
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
