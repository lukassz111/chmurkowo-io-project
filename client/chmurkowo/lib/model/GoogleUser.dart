class GoogleUser {
  final String googleId;
  final String displayName;
  final String email;
  GoogleUser(this.googleId, this.displayName, this.email);

  String getDisplayName() {
    return this
        .displayName
        .replaceAll('Ł', 'L')
        .replaceAll('ł', 'l')
        .replaceAll('ś', 's')
        .replaceAll('Ś', 'S');
  }

  Map<String, String> toMap() {
    return {
      'googleId': this.googleId,
      'displayName': this.getDisplayName(),
      'email': this.email
    };
  }
}
