import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splitt/features/core/models/ui_state.dart';
import 'package:splitt/features/group/presentation/bloc/create_group_bloc.dart';
import 'package:splitt/features/group/presentation/models/group.dart';
import 'package:splitt/features/group/presentation/models/group_type.dart';
import 'package:splitt/theme/theme_extension.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  GroupType? selectedGroupType;
  final nameController = TextEditingController();
  final group = Group(
    id: "",
    name: "",
    description: "",
    users: [],
  );
  final createGroupBloc = CreateGroupBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
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
                  Text(
                    "Create a group",
                    style: context.f.body1.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  _DoneButton(
                    createGroupBloc: createGroupBloc,
                    onTap: () {
                      if (nameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(milliseconds: 500),
                            content: Text("Please enter group name"),
                          ),
                        );
                      } else {
                        createGroupBloc.createGroup(group);
                      }
                    },
                    onSuccess: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(milliseconds: 500),
                          content: Text("Coming soon"),
                        ),
                      );
                    },
                    child: DottedBorder(
                      strokeCap: StrokeCap.round,
                      color: context.c.inactiveColor,
                      strokeWidth: 1,
                      dashPattern: const [6, 3],
                      padding: EdgeInsets.zero,
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(8),
                      child: Container(
                        height: 54,
                        width: 54,
                        decoration: BoxDecoration(
                          color: context.c.hintColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.add_a_photo_outlined,
                          color: context.c.secondaryTextColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Group name",
                        labelStyle: context.f.body1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        hintText: selectedGroupType?.hintText,
                        hintStyle: context.f.body2.copyWith(
                          color: context.c.hintColor,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.only(bottom: 4),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: context.c.primaryColor,
                            width: 1,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: context.c.inactiveColor,
                            width: 1,
                          ),
                        ),
                      ),
                      cursorColor: context.c.primaryColor,
                      onChanged: (String? value) {
                        group.name = value ?? "";
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "Type",
                style: context.f.body3.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: GroupType.values
                    .map(
                      (groupType) => Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedGroupType = groupType;
                              group.description = groupType.displayName;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: selectedGroupType == groupType
                                    ? context.c.primaryColor.withOpacity(0.2)
                                    : null,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: selectedGroupType == groupType
                                        ? context.c.primaryColor
                                        : context.c.inactiveColor,
                                    width: 1.5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  children: [
                                    Icon(
                                      groupType.icon,
                                      size: 32,
                                      color: selectedGroupType == groupType
                                          ? context.c.primaryColor
                                          : context.c.primaryTextColor,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      groupType.displayName,
                                      style: context.f.body2.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: selectedGroupType == groupType
                                            ? context.c.primaryColor
                                            : context.c.primaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoneButton extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onSuccess;
  final CreateGroupBloc createGroupBloc;

  const _DoneButton({
    required this.onTap,
    required this.onSuccess,
    required this.createGroupBloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: createGroupBloc,
      listener: (_, UIState state) {
        if (state is Error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              duration: Duration(milliseconds: 1000),
              content: Text("Something went wrong"),
            ),
          );
        }
        if (state is Success) {
          onSuccess.call();
        }
      },
      builder: (_, UIState state) {
        if (state is Loading) {
          return const SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
            ),
          );
        }
        return InkWell(
          onTap: onTap,
          child: Text(
            "Done",
            style: context.f.body2.copyWith(
              color: context.c.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }
}
