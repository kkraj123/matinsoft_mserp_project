import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mserp/networkSupport/base/ApiResult.dart';
import 'package:mserp/networkSupport/base/GlobalApiResponseState.dart';
import 'package:mserp/screens/view_time_sheet/model/AttendenceResponse.dart';
import 'package:mserp/screens/view_time_sheet/repository/Reposittory.dart';
import 'package:mserp/supports/AppException.dart';

part 'time_sheet_event.dart';
part 'time_sheet_state.dart';

class TimeSheetBloc extends Bloc<TimeSheetEvent, GlobalApiResponseState> {
  final Repository repository;
  TimeSheetBloc({required this.repository}) : super(const InitialState()) {
    on<AttendanceEvent>(attendanceItem);
  }

  attendanceItem(TimeSheetEvent event,  Emitter<GlobalApiResponseState> emitter) async{
    if(event is AttendanceEvent){
      emitter(const ApiLoadingState());
      try{
        ApiResult<AttendenceResponse> apiResult = await repository.getAttendance();
        apiResult.when(
          success: (AttendenceResponse attendenceResponse) async {
            emitter(AttendanceStateSuccess(data: attendenceResponse));
          },
          failure: (AppException ex) async {
            emitter(ApiErrorState(exception: ex));
          },
        );
      }on AppException catch(e){
        emitter(ApiErrorState(exception: e));
      }
    }
  }
}
