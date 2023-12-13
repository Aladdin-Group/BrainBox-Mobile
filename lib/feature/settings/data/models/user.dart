class User {
  int? id;
  String? name;
  String? surname;
  String? uniqueId;
  String? email;
  String? imageUrl;
  int? coins;
  String? systemRoleName;
  bool? enabled;
  bool? isAccountNonExpired;
  bool? isAccountNonLocked;
  bool? isCredentialsNonExpired;
  String? username;
  List<Authorities>? authorities;
  bool? accountNonExpired;
  bool? accountNonLocked;
  bool? credentialsNonExpired;
  String? password;

  User(
      {this.id,
        this.name,
        this.surname,
        this.uniqueId,
        this.email,
        this.imageUrl,
        this.coins,
        this.systemRoleName,
        this.enabled,
        this.isAccountNonExpired,
        this.isAccountNonLocked,
        this.isCredentialsNonExpired,
        this.username,
        this.authorities,
        this.accountNonExpired,
        this.accountNonLocked,
        this.credentialsNonExpired,
        this.password});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    surname = json['surname'];
    uniqueId = json['uniqueId'];
    email = json['email'];
    imageUrl = json['imageUrl'];
    coins = json['coins'];
    systemRoleName = json['systemRoleName'];
    enabled = json['enabled'];
    isAccountNonExpired = json['isAccountNonExpired'];
    isAccountNonLocked = json['isAccountNonLocked'];
    isCredentialsNonExpired = json['isCredentialsNonExpired'];
    username = json['username'];
    if (json['authorities'] != null) {
      authorities = <Authorities>[];
      json['authorities'].forEach((v) {
        authorities!.add(new Authorities.fromJson(v));
      });
    }
    accountNonExpired = json['accountNonExpired'];
    accountNonLocked = json['accountNonLocked'];
    credentialsNonExpired = json['credentialsNonExpired'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['uniqueId'] = this.uniqueId;
    data['email'] = this.email;
    data['imageUrl'] = this.imageUrl;
    data['coins'] = this.coins;
    data['systemRoleName'] = this.systemRoleName;
    data['enabled'] = this.enabled;
    data['isAccountNonExpired'] = this.isAccountNonExpired;
    data['isAccountNonLocked'] = this.isAccountNonLocked;
    data['isCredentialsNonExpired'] = this.isCredentialsNonExpired;
    data['username'] = this.username;
    if (this.authorities != null) {
      data['authorities'] = this.authorities!.map((v) => v.toJson()).toList();
    }
    data['accountNonExpired'] = this.accountNonExpired;
    data['accountNonLocked'] = this.accountNonLocked;
    data['credentialsNonExpired'] = this.credentialsNonExpired;
    data['password'] = this.password;
    return data;
  }
}

class Authorities {
  String? authority;

  Authorities({this.authority});

  Authorities.fromJson(Map<String, dynamic> json) {
    authority = json['authority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['authority'] = this.authority;
    return data;
  }
}
