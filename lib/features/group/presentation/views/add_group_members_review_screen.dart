import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitt/common/button.dart';
import 'package:splitt/features/group/presentation/models/selected_members.dart';
import 'package:splitt/theme/theme_extension.dart';

class AddGroupMembersReviewScreen extends StatelessWidget {
  const AddGroupMembersReviewScreen({super.key});

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
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: context.c.primaryTextColor,
                      size: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 32),
                    child: Text(
                      "Review",
                      style: context.f.body1.copyWith(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox.shrink(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<SelectedMembers>(
                builder: (_, selectedMembers, __) {
                  return ListView.builder(
                    itemCount: selectedMembers.usersList.length,
                    itemBuilder: (_, index) {
                      final member = selectedMembers.usersList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: CircleAvatar(
                                    radius: 24,
                                    child: Text(
                                      member.name.isNotEmpty
                                          ? member.name[0]
                                          : '?',
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 5,
                                  child: GestureDetector(
                                    onTap: () {
                                      selectedMembers.removeUser(member);
                                      if (selectedMembers.length == 0) {
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: context.c.inactiveColor,
                                        borderRadius: BorderRadius.circular(12),
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
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  member.name,
                                  style: context.f.body1,
                                ),
                                Text(
                                  member.isPhoneContact
                                      ? member.mobile ?? ""
                                      : member.email ?? "",
                                  style: context.f.body2.copyWith(
                                    color: context.c.secondaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    duration:
                                        const Duration(milliseconds: 1000),
                                    content: Text(member.isPhoneContact
                                        ? "Coming soon"
                                        : "Can't edit existing friend"),
                                  ),
                                );
                              },
                              child: Text(
                                "Edit",
                                style: context.f.body2.copyWith(
                                  color: member.isPhoneContact
                                      ? context.c.darkPrimary
                                      : context.c.inactiveColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Button(
                onTap: () {},
                label: "Add members",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
