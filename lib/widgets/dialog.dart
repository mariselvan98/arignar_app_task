import 'package:flutter/material.dart';

void showResultDialog(BuildContext context, bool isCorrect, Function callBack) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Text(
              isCorrect ? 'Correct!' : 'Wrong!',
              style: TextStyle(
                fontSize: 24,
                color: isCorrect ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (isCorrect) callBack();
              Navigator.of(context).pop();
            },
            child: Text(
              'Close',
              style: TextStyle(
                fontSize: 18,
                color: isCorrect ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      );
    },
  );
}
