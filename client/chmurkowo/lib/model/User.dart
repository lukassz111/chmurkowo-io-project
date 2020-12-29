import 'package:chmurkowo/model/Json.dart';

class User implements Json {
  final String id;
  final String displayName;

  User(this.id, this.displayName);
  Map<String, dynamic> toJson() {
    return {'id': this.id, 'displayName': this.displayName};
  }
}
