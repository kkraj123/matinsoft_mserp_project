import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mserp/customeDesigns/custom_buttom.dart';
import 'package:mserp/customeDesigns/custom_snackbar.dart';
import 'package:mserp/customeDesigns/custom_toolbar.dart';
import 'package:mserp/customeDesigns/custome_text_field.dart';
import 'package:mserp/customeDesigns/form_text_field.dart';
import 'package:mserp/networkSupport/ErrorHandler.dart';
import 'package:mserp/networkSupport/base/GlobalApiResponseState.dart';
import 'package:mserp/screens/leave_request_screen/bloc/leave_request_bloc.dart';
import 'package:mserp/screens/leave_request_screen/leave_repository/leave_repository.dart';
import 'package:mserp/screens/leave_request_screen/model/LeaveTypeResponse.dart';
import 'package:mserp/supports/LoadingDialog.dart';
import 'package:mserp/themes/app_cololors.dart';
import 'package:mserp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class LeaveRequestScreen extends StatelessWidget {
  const LeaveRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<LeaveRepository>(
          create: (context) => LeaveRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                LeaveRequestBloc(leaveRepository: LeaveRepository()),
          ),
        ],
        child: const LeaveRequestView(),
      ),
    );
  }
}

class LeaveRequestView extends StatefulWidget {
  const LeaveRequestView({super.key});

  @override
  State<LeaveRequestView> createState() => _LeaveRequestViewState();
}

class _LeaveRequestViewState extends State<LeaveRequestView> {
  LeaveTypeResponse? liveTypeObject;
  final leaveFormKey = GlobalKey<FormState>();
  final TextEditingController noOfLeaveController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  DateTime? requestDate;
  DateTime? leaveFromDate;
  DateTime? leaveToDate;
  int? selectedLeaveTypeValue;

  @override
  void initState() {
    super.initState();
    context.read<LeaveRequestBloc>().add(GetLeaveType());
  }

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
      appBar: const CustomToolbar(title: "Leave Request"),
      body: BlocListener<LeaveRequestBloc, GlobalApiResponseState>(
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
              if (state is LeaveTypeStateSuccess) {
                setState(() {
                  liveTypeObject = state.data;
                });
                print("leaveType: ${liveTypeObject!.list.length}");
              }
              else if(state is LeaveRequestStateSuccess){
                FocusScope.of(context).unfocus();
                showCustomSnackBar(
                  context,
                  backgroundColor: Colors.green,
                  message: "Your leave request successfully added",
                  icon: Icons.check
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
              key: leaveFormKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FormTextField(
                      hintText: "Enter no. of leave day",
                      controller: noOfLeaveController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your no. of leave";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<int>(
                        isExpanded: true,

                        hint: Text(
                          'Select Leave Type',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),

                        items: (liveTypeObject?.list ?? [])
                            .map(
                              (leave) => DropdownMenuItem<int>(
                                value: leave.id,
                                child: Text(
                                  leave.name,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            )
                            .toList(),

                        value: selectedLeaveTypeValue,

                        onChanged: (value) {
                          setState(() {
                            selectedLeaveTypeValue = value;
                          });
                        },

                        buttonStyleData: ButtonStyleData(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        ),
                        menuItemStyleData: const MenuItemStyleData(height: 50),
                      ),
                    ),
                  ),
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
                      onTap: () {
                        pickDate(context, (date) {
                          setState(() => leaveFromDate = date);
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
                                leaveFromDate == null
                                    ? "Select Leave From"
                                    : leaveFromDate!.toString().split(" ")[0],
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
                      onTap: () {
                        pickDate(context, (date) {
                          setState(() => leaveToDate = date);
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
                                leaveToDate == null
                                    ? "Select Leave To"
                                    : leaveToDate!.toString().split(" ")[0],
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
                        if (leaveFormKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          if (selectedLeaveTypeValue == null) {
                            showCustomSnackBar(
                              context,
                              message: "Please select leave type",
                              icon: Icons.warning,
                            );
                            return;
                          }
                        } else if (requestDate == null ||
                            leaveFromDate == null ||
                            leaveToDate == null) {
                          showCustomSnackBar(
                            context,
                            message: "Please select all dates",
                            icon: Icons.warning,
                          );
                          return;
                        }
                        context.read<LeaveRequestBloc>().add(
                          LeaveRequest(
                            noOfDays: noOfLeaveController.text.trim(),
                            leaveTypeId: selectedLeaveTypeValue,
                            requestDate: requestDate!.toString().split(" ")[0],
                            fromDate: leaveFromDate!.toString().split(" ")[0],
                            toDate: leaveToDate!.toString().split(" ")[0],
                            leaveReason: reasonController.text.trim(),
                          ),
                        );
                      },
                      child: const CustomButton(btnText: "Leave Request"),
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
}
