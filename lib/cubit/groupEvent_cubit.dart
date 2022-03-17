import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refriend/database/database_group.dart';
import 'package:refriend/models/groupEvents.dart';
import 'package:refriend/services/group_service.dart';

class GroupEventCubit extends Cubit<List<GroupEvent>> {
  final _dataService = DatabaseServiceGroup();

  GroupEventCubit(this.groupCode) : super([]);

  final String groupCode;

  void getEvents() async => emit(await _dataService.getGroupEvents(groupCode));

  @override
  void onChange(Change<List<GroupEvent>> change) {
    super.onChange(change);
  }
}
