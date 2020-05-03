import 'package:community_parade/src/validators/validator_interface.dart';
import 'package:meta/meta.dart';

@immutable
class ValidatorChain {
  ValidatorChain({
    @required List<ValidatorInterface> validators,
  })  : assert(validators?.isNotEmpty == true),
        _validators = validators;

  final List<ValidatorInterface> _validators;

  String validate({
    @required String label,
    @required String value,
  }) {
    assert(label?.isNotEmpty == true);

    String error;

    for (var validator in _validators) {
      error ??= validator.validate(
        label: label,
        value: value,
      );
    }

    return error;
  }
}
