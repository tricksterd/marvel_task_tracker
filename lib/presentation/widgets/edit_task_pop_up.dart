import 'package:flutter/material.dart';

import '../../application/core/constants.dart';
import '../../application/core/styles.dart';
import '../../domain/models/mission_model.dart';
import 'get_threat_color.dart';

class EditTaskPopUp extends StatefulWidget {
  const EditTaskPopUp({super.key, this.mission});

  final MissionModel? mission;

  @override
  State<EditTaskPopUp> createState() => _EditTaskPopUpState();
}

class _EditTaskPopUpState extends State<EditTaskPopUp> {
  late TextEditingController _titleController;

  final _formKey = GlobalKey<FormState>();

  late String _threatLevel;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();

    _titleController.text = widget.mission?.name ?? '';
    _threatLevel = widget.mission?.threatLevel ?? kThreatLevel[0];
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.mission != null ? 'Edit Task' : 'Add Task',
        style: AppTextStyle.titleText,
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              style: AppTextStyle.inputLabel.copyWith(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: AppTextStyle.inputLabel.copyWith(
                  color: AppTextStyle.primaryRed,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter valid title';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Text('Threat Level:',
                style: AppTextStyle.secondaryText.copyWith(
                  color: AppTextStyle.primaryRed,
                )),
            SizedBox(
              height: 50,
              child: DropdownButton(
                items: kThreatLevel.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      color: getThreatColor(value),
                      child: Text(value,
                          style: AppTextStyle.inputLabel.copyWith(
                            color: Colors.white,
                          )),
                    ),
                  );
                }).toList(),
                value: _threatLevel,
                onChanged: (String? value) {
                  setState(() {
                    _threatLevel = value!;
                  });
                },
              ),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: AppTextStyle.inputLabel.copyWith(
              color: AppTextStyle.primaryRed,
            ),
          ),
        ),
        TextButton(
          onPressed: () => _validate(),
          child: Text(
            widget.mission != null ? 'Edit' : 'Add',
            style: AppTextStyle.inputLabel.copyWith(
              color: AppTextStyle.darkBlue,
            ),
          ),
        )
      ],
    );
  }

  _validate() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.pop(
        context,
        MissionModel(
          id: widget.mission?.id,
          name: _titleController.text,
          threatLevel: _threatLevel,
        ));
  }
}
