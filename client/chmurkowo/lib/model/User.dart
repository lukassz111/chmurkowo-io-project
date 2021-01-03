class User {
  final String id;
  final String displayName;

  User(this.id, this.displayName);
  Map<String, dynamic> toMap() {
    return {'id': this.id, 'displayName': this.displayName};
  }
}
