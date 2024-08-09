import 'package:flutter/material.dart';

class SessionExpiredDialog extends StatelessWidget {
  const SessionExpiredDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Phiên đăng nhập hết hạn'),
      content: const Text('Phiên đăng nhập của bạn đã hết hạn. Vui lòng đăng nhập lại.'),
      actions: <Widget>[
        TextButton(
          child: const Text('Quay về trang chủ'),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/home');
          },
        ),
      ],
    );
  }
}
