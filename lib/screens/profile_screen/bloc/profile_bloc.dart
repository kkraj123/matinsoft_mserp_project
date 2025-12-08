import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mserp/networkSupport/base/ApiResult.dart';
import 'package:mserp/networkSupport/base/GlobalApiResponseState.dart';
import 'package:mserp/screens/profile_screen/model/ProfileResponse.dart';
import 'package:mserp/screens/profile_screen/profile_repo/profile_repository.dart';
import 'package:mserp/screens/seetings_screen/model/LogoutResponse.dart';
import 'package:mserp/supports/AppException.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, GlobalApiResponseState> {
  final ProfileRepository profileRepository;
  ProfileBloc({required this.profileRepository}) : super(const InitialState()) {
    on<GetProfile>(getProfile);
    on<Logout>(logout);
  }
  getProfile(ProfileEvent event, Emitter<GlobalApiResponseState> emit) async{
    if(event is GetProfile){
      emit(const ApiLoadingState());

      try {
        ApiResult<ProfileResponse> surveyListResponse = await profileRepository.getProfile();
        surveyListResponse.when(
          success: (ProfileResponse profileResponse) async {
            emit(ProfileStateSuccess(data: profileResponse));
          },
          failure: (AppException ex) async {
            emit(ApiErrorState(exception: ex));
          },
        );
      } on AppException catch (e) {
        emit(ApiErrorState(exception: e));
      }
    }
  }
  logout(ProfileEvent event, Emitter<GlobalApiResponseState> emit) async{
    if(event is Logout){
      emit(const ApiLoadingState());

      try {
        ApiResult<LogoutResponse> logoutResponse = await profileRepository.logout();
        logoutResponse.when(
          success: (LogoutResponse logout) async {
            emit(LogoutStateSuccess(data: logout));
          },
          failure: (AppException ex) async {
            emit(ApiErrorState(exception: ex));
          },
        );
      } on AppException catch (e) {
        emit(ApiErrorState(exception: e));
      }
    }
  }
}
