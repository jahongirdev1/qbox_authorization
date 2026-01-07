import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

bool isOpen = false;

Future<void> errorDialog(BuildContext context, String errorMessage) async {
  if (isOpen) return;

  isOpen = true;
  await showCupertinoDialog<void>(
    context: context,
    builder: (BuildContext context) {
      for (int i = 0; i < 5; i++) {
        HapticFeedback.heavyImpact();
      }
      return CupertinoAlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.error,
              color: Colors.red,
              size: 50,
            ),
            const SizedBox(height: 10),
            const Text(
              'Error',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () {
              isOpen = false;
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
  isOpen = false;
}
