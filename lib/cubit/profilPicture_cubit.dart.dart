import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refriend/services/group_service.dart';
import 'package:refriend/services/user_service.dart';

//cubit for getting the Profil Picutre or the Group Picture
class ProfilPicture extends Cubit<String> {
  //services to get the pictures
  final _dataServiceGroup = GroupService();
  final _dataServiceUser = UserService();

  ProfilPicture(this.groupCode) : super("");

  //the groupcode to get the right picture
  final String groupCode;

  //get the Group Picture
  void getGroupPicture() async =>
      emit(await _dataServiceGroup.getGroupPicture("$groupCode"));

  //get the Profil Picture
  void getProfilPicture() async =>
      emit(await _dataServiceUser.getProfilPictureWithLink());

  @override
  void onChange(Change<String> change) {
    super.onChange(change);
  }
}
