import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

abstract class ValidatorInterface {
  String validate({
    BuildContext context,
    @required String label,
    @required String value,
  });
}
