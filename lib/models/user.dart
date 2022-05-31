class User {
  String? id;
  String? name;
  String? email;
  String? password;
  String? accessrole;
  String? location;

  User(this.id, this.email, this.name) {
    password = password;
    accessrole = accessrole;
    location = location;
  }

  User.fromJson(Map json) {
    id = json["id"].toString();
    email = json["email"].toString();
    name = json["name"].toString();
    password = json["password"].toString();
    accessrole = json["accessrole"].toString();
    location = json["location"].toString();
  }

  Map toJson() {
    return {
      "id": id,
      "email": email,
      "name": name,
      "password": password,
      "location": location,
      "accessrole": accessrole
    };
  }
}
