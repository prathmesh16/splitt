import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:splitt/features/core/models/ui_state.dart';
import 'package:splitt/features/expense/presentation/bloc/expense_bloc.dart';
import 'package:splitt/theme/theme_extension.dart';

class SaveButton extends StatefulWidget {
  final ExpenseBloc expenseBloc;
  final VoidCallback? onTap;
  final VoidCallback? onSuccess;

  const SaveButton({
    super.key,
    required this.expenseBloc,
    this.onTap,
    this.onSuccess,
  });

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: widget.expenseBloc,
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
          widget.onSuccess?.call();
        }
      },
      builder: (_, UIState state) {
        if (state is Loading) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: SpinKitThreeBounce(
              color: context.c.primaryColor,
              size: 20,
            ),
          );
        }
        return _SaveButton(
          onTap: widget.onTap,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 2,
        ),
        child: Text(
          "Save",
          style: context.f.body2.copyWith(
            color: context.c.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
