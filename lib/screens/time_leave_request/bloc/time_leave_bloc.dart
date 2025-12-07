import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mserp/networkSupport/base/ApiResult.dart';
import 'package:mserp/networkSupport/base/GlobalApiResponseState.dart';
import 'package:mserp/screens/leave_request_screen/model/LeaveRemoveResponse.dart';
import 'package:mserp/screens/time_leave_request/model/TimeLeaveRequestResponse.dart';
import 'package:mserp/screens/time_leave_request/model/TimeLeaveResponse.dart';
import 'package:mserp/screens/time_leave_request/time_repo/time_repo.dart';
import 'package:mserp/supports/AppException.dart';

part 'time_leave_event.dart';
part 'time_leave_state.dart';

class TimeLeaveBloc extends Bloc<TimeLeaveEvent, GlobalApiResponseState> {
  final TimeRepository timeRepository;
  TimeLeaveBloc({required this.timeRepository}) : super(const InitialState()) {
    on<TimeLeaveRequest>(timeLeaveRequest);
    on<TimeLeaveFetch>(timeLeaveFetch);
    on<DeleteTimeLeave>(deleteTimeLeave);

  }

  timeLeaveRequest(TimeLeaveEvent event, Emitter<GlobalApiResponseState> emitter) async{
    if(event is TimeLeaveRequest){
      emitter(const ApiLoadingState());
      final bodyParams = FormData.fromMap({
        "issue_date": event.issueDate,
        "start_time": event.startTime,
        "end_time": event.endTime,
        "reasons": event.reason,
      });
      try{
        ApiResult<TimeLeaveRequestResponse> apiResult = await timeRepository.timeLeaveRequest(bodyParams);
        apiResult.when(
          success: (TimeLeaveRequestResponse timeLeaveResponse) async {
            emitter(TimeLeaveStateSuccess(data: timeLeaveResponse));
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
  timeLeaveFetch(TimeLeaveEvent event, Emitter<GlobalApiResponseState> emitter) async{
    if(event is TimeLeaveFetch){
      emitter(const ApiLoadingState());

      try{
        ApiResult<TimeLeaveResponse> apiResult = await timeRepository.timeLeaveFetch();
        apiResult.when(
          success: (TimeLeaveResponse timeLeaveResponse) async {
            emitter(TimeLeaveFetchSuccess(data: timeLeaveResponse));
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
  deleteTimeLeave(TimeLeaveEvent event, Emitter<GlobalApiResponseState> emitter) async{
    if(event is DeleteTimeLeave){
      emitter(const ApiLoadingState());

      try{
        ApiResult<LeaveRemoveResponse> apiResult = await timeRepository.deleteTimeLeave(event.leaveTimeId);
        apiResult.when(
          success: (LeaveRemoveResponse deleteTimeLeaveResponse) async {
            emitter(TimeLeaveRemoveSuccess(data: deleteTimeLeaveResponse));
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
