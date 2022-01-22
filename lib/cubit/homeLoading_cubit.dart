import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refriend/services/user_service.dart';

class HomeLoading extends Cubit<String> {
  HomeLoading() : super("null");

  UserService _userService = UserService();

  void getDataComplete() async {
    String user = await _userService.logedInUserInfo(1);
    if (user != null) {
      emit(user);
    } else {
      emit("null");
    }
  }

  @override
  void onChange(Change<String> change) {
    super.onChange(change);
  }
}
