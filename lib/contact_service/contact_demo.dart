part of contact_lib;

@Entity()
class ContactDemo{

  bool get isShown => _isShown == null || _isShown ? false: true;
  set isShown(bool value) =>  _isShown = value;

  bool _isShown;
  String id;
  String name;
  int age;
  String gender;
  String department;
  AddressDemo address;

  @Property(ignore:true)
  bool isActive;

  dynamic getFieldValue(String fieldName){

    var names = fieldName.split('.');
    var reflectedObject = this;
    names.forEach((n){
      InstanceMirror objectMirror = reflect(reflectedObject);
      reflectedObject = objectMirror.getField( new Symbol(n)).reflectee;
    });

    return reflectedObject;
  }
}