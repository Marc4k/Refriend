import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refriend/services/user_service.dart';

class GetUserName extends Cubit<String> {
  GetUserName() : super("");

  UserService _userService = UserService();

  void getUserName() async => emit(await _userService.logedInUserInfo());

  @override
  void onChange(Change<String> change) {
    super.onChange(change);
  }
}
