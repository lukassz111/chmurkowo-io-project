import 'package:chmurkowo/service/AuthService.dart';
import 'package:flutter/material.dart';

class GoogleLoginPage extends StatefulWidget {
  GoogleLoginPage({Key key}) : super(key: key);
  @override
  _GoogleLoginPageState createState() => _GoogleLoginPageState();
}

class _GoogleLoginPageState extends State<GoogleLoginPage> {
  /*
  final _fbAppId = "1403799673305728";
  final _fbAppSecret = "341b214268714f1cbf1267337eafc3e9";
  final _fbClientToken = "32799e9bbe84b2ef2f3d62e4e98280fa";
  final _googleClientId =
      "399984371319-mjp5lsvj3lkvtkfp703lejqs8vdvmb31.apps.googleusercontent.com";
  final _googleClientSecret = "KSQ1tacxR-JxlzS5N9aKe3hE";
  final _googleAuthorizedJavaScriptOrgins =
      "https://apichmurkowo.azurewebsites.net";
  final _googleRedirectURI =
      "https://apichmurkowo.azurewebsites.net/.auth/login/google/callback" +
          "?post_login_redirect_url=chmurkowo://client.chmurkowo.com";

  final _azureGoogle =
      "https://apichmurkowo.azurewebsites.net/.auth/login/google/callback";
  final _azureFacebook =
      "https://apichmurkowo.azurewebsites.net/.auth/login/facebook/callback";

  final _wellKnownGoogle =
      "https://accounts.google.com/.well-known/openid-configuration";

  final _appRedirectURI = "chmurkowo://client.chmurkowo.com";
  */

  final AuthService authService = new AuthService();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Logowanie Google"),
      ),
      body: Center(
        child: Column(
          children: [
            RaisedButton(
                child: Text("Zaloguj"),
                onPressed: () {
                  authService.signInWithGoogle();
                })
          ],
        ),
      ),
    );
  }
}
