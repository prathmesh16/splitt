import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:splitt/features/core/models/ui_state.dart';
import 'package:splitt/features/group/presentation/models/group_member.dart';
import 'package:splitt/features/users/domain/repository/users_repository.dart';
import 'package:splitt/features/users/domain/repository/users_repository_impl.dart';
import 'package:splitt/features/users/presentation/models/user.dart';

class GetMembersBloc extends Cubit<UIState<List<GroupMember>>> {
  final UsersRepository _usersRepository;

  GetMembersBloc({
    UsersRepository? usersRepository,
  })  : _usersRepository = usersRepository ?? UsersRepositoryImpl(),
        super(const Idle());

  Future getMembers() async {
    emit(const Loading());
    try {
      final users = <GroupMember>[];
      final apiUsers = await _usersRepository.getAllUsers();
      users.addAll(
        apiUsers.map(
          (user) => GroupMember.fromUser(
            User.fromUserModel(user),
          ),
        ),
      );
      try {
        if (await FlutterContacts.requestPermission()) {
          final phoneContacts =
              await FlutterContacts.getContacts(withProperties: true);
          users.addAll(phoneContacts.map((contact) {
            final phone = contact.phones.isNotEmpty
                ? contact.phones.first.number
                : 'No phone';

            return GroupMember(
              id: phone + contact.displayName,
              name: contact.displayName,
              mobile: phone,
              isPhoneContact: true,
            );
          }));
        }
      } catch (_) {}
      emit(Success(users));
    } catch (e) {
      emit(Failure(e as Error));
    }
  }
}
