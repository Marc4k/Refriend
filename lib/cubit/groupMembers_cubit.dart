import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refriend/models/groupMembers.dart';
import 'package:refriend/services/group_service.dart';

class GroupMembersCubit extends Cubit<List<GroupMembers>> {
  final _dataService = GroupService();

  GroupMembersCubit(this.groupCode) : super([]);
  final groupCode;
  void getMembersData() async =>
      emit(await _dataService.getGroupsMembersData(groupCode));

  @override
  void onChange(Change<List<GroupMembers>> change) {
    super.onChange(change);
  }
}
