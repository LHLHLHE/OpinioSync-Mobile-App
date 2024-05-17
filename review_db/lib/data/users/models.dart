class User {
  final int id;
  final String email;
  final String username;
  final String? photo;

  User(this.id, this.email, this.username, this.photo);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        username = json['username'],
        photo = json['photo'];
  
  String? getImageURL() {
    return photo;
  }
}

class SetUserPassword {
  final String currentPassword;
  final String newPassword;
  final String reNewPassword;

  SetUserPassword(this.currentPassword, this.newPassword, this.reNewPassword);

  Map<String, dynamic> toJson() => 
  {
    "current_password": currentPassword,
    "new_password": newPassword,
    "re_new_password": reNewPassword
};
}