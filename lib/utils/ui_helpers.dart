import 'package:flutter/material.dart';
import 'package:tinder/ui/widgets/dialogs/session_expired_dialog.dart';

void showSessionExpiredDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => const SessionExpiredDialog(),
  );
}

Center buildLoading() => const Center(child: CircularProgressIndicator());

Center buildError(String error) {
  return Center(
    child: Text(
      error,
      style: const TextStyle(color: Colors.red, fontSize: 18),
    ),
  );
}

Center buildDefaultError() {
  return const Center(
    child: Text(
      'Something went wrong!',
      style: TextStyle(fontSize: 18, color: Colors.grey),
    ),
  );
}
