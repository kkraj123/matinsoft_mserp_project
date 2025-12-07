import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mserp/customeDesigns/custom_buttom.dart';
import 'package:mserp/customeDesigns/custom_snackbar.dart';
import 'package:mserp/customeDesigns/custom_toolbar.dart';
import 'package:mserp/customeDesigns/form_text_field.dart';
import 'package:mserp/networkSupport/ErrorHandler.dart';
import 'package:mserp/networkSupport/base/GlobalApiResponseState.dart';
import 'package:mserp/screens/time_leave_request/bloc/time_leave_bloc.dart';
import 'package:mserp/screens/time_leave_request/time_repo/time_repo.dart';
import 'package:mserp/supports/LoadingDialog.dart';
import 'package:mserp/themes/app_cololors.dart';
import 'package:mserp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class TimeLeaveRequestScreen extends StatelessWidget {
  const TimeLeaveRequestScreen({super.key});

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
        child: const TimeLeaveView(),
      ),
    );
  }
}

class TimeLeaveView extends StatefulWidget {
  const TimeLeaveView({super.key});

  @override
  State<TimeLeaveView> createState() => _TimeLeaveViewState();
}

class _TimeLeaveViewState extends State<TimeLeaveView> {
  final timeLeaveForm = GlobalKey<FormState>();
  DateTime? requestDate;
  TimeOfDay? leaveFromDate;
  TimeOfDay? leaveToDate;
  final TextEditingController reasonController = TextEditingController();

  Future<void> pickDate(
    BuildContext context,
    Function(DateTime) onSelected,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      onSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkPrimaryColor
          : AppColors.colorWhite,
      appBar: const CustomToolbar(title: "Time Leave Request"),
      body: BlocListener<TimeLeaveBloc, GlobalApiResponseState>(
        listener: (context, state) {
          switch (state.status) {
            case GlobalApiStatus.loading:
              LoadingDialog.show(
                context,
                key: const ObjectKey("Leave Type Loading......"),
              );
              break;
            case GlobalApiStatus.completed:
              LoadingDialog.hide(context);
              if (state is TimeLeaveStateSuccess) {
                FocusScope.of(context).unfocus();
                showCustomSnackBar(
                  context,
                  backgroundColor: Colors.green,
                  message: "Your time leave request successfully added",
                  icon: Icons.check,
                );
                Future.delayed(const Duration(seconds: 2), () {
                  Navigator.of(context).pop(true);
                });
              }
              break;
            case GlobalApiStatus.error:
              LoadingDialog.hide(context);
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
        child: SingleChildScrollView(
          reverse: false,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: timeLeaveForm,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        pickDate(context, (date) {
                          setState(() => requestDate = date);
                        });
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            width: 1,
                            color: isDark
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                requestDate == null
                                    ? "Select Leave Request Date"
                                    : requestDate!.toString().split(" ")[0],
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.colorBlack,
                                ),
                                textScaler: const TextScaler.linear(1.1),
                              ),
                              Icon(
                                Icons.calendar_month,
                                size: 25,
                                color: isDark
                                    ? AppColors.colorWhite
                                    : Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          setState(() {
                            leaveFromDate = pickedTime;
                          });
                        }
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            width: 1,
                            color: isDark
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                leaveFromDate == null
                                    ? "Select Leave Time From"
                                    : formatTimeOfDay(leaveFromDate!),
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.colorBlack,
                                ),
                                textScaler: const TextScaler.linear(1.1),
                              ),
                              Icon(
                                Icons.watch_later,
                                size: 25,
                                color: isDark
                                    ? AppColors.colorWhite
                                    : Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          setState(() {
                            leaveToDate = pickedTime;
                          });
                        }
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            width: 1,
                            color: isDark
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                leaveToDate == null
                                    ? "Select Leave Time To"
                                    : formatTimeOfDay(leaveToDate!),
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.colorBlack,
                                ),
                                textScaler: const TextScaler.linear(1.1),
                              ),
                              Icon(
                                Icons.watch_later,
                                size: 25,
                                color: isDark
                                    ? AppColors.colorWhite
                                    : Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FormTextField(
                      hintText: "Enter Reason",
                      controller: reasonController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter reason";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();

                        if (!timeLeaveForm.currentState!.validate()) {
                          return;
                        }

                        if (requestDate == null ||
                            leaveFromDate == null ||
                            leaveToDate == null) {
                          showCustomSnackBar(
                            context,
                            message: "Please select all Time",
                            icon: Icons.warning,
                          );
                          return;
                        }

                        context.read<TimeLeaveBloc>().add(
                          TimeLeaveRequest(
                            issueDate: requestDate!.toString().split(" ")[0],
                            startTime: formatTimeOfDay(leaveFromDate!),
                            endTime: formatTimeOfDay(leaveToDate!),
                            reason: reasonController.text.trim(),
                          ),
                        );
                      },
                      child: const CustomButton(btnText: "Time Leave Request"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return DateFormat('HH:mm').format(dt); // 02:30
  }
}
