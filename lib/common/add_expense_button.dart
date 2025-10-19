import 'package:flutter/material.dart';
import 'package:splitt/theme/theme_extension.dart';

class AddExpenseButton extends StatefulWidget {
  final VoidCallback? onTap;

  const AddExpenseButton({
    super.key,
    this.onTap,
  });

  @override
  State<AddExpenseButton> createState() => _AddExpenseButtonState();
}

class _AddExpenseButtonState extends State<AddExpenseButton> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) {
        setState(() {
          _isTapped = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isTapped = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _isTapped = false;
        });
      },
      child: SizedBox(
        height: 52,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: _isTapped ? 2 : 0,
            ),
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: context.c.primaryColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 20,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        "assets/images/add_expense.png",
                        fit: BoxFit.cover,
                        height: 36,
                        width: 36,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Add expense",
                      style: context.f.body1.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.c.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
