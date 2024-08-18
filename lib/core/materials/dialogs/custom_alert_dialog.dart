import 'package:flutter/material.dart';

enum AlertType { error, warning, info }

class CustomAlertDialog extends StatelessWidget {
  final AlertType type;
  final String title;
  final String message;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const CustomAlertDialog({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      title: Row(
        children: [
          _getIcon(),
          const SizedBox(width: 8),
          Text(title,style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold
          ),),
        ],
      ),
      content: Text(message),
      actions: [
        if (onCancel != null)
          TextButton(
            onPressed: onCancel,
            child: const Text('Cancel'),
          ),
        TextButton(
          onPressed: onConfirm ?? () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }

  Widget _getIcon() {
    IconData iconData;
    Color color;

    switch (type) {
      case AlertType.error:
        iconData = Icons.error_outline;
        color = Colors.red;
        break;
      case AlertType.warning:
        iconData = Icons.warning_amber_outlined;
        color = Colors.orange;
        break;
      case AlertType.info:
        iconData = Icons.info_outline;
        color = Colors.blue;
        break;
    }

    return Icon(iconData, color: color);
  }
}

// Example usage
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Alert Dialog Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showAlert(context, AlertType.error),
              child: Text('Show Error Alert'),
            ),
            ElevatedButton(
              onPressed: () => _showAlert(context, AlertType.warning),
              child: Text('Show Warning Alert'),
            ),
            ElevatedButton(
              onPressed: () => _showAlert(context, AlertType.info),
              child: Text('Show Info Alert'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlert(BuildContext context, AlertType type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          type: type,
          title: '${type.toString().split('.').last.capitalize()} Alert',
          message: 'This is a ${type.toString().split('.').last} message.',
          onConfirm: () {
            print('Alert confirmed');
            Navigator.of(context).pop();
          },
          onCancel: () {
            print('Alert canceled');
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}