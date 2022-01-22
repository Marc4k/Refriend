import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refriend/models/group.dart';
import 'package:refriend/services/group_service.dart';

class GroupDataCubit extends Cubit<List<Group>> {
  final _dataService = GroupService();

  GroupDataCubit() : super([]);

  void getYourGroups() async => emit(await _dataService.getyourGroupsData());

  @override
  void onChange(Change<List<Group>> change) {
    super.onChange(change);
  }
}
