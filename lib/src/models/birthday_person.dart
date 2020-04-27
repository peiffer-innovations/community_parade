import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';

@immutable
class BirthdayPerson extends Jsonable {
  BirthdayPerson({
    this.age,
    @required this.name,
  }) : assert(name?.isNotEmpty == true);

  final int age;
  final String name;

  static BirthdayPerson fromDynamic(dynamic map) {
    BirthdayPerson result;

    if (map != null) {
      result = BirthdayPerson(
        age: Jsonable.parseInt(map['age']),
        name: map['name'],
      );
    }

    return result;
  }

  static List<BirthdayPerson> fromDynamicList(dynamic list) {
    List<BirthdayPerson> results;

    if (list != null) {
      results = [];

      for (dynamic map in list) {
        results.add(fromDynamic(map));
      }
    }

    return results;
  }

  @override
  Map<String, dynamic> toJson() => {
        'age': age,
        'name': name,
      };
}
