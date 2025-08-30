   import 'package:arkroot_todo_app/core/presentation/utils/message_generator.dart';
import 'package:arkroot_todo_app/core/presentation/utils/theme.dart';
import 'package:flutter/material.dart';

void showDeleteConfirmationDialog(BuildContext context, Function() onDelete) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: appColors.inputBgFill,
            title: Text(
              MessageGenerator.getLabel("delete"),
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              MessageGenerator.getMessage("delete_message"),
              style: TextStyle(color: Colors.grey[300]),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  MessageGenerator.getLabel("Cancel"),
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onDelete();
                },
                child: Text(
                  MessageGenerator.getLabel("delete"),
                  style: TextStyle(color: Colors.red[400]),
                ),
              ),
            ],
          );
        },
      );
    }