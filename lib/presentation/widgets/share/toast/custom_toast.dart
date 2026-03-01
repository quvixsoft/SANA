import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastType { success, error, warning, info }

class CustomToast {
  static void show({
    required BuildContext context,
    required String message,
    ToastType type = ToastType.info,
    ToastGravity gravity = ToastGravity.BOTTOM,
    int durationSeconds = 2,
  }) {
    final fToast = FToast();
    fToast.init(context);

    final config = _getConfig(type);

    fToast.showToast(
      toastDuration: Duration(seconds: durationSeconds),
      gravity: gravity,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: config.backgroundColor,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(config.icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static _ToastConfig _getConfig(ToastType type) {
    switch (type) {
      case ToastType.success:
        return _ToastConfig(
          backgroundColor: Colors.green.shade700,
          icon: Icons.check_circle_outline,
        );
      case ToastType.error:
        return _ToastConfig(
          backgroundColor: Colors.red.shade700,
          icon: Icons.error_outline,
        );
      case ToastType.warning:
        return _ToastConfig(
          backgroundColor: Colors.orange.shade700,
          icon: Icons.warning_amber_outlined,
        );
      case ToastType.info:
        return _ToastConfig(
          backgroundColor: Colors.blue.shade700,
          icon: Icons.info_outline,
        );
    }
  }
}

class _ToastConfig {
  final Color backgroundColor;
  final IconData icon;

  _ToastConfig({required this.backgroundColor, required this.icon});
}
