import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splitt/features/core/models/ui_state.dart';
import 'package:splitt/features/expense/presentation/bloc/delete_expense_bloc.dart';

class DeleteButton extends StatefulWidget {
  final Function(DeleteExpenseBloc)? onTap;
  final VoidCallback? onSuccess;

  const DeleteButton({
    super.key,
    this.onTap,
    this.onSuccess,
  });

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  final deleteExpenseBloc = DeleteExpenseBloc();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: deleteExpenseBloc,
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
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
              ),
            ),
          );
        }
        return _DeleteButton(
          onTap: () => widget.onTap?.call(deleteExpenseBloc),
        );
      },
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _DeleteButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: const Icon(Icons.delete_forever),
    );
  }
}
