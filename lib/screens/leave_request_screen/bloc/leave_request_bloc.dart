import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mserp/networkSupport/base/ApiResult.dart';
import 'package:mserp/networkSupport/base/GlobalApiResponseState.dart';
import 'package:mserp/screens/leave_request_screen/leave_repository/leave_repository.dart';
import 'package:mserp/screens/leave_request_screen/model/LeaveRemoveResponse.dart';
import 'package:mserp/screens/leave_request_screen/model/LeaveRequestResponse.dart';
import 'package:mserp/screens/leave_request_screen/model/LeaveTypeResponse.dart';
import 'package:mserp/screens/leave_request_screen/model/MyLeaveStatusResponse.dart';
import 'package:mserp/supports/AppException.dart';

part 'leave_request_event.dart';
part 'leave_request_state.dart';

class LeaveRequestBloc extends Bloc<LeaveRequestEvent, GlobalApiResponseState> {
  final LeaveRepository leaveRepository;
  LeaveRequestBloc({required this.leaveRepository}) : super(const InitialState()) {
    on<GetLeaveType>(leaveType);
    on<LeaveRequest>(leaveRequest);
    on<GetLeaveStatus>(getLeaveStatus);
    on<RemoveLeaveItem>(removeLeaveItem);
  }

  leaveType(LeaveRequestEvent event, Emitter<GlobalApiResponseState> emitter) async{
    if(event is GetLeaveType){
      emitter(const ApiLoadingState());
      try{
        ApiResult<LeaveTypeResponse> apiResult = await leaveRepository.getLeaveType();
        apiResult.when(
          success: (LeaveTypeResponse leaveResponse) async {
            emitter(LeaveTypeStateSuccess(data: leaveResponse));
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
  leaveRequest(LeaveRequestEvent event, Emitter<GlobalApiResponseState> emitter) async{
    if(event is LeaveRequest){
      emitter(const ApiLoadingState());
      final bodyParams = FormData.fromMap({
        "no_of_days": event.noOfDays,
        "leave_type_id": event.leaveTypeId,
        "leave_requested_date": event.requestDate,
        "leave_from": event.fromDate,
        "leave_to": event.toDate,
        "reasons": event.leaveReason,
      });
      try{
        ApiResult<LeaveRequestResponse> apiResult = await leaveRepository.requestLeave(bodyParams);
        apiResult.when(
          success: (LeaveRequestResponse leaveRequestResponse) async {
            emitter(LeaveRequestStateSuccess(data: leaveRequestResponse));
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
  getLeaveStatus(LeaveRequestEvent event, Emitter<GlobalApiResponseState> emitter) async{
    if(event is GetLeaveStatus){
      emitter(const ApiLoadingState());
      try{
        ApiResult<MyLeaveStatusResponse> apiResult = await leaveRepository.getMyLeaveStatus();
        apiResult.when(
          success: (MyLeaveStatusResponse leaveStatusResponse) async {
            emitter(LeaveRequestStatusStateSuccess(data: leaveStatusResponse));
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
  removeLeaveItem(LeaveRequestEvent event, Emitter<GlobalApiResponseState> emitter) async{
    if(event is RemoveLeaveItem){
      emitter(const ApiLoadingState());
      try{
        ApiResult<LeaveRemoveResponse> apiResult = await leaveRepository.removeLeaveItem(event.leaveId);
        apiResult.when(
          success: (LeaveRemoveResponse removeLeave) async {
            emitter(LeaveRemoveStateSuccess(data: removeLeave));
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
