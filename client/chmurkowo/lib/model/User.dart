class User {
  final String googleId;
  final String displayName;
  final String email;
  int score;
  int photosLeft;
  int lastPhotoTimestamp;

  User(this.googleId, this.displayName, this.email, this.score, this.photosLeft, this.lastPhotoTimestamp);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['googleId'] as String,
      json['displayName'] as String,
      json['email'] as String,
      json['score'] as int,
      json["photosLeft"] as int,
      json["lastPhotoTimestamp"] as int
    );
  }

  String getDisplayName() {
    return this.displayName;
  }
}
