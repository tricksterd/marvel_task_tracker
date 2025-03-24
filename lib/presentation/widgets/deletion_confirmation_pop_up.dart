import 'package:flutter/material.dart';

import '../../application/core/styles.dart';

class DeletionConfirmationPopUp extends StatelessWidget {
  const DeletionConfirmationPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Deleting...', style: AppTextStyle.titleText),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Task is\'t completed yet. Do you really want to delete it?',
            style: AppTextStyle.primaryText,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text(
            'Cancel',
            style: AppTextStyle.inputLabel.copyWith(
              color: AppTextStyle.darkBlue,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(
            'Delete',
            style: AppTextStyle.inputLabel.copyWith(
              color: AppTextStyle.primaryRed,
            ),
          ),
        ),
      ],
    );
  }
}
