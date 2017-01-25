import 'dart:async';
import 'dart:html';
import 'package:dartson/dartson.dart';

import 'package:angular2/core.dart';

const _namesPath =
    'https://gist.githubusercontent.com/bunopus/f48fbb06578003fb521c7c1a54fd906a/raw/e5767c1e7f172c6375f064a9441f2edd57a79f15/test_users.json';

@Injectable()
class ContactService {
  List<ContactDemo> contacts;

  Future getContacts() async {
    try {
      var jsonString = await HttpRequest.getString(_namesPath);
      var dson = new Dartson.JSON();

      return contacts = dson.decode(jsonString, new ContactDemo(), true);
    } catch (arrr) {
      print('Error initializing names: $arrr');
    }

  }
}


@Entity()
class ContactDemo{
  String id;
  String name;
  int age;
  String gender;
  String department;
  AddressDemo address;

  @Property(ignore:true)
  bool isActive;
}

@Entity()
class AddressDemo{
  String city;
  String street;
}
