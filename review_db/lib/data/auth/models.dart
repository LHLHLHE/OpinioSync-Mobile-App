class Token {
  final String token;

  Token(this.token);

  Token.fromJson(Map<String, dynamic> json)
      : token = json['auth_token'];
}

class SignUpUser {
  final String email;
  final String username;
  final String password;
  final String rePassword;

  SignUpUser(
    this.email,
    this.username,
    this.password,
    this.rePassword
  );

  Map<String, dynamic> toJson() => 
  {
    "username": username,
    "email": email,
    "password": password,
    "re_password": rePassword
  };
}

class SignInUser {
  final String username;
  final String password;

  SignInUser(
    this.username,
    this.password
  );

  Map<String, dynamic> toJson() => 
  {
    'username': username,
    'password': password
  };
}