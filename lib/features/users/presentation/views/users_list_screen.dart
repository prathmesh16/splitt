import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:splitt/common/custom_divider.dart';
import 'package:splitt/common/models/expense.dart';
import 'package:splitt/common/models/user.dart';
import 'package:splitt/common/utils/constants.dart';
import 'package:splitt/features/core/models/ui_state.dart';
import 'package:splitt/features/users/presentation/bloc/users_bloc.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  late final UsersBloc usersBloc;

  @override
  void initState() {
    super.initState();
    usersBloc = UsersBloc();
    usersBloc.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => usersBloc,
        child: BlocBuilder(
          bloc: usersBloc,
          builder: (_, UIState state) {
            if (state is Success) {
              return _UserList(users: state.data);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class _UserList extends StatelessWidget {
  final List<User> users;

  const _UserList({
    super.key,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.separated(
        itemCount: users.length,
        itemBuilder: (_, index) {
          return _UserTile(
            user: users[index],
          );
        },
        separatorBuilder: (_, index) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: CustomDivider(),
          );
        },
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final User user;

  const _UserTile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 8,
        top: 4,
        bottom: 4,
      ),
      child: Row(
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Image.network(
              "https://avatar.iran.liara.run/public/boy",
              loadingBuilder: (_, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(18),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
