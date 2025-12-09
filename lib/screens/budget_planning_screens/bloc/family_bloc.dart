import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mserp/networkSupport/base/ApiResult.dart';
import 'package:mserp/networkSupport/base/GlobalApiResponseState.dart';
import 'package:mserp/screens/budget_planning_screens/family_repository/family_repository.dart';
import 'package:mserp/screens/budget_planning_screens/model/FamilyDashboardResponse.dart';
import 'package:mserp/supports/AppException.dart';

part 'family_event.dart';
part 'family_state.dart';

class FamilyBloc extends Bloc<FamilyEvent, GlobalApiResponseState> {
  final FamilyRepository familyRepository;
  FamilyBloc({required this.familyRepository}) : super(const InitialState()) {
    on<GetFamilyDashboard>(getFamilyDashboard);
  }
  getFamilyDashboard(FamilyEvent event, Emitter<GlobalApiResponseState> emitter) async{
    if(event is GetFamilyDashboard){
      emitter(const ApiLoadingState());
      final body = {
        "user_id" : event.userId,
      };
      try{
        ApiResult<FamilyDashboardResponse> apiResult = await familyRepository.login(body);
        apiResult.when(
          success: (FamilyDashboardResponse familyDashboardResponse) async {
            emitter(FamilyDashboardStateSuccess(data: familyDashboardResponse));
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
