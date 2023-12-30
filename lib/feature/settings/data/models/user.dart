/// id : 3
/// name : "Azizbek Xoliqov"
/// surname : "some"
/// uniqueId : "107335275705170148776"
/// email : "xoliqovazizbek23@gmail.com"
/// imageUrl : "https://lh3.googleusercontent.com/a/ACg8ocLtZCfMy8lNFtJVwSX9_jl_699Lnpr-0iUHEdT9zsIABr8"
/// coins : 1300
/// isPremium : false
/// systemRoleName : "ROLE_USER"
/// enabled : true
/// isAccountNonExpired : true
/// isAccountNonLocked : true
/// isCredentialsNonExpired : true
/// password : "107335275705170148776"
/// username : "xoliqovazizbek23@gmail.com"
/// authorities : [{"authority":"ROLE_USER"}]
/// accountNonExpired : true
/// credentialsNonExpired : true
/// accountNonLocked : true

class User {
  User({
      int? id,
      String? name, 
      String? surname, 
      String? uniqueId, 
      String? email, 
      String? imageUrl,
      int? coins,
      bool? isPremium, 
      String? systemRoleName, 
      bool? enabled, 
      bool? isAccountNonExpired, 
      bool? isAccountNonLocked, 
      bool? isCredentialsNonExpired, 
      String? password, 
      String? username, 
      List<Authorities>? authorities, 
      bool? accountNonExpired, 
      bool? credentialsNonExpired, 
      bool? accountNonLocked,}){
    _id = id;
    _name = name;
    _surname = surname;
    _uniqueId = uniqueId;
    _email = email;
    _imageUrl = imageUrl;
    _coins = coins;
    _isPremium = isPremium;
    _systemRoleName = systemRoleName;
    _enabled = enabled;
    _isAccountNonExpired = isAccountNonExpired;
    _isAccountNonLocked = isAccountNonLocked;
    _isCredentialsNonExpired = isCredentialsNonExpired;
    _password = password;
    _username = username;
    _authorities = authorities;
    _accountNonExpired = accountNonExpired;
    _credentialsNonExpired = credentialsNonExpired;
    _accountNonLocked = accountNonLocked;
}

  User.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _surname = json['surname'];
    _uniqueId = json['uniqueId'];
    _email = json['email'];
    _imageUrl = json['imageUrl'];
    _coins = json['coins'];
    _isPremium = json['isPremium'];
    _systemRoleName = json['systemRoleName'];
    _enabled = json['enabled'];
    _isAccountNonExpired = json['isAccountNonExpired'];
    _isAccountNonLocked = json['isAccountNonLocked'];
    _isCredentialsNonExpired = json['isCredentialsNonExpired'];
    _password = json['password'];
    _username = json['username'];
    if (json['authorities'] != null) {
      _authorities = [];
      json['authorities'].forEach((v) {
        _authorities?.add(Authorities.fromJson(v));
      });
    }
    _accountNonExpired = json['accountNonExpired'];
    _credentialsNonExpired = json['credentialsNonExpired'];
    _accountNonLocked = json['accountNonLocked'];
  }
  int? _id;
  String? _name;
  String? _surname;
  String? _uniqueId;
  String? _email;
  String? _imageUrl;
  int? _coins;
  bool? _isPremium;
  String? _systemRoleName;
  bool? _enabled;
  bool? _isAccountNonExpired;
  bool? _isAccountNonLocked;
  bool? _isCredentialsNonExpired;
  String? _password;
  String? _username;
  List<Authorities>? _authorities;
  bool? _accountNonExpired;
  bool? _credentialsNonExpired;
  bool? _accountNonLocked;
User copyWith({  int? id,
  String? name,
  String? surname,
  String? uniqueId,
  String? email,
  String? imageUrl,
  int? coins,
  bool? isPremium,
  String? systemRoleName,
  bool? enabled,
  bool? isAccountNonExpired,
  bool? isAccountNonLocked,
  bool? isCredentialsNonExpired,
  String? password,
  String? username,
  List<Authorities>? authorities,
  bool? accountNonExpired,
  bool? credentialsNonExpired,
  bool? accountNonLocked,
}) => User(  id: id ?? _id,
  name: name ?? _name,
  surname: surname ?? _surname,
  uniqueId: uniqueId ?? _uniqueId,
  email: email ?? _email,
  imageUrl: imageUrl ?? _imageUrl,
  coins: coins ?? _coins,
  isPremium: isPremium ?? _isPremium,
  systemRoleName: systemRoleName ?? _systemRoleName,
  enabled: enabled ?? _enabled,
  isAccountNonExpired: isAccountNonExpired ?? _isAccountNonExpired,
  isAccountNonLocked: isAccountNonLocked ?? _isAccountNonLocked,
  isCredentialsNonExpired: isCredentialsNonExpired ?? _isCredentialsNonExpired,
  password: password ?? _password,
  username: username ?? _username,
  authorities: authorities ?? _authorities,
  accountNonExpired: accountNonExpired ?? _accountNonExpired,
  credentialsNonExpired: credentialsNonExpired ?? _credentialsNonExpired,
  accountNonLocked: accountNonLocked ?? _accountNonLocked,
);
  int? get id => _id;
  String? get name => _name;
  String? get surname => _surname;
  String? get uniqueId => _uniqueId;
  String? get email => _email;
  String? get imageUrl => _imageUrl;
  int? get coins => _coins;
  bool? get isPremium => _isPremium;
  String? get systemRoleName => _systemRoleName;
  bool? get enabled => _enabled;
  bool? get isAccountNonExpired => _isAccountNonExpired;
  bool? get isAccountNonLocked => _isAccountNonLocked;
  bool? get isCredentialsNonExpired => _isCredentialsNonExpired;
  String? get password => _password;
  String? get username => _username;
  List<Authorities>? get authorities => _authorities;
  bool? get accountNonExpired => _accountNonExpired;
  bool? get credentialsNonExpired => _credentialsNonExpired;
  bool? get accountNonLocked => _accountNonLocked;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['surname'] = _surname;
    map['uniqueId'] = _uniqueId;
    map['email'] = _email;
    map['imageUrl'] = _imageUrl;
    map['coins'] = _coins;
    map['isPremium'] = _isPremium;
    map['systemRoleName'] = _systemRoleName;
    map['enabled'] = _enabled;
    map['isAccountNonExpired'] = _isAccountNonExpired;
    map['isAccountNonLocked'] = _isAccountNonLocked;
    map['isCredentialsNonExpired'] = _isCredentialsNonExpired;
    map['password'] = _password;
    map['username'] = _username;
    if (_authorities != null) {
      map['authorities'] = _authorities?.map((v) => v.toJson()).toList();
    }
    map['accountNonExpired'] = _accountNonExpired;
    map['credentialsNonExpired'] = _credentialsNonExpired;
    map['accountNonLocked'] = _accountNonLocked;
    return map;
  }

}

/// authority : "ROLE_USER"

class Authorities {
  Authorities({
      String? authority,}){
    _authority = authority;
}

  Authorities.fromJson(dynamic json) {
    _authority = json['authority'];
  }
  String? _authority;
Authorities copyWith({  String? authority,
}) => Authorities(  authority: authority ?? _authority,
);
  String? get authority => _authority;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['authority'] = _authority;
    return map;
  }

}