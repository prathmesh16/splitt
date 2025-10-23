import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:splitt/common/button.dart';
import 'package:splitt/common/custom_divider.dart';
import 'package:splitt/common/page_transitions.dart';
import 'package:splitt/features/core/models/ui_state.dart';
import 'package:splitt/features/group/presentation/bloc/get_members_bloc.dart';
import 'package:splitt/features/group/presentation/models/group.dart';
import 'package:splitt/features/group/presentation/models/group_member.dart';
import 'package:splitt/features/group/presentation/models/selected_members.dart';
import 'package:splitt/features/group/presentation/views/add_group_members_review_screen.dart';
import 'package:splitt/theme/theme_extension.dart';

class AddGroupMembersScreen extends StatefulWidget {
  final Group group;

  const AddGroupMembersScreen({
    super.key,
    required this.group,
  });

  @override
  State<AddGroupMembersScreen> createState() => _AddGroupMembersScreenState();
}

class _AddGroupMembersScreenState extends State<AddGroupMembersScreen> {
  final getMembersBloc = GetMembersBloc();
  late final SelectedMembers selectedMembers;

  @override
  void initState() {
    super.initState();
    getMembersBloc.getMembers();
    selectedMembers = SelectedMembers(
      alreadyMembers: widget.group.users,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: context.f.body2.copyWith(
                        color: context.c.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 32),
                    child: Text(
                      "Add group members",
                      style: context.f.body1.copyWith(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox.shrink(),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (_) => selectedMembers,
                    ),
                  ],
                  child: _MemberSelection(
                    addMembersBloc: getMembersBloc,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Button(
                label: "Next",
                onTap: () {
                  if (selectedMembers.length == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(milliseconds: 1000),
                        content: Text("Please select atleast one user"),
                      ),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    slideFromRight(
                      ChangeNotifierProvider.value(
                        value: selectedMembers,
                        child: const AddGroupMembersReviewScreen(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberSelection extends StatefulWidget {
  final GetMembersBloc addMembersBloc;

  const _MemberSelection({
    super.key,
    required this.addMembersBloc,
  });

  @override
  State<_MemberSelection> createState() => _MemberSelectionState();
}

class _MemberSelectionState extends State<_MemberSelection> {
  final ScrollController _horizontalScrollController = ScrollController();

  void onTap(SelectedMembers selectedMembers, GroupMember member) {
    if (!selectedMembers.isUserSelected(member)) {
      selectedMembers.addUser(member);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_horizontalScrollController.hasClients) {
          _horizontalScrollController.animateTo(
            _horizontalScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } else {
      selectedMembers.removeUser(member);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: widget.addMembersBloc,
      builder: (_, UIState state) {
        if (state is Loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is Success<List<GroupMember>>) {
          final members = state.data;
          return Consumer<SelectedMembers>(
            builder: (_, selectedMembers, __) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (selectedMembers.length > 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _Label(
                          label: "People to add",
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: SizedBox(
                            height: 80,
                            child: ListView.builder(
                              controller: _horizontalScrollController,
                              itemCount: selectedMembers.usersList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (_, index) {
                                final member = selectedMembers.usersList[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      selectedMembers.removeUser(member);
                                    },
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 24,
                                                child: Text(
                                                    member.name.isNotEmpty
                                                        ? member.name[0]
                                                        : '?'),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                member.name,
                                                style: context.f.body3.copyWith(
                                                  color: context
                                                      .c.secondaryTextColor,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: 5,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: context.c.inactiveColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: context.c.white,
                                                width: 2,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.close,
                                              color: context.c.white,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: CustomDivider(),
                        ),
                      ],
                    ),
                  ListView.builder(
                    itemCount: members.length,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      final member = members[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0)
                            const _Label(
                              label: "Friends on Splitwise",
                            )
                          else if (members[index].isPhoneContact !=
                              members[index - 1].isPhoneContact)
                            const _Label(
                              label: "Friends on Splitwise",
                            ),
                          ListTile(
                            onTap: !selectedMembers.isUserAlreadyMember(member)
                                ? () => onTap(selectedMembers, member)
                                : null,
                            leading: CircleAvatar(
                              child: Text(
                                member.name.isNotEmpty ? member.name[0] : '?',
                              ),
                            ),
                            title: Text(member.name),
                            subtitle:
                                selectedMembers.isUserAlreadyMember(member)
                                    ? Text(
                                        "Already in groip",
                                        style: context.f.body3.copyWith(
                                          color: context.c.secondaryTextColor,
                                        ),
                                      )
                                    : member.isPhoneContact
                                        ? Text(member.mobile ?? "")
                                        : null,
                            trailing: Checkbox(
                              value: selectedMembers.isUserSelected(member) ||
                                  selectedMembers.isUserAlreadyMember(member),
                              shape: const CircleBorder(),
                              onChanged:
                                  !selectedMembers.isUserAlreadyMember(member)
                                      ? (bool? isSelected) {
                                          onTap(selectedMembers, member);
                                        }
                                      : null,
                              fillColor: WidgetStateProperty.fromMap(
                                <WidgetStatesConstraint, Color?>{
                                  WidgetState.selected: !selectedMembers
                                          .isUserAlreadyMember(member)
                                      ? context.c.darkPrimary
                                      : context.c.inactiveColor,
                                },
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(left: 16),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _Label extends StatelessWidget {
  final String label;

  const _Label({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        bottom: 8,
      ),
      child: Text(
        label,
        style: context.f.body3.copyWith(
          fontWeight: FontWeight.w600,
          color: context.c.secondaryTextColor,
          fontSize: 10,
          letterSpacing: 0.75,
        ),
      ),
    );
  }
}
