import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splitt/common/custom_divider.dart';
import 'package:splitt/features/group/presentation/bloc/groups_bloc.dart';
import 'package:splitt/features/group/presentation/models/group.dart';
import 'package:splitt/features/core/models/ui_state.dart';
import 'package:splitt/features/group/presentation/views/group_details.dart';

class GroupsListScreen extends StatefulWidget {
  const GroupsListScreen({super.key});

  @override
  State<GroupsListScreen> createState() => _GroupsListScreenState();
}

class _GroupsListScreenState extends State<GroupsListScreen> {
  late final GroupsBloc groupsBloc;

  @override
  void initState() {
    super.initState();
    groupsBloc = GroupsBloc();
    groupsBloc.getAllGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => groupsBloc,
        child: BlocBuilder(
          bloc: groupsBloc,
          builder: (_, UIState state) {
            if (state is Success) {
              return _GroupsList(groups: state.data);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class _GroupsList extends StatelessWidget {
  final List<Group> groups;

  const _GroupsList({
    super.key,
    required this.groups,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.separated(
        itemCount: groups.length,
        itemBuilder: (_, index) {
          return _GroupTile(
            group: groups[index],
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

class _GroupTile extends StatelessWidget {
  final Group group;

  const _GroupTile({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GroupDetails(
              group: group,
            ),
          ),
        );
      },
      child: Padding(
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
              group.name,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
