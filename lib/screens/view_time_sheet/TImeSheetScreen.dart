import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mserp/networkSupport/ErrorHandler.dart';
import 'package:mserp/networkSupport/base/GlobalApiResponseState.dart';
import 'package:mserp/screens/view_time_sheet/bloc/time_sheet_bloc.dart';
import 'package:mserp/screens/view_time_sheet/model/AttendenceResponse.dart';
import 'package:mserp/screens/view_time_sheet/repository/Reposittory.dart';
import 'package:mserp/supports/LoadingDialog.dart';
import 'package:mserp/themes/app_cololors.dart';
import 'package:mserp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class TimeSheetScreen extends StatelessWidget {
  const TimeSheetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<Repository>(create: (context) => Repository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TimeSheetBloc(repository: Repository()),
          ),
        ],
        child: const TimeSheetView(),
      ),
    );
  }
}

class TimeSheetView extends StatefulWidget {
  const TimeSheetView({super.key});

  @override
  State<TimeSheetView> createState() => _TimeSheetScreenState();
}

class _TimeSheetScreenState extends State<TimeSheetView> {
  @override
  void initState() {
    super.initState();
    context.read<TimeSheetBloc>().add(AttendanceEvent());
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkPrimaryLightColor
          : AppColors.colorWhite,
      appBar: AppBar(
        title: Text(
          "Attendance",
          style: TextStyle(
            color: isDark ? AppColors.colorWhite : AppColors.colorWhite,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.colorWhite),
        backgroundColor: isDark
            ? AppColors.darkPrimaryColor
            : Theme.of(context).primaryColor,
      ),
      body: BlocBuilder<TimeSheetBloc, GlobalApiResponseState>(
        builder: (context, state) {
          if (state.status == GlobalApiStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == GlobalApiStatus.completed &&
              state is AttendanceStateSuccess) {
            final AttendenceResponse attendenceResponse = state.data;
            return attendanceView(attendenceResponse, isDark);
           }
          else if (state.status == GlobalApiStatus.error) {
            return Center(child: Text(state.message ?? "Something went wrong"));
          }
          return const Center(child: Text("No data available"));
        },
      ),
    );
  }

  Widget attendanceView(AttendenceResponse data, isDark) {
    return SingleChildScrollView(
      reverse: false,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDark ? AppColors.colorWhite : AppColors.primaryColor,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(padding: const EdgeInsets.all(10),
                child: Table(
                  columnWidths: const {
                    0: IntrinsicColumnWidth(), // label column
                    1: FixedColumnWidth(10),   // small gap
                    2: FlexColumnWidth(),      // value column
                  },
                  children: [
                    _buildRow("Employee Name", "${data.data!.employeeName}", isDark),
                    _buildRow("Check In Time", "${data.data!.checkinTime}", isDark),
                    _buildRow("Check Out Time", "${data.data!.checkoutTime}", isDark),
                    _buildRow("Total Work Hours", "${data.data!.totalWorkHours}", isDark),
                    _buildRow("Shift", "${data.data!.shift}", isDark),
                    _buildRow("Attendance Status", "${data.data!.attendanceStatus}", isDark,
                        valueColor: Colors.green),
                  ],
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
  TableRow _buildRow(String label, String value, bool isDark, {Color? valueColor}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            label,
            style: TextStyle(
              color: isDark ? AppColors.colorWhite : AppColors.colorBlack,
            ),
            textScaler: const TextScaler.linear(1),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            ":",
            style: TextStyle(
              color: isDark ? AppColors.colorWhite : AppColors.colorBlack,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            value,
            style: TextStyle(
              color: valueColor ?? (isDark ? AppColors.colorWhite : AppColors.colorBlack),
            ),
            textScaler: const TextScaler.linear(1),
          ),
        ),
      ],
    );
  }

}
