class GoogleUser {
  final String googleId;
  final String displayName;
  final String email;

  GoogleUser(this.googleId, this.displayName, this.email);

  Map<String, String> toMap() {
    return {
      'googleId': this.googleId,
      'displayName': this.displayName,
      'email': this.email
    };
  }
}
