import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mserp/networkSupport/base/ApiResult.dart';
import 'package:mserp/networkSupport/base/GlobalApiResponseState.dart';
import 'package:mserp/screens/home_screen/home_repository/home_repository.dart';
import 'package:mserp/screens/home_screen/model/CategoryItemsResponse.dart';
import 'package:mserp/screens/home_screen/model/CheckInCheckOutModel.dart';
import 'package:mserp/supports/AppException.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, GlobalApiResponseState> {
  final HomeRepository homeRepository;

  HomeBloc({required this.homeRepository}) : super(const InitialState()) {
    on<CheckInCheckOutPost>(checkInCheckOut);
    on<CategoryFetch>(categoryFetch);
  }

  checkInCheckOut(
    HomeEvent event,
    Emitter<GlobalApiResponseState> emitter,
  ) async {
    if (event is CheckInCheckOutPost) {
      emitter(const ApiLoadingState());
      final body = {
        "bssid": event.bssid,
        "code": event.code,
        "type": event.type,
      };
      try {
        ApiResult<CheckInCheckOutModel> apiResult = await homeRepository
            .checkInCheckOutPost(body);
        apiResult.when(
          success: (CheckInCheckOutModel checkInCheckOut) async {
            emitter(CheckInCheckOutSuccessState(data: checkInCheckOut));
          },
          failure: (AppException ex) async {
            emitter(ApiErrorState(exception: ex));
          },
        );
      } on AppException catch (e) {
        emitter(ApiErrorState(exception: e));
      }
    }
  }

  categoryFetch(
    HomeEvent event,
    Emitter<GlobalApiResponseState> emitter,
  ) async {
    if (event is CategoryFetch) {
      emitter(const ApiLoadingState());

      try {
        ApiResult<CategoryItemsResponse> categoryResponse = await homeRepository
            .categoryItems();
        categoryResponse.when(
          success: (CategoryItemsResponse categoryItems) async {
            emitter(CategoryFetchSuccess(data: categoryItems));
          },
          failure: (AppException ex) async {
            emitter(ApiErrorState(exception: ex));
          },
        );
      } on AppException catch (e) {
        emitter(ApiErrorState(exception: e));
      }
    }
  }
}
