// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

class ViewSnackbar {
  void showSuccessMessage(context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          'Data submitted successfully',
        ),
      ),
    );
  }

  void showErrorMessage(context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Data submitted not successfully',
        ),
      ),
    );
  }
}
