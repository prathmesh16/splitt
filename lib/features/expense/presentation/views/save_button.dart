import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splitt/common/utils/constants.dart';
import 'package:splitt/features/core/models/ui_state.dart';
import 'package:splitt/features/expense/presentation/bloc/save_expense_bloc.dart';

class SaveButton extends StatefulWidget {
  final Function(SaveExpenseBloc)? onTap;

  const SaveButton({
    super.key,
    this.onTap,
  });

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  final saveExpenseBloc = SaveExpenseBloc();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: saveExpenseBloc,
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
          Navigator.pop(context);
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
        return _SaveButton(
          onTap: () => widget.onTap?.call(saveExpenseBloc),
        );
      },
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _SaveButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: const Text(
        "Save",
        style: TextStyle(
          color: Constants.primaryColor,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
}
