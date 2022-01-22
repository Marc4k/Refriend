import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refriend/models/groupEvents.dart';
import 'package:refriend/services/group_service.dart';

class GroupEventCubit extends Cubit<List<GroupEvent>> {
  final _dataService = GroupService();

  GroupEventCubit(this.groupCode) : super([]);

  final String groupCode;

  void getEvents() async => emit(await _dataService.getGroupEvent(groupCode));

  @override
  void onChange(Change<List<GroupEvent>> change) {
    super.onChange(change);
  }
}
