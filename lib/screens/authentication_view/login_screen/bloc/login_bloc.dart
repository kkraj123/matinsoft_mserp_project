import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mserp/networkSupport/base/ApiResult.dart';
import 'package:mserp/networkSupport/base/GlobalApiResponseState.dart';
import 'package:mserp/screens/authentication_view/login_screen/model/LoginAuthModel.dart';
import 'package:mserp/screens/authentication_view/login_screen/repo/login_repo.dart';
import 'package:mserp/supports/AppException.dart';
import 'package:mserp/supports/share_preference_manager.dart' show SharedPreferenceManager;

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, GlobalApiResponseState> {
  final LoginRepository repository;
  LoginBloc({required this.repository}) : super(const InitialState()) {
    on<PostLogin>(doLogin);
  }

  doLogin(LoginEvent event, Emitter<GlobalApiResponseState> emitter) async{
    if(event is PostLogin){
      emitter(const ApiLoadingState());
      final body = {
        "email" : event.email,
        "password" : event.password
      };
      try{
        ApiResult<LoginAuthModel> apiResult = await repository.login(body);
        apiResult.when(
          success: (LoginAuthModel adminAuth) async {
            SharedPreferenceManager.setOAuth(adminAuth);
            SharedPreferenceManager.setFirstCallOnboarding(true);
            emitter(LoginSuccessStates(data: adminAuth));
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
