import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:splitt/common/custom_divider.dart';
import 'package:splitt/common/models/expense.dart';
import 'package:splitt/common/models/user.dart';
import 'package:splitt/common/utils/constants.dart';

class ShareSplit extends StatelessWidget {
  final List<User> users;

  const ShareSplit({
    super.key,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _UserList(
            users: users,
          ),
        ),
        Consumer<Expense>(builder: (_, expense, __) {
          return Container(
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "${expense.totalShares} total shares",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }),
      ],
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

class _UserTile extends StatefulWidget {
  final User user;

  const _UserTile({
    super.key,
    required this.user,
  });

  @override
  State<_UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<_UserTile> {
  final TextEditingController _controller = TextEditingController();
  bool _isTextBold = false;
  String _previousValue = "";

  @override
  void initState() {
    super.initState();
    _controller.text =
        context.read<Expense>().getUserShare(widget.user.id) ?? "";
    _isTextBold = _controller.text.isNotEmpty;
    _previousValue = _controller.text;
    _controller.addListener(() {
      if (_previousValue != _controller.text) {
        setState(() {
          _isTextBold = _controller.text.isNotEmpty;
          _previousValue = _controller.text;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 8,
        top: 4,
        bottom: 4,
      ),
      child: Consumer<Expense>(
        builder: (context, expense, _) {
          return Row(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: _isTextBold ? FontWeight.w500 : null,
                    ),
                  ),
                  Text(
                    "₹${expense.getFormattedUserShareAmount(widget.user.id)}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  width: 52,
                  child: TextField(
                    controller: _controller,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: "0",
                      contentPadding: const EdgeInsets.only(top: 12),
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                      ),
                      isDense: true,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Constants.primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                    cursorColor: Constants.primaryColor,
                    onChanged: (String? value) {
                      expense.setShare(
                          widget.user.id, double.tryParse(value ?? ""));
                    },
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                  left: 4,
                  right: 8,
                ),
                child: Text(
                  "share(s)",
                  style: TextStyle(
                    color: _isTextBold ? Colors.black54 : Colors.black26,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
