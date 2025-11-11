import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:splitt/common/avatar.dart';
import 'package:splitt/common/currency_amount.dart';
import 'package:splitt/common/custom_divider.dart';
import 'package:splitt/common/models/expense.dart';
import 'package:splitt/features/users/presentation/models/user.dart';
import 'package:splitt/theme/theme_extension.dart';

class AdjustmentSplit extends StatelessWidget {
  final List<User> users;

  const AdjustmentSplit({
    super.key,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    return _UserList(
      users: users,
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
        context.read<Expense>().getUserAdjustment(widget.user.id) ?? "";
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
              Avatar(
                seed: widget.user.name,
                size: 36,
                borderRadius: BorderRadius.circular(18),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.name,
                    style: context.f.body1.copyWith(
                      fontWeight: _isTextBold ? FontWeight.w600 : null,
                    ),
                  ),
                  CurrencyAmount(
                    amount: expense.getFormattedUserAdjustmentTotalAmount(
                            widget.user.id) ??
                        "",
                    style: context.f.body3.copyWith(
                      color: context.c.secondaryTextColor,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "+",
                  style: TextStyle(
                    color: _isTextBold
                        ? context.c.secondaryTextColor
                        : context.c.inactiveColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 64,
                  child: TextField(
                    controller: _controller,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: "0.00",
                      contentPadding: const EdgeInsets.only(top: 12),
                      hintStyle: TextStyle(
                        color: context.c.inactiveColor,
                      ),
                      isDense: true,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.c.primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                    cursorColor: context.c.primaryColor,
                    onChanged: (String? value) {
                      expense.setAdjustment(
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
            ],
          );
        },
      ),
    );
  }
}
