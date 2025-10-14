import 'package:splitt/features/group/data/models/group_model.dart';

abstract class GroupsRepository {
  Future<List<GroupModel>> getAllGroups();
}
