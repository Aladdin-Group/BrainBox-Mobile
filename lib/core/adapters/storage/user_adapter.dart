import 'package:hive/hive.dart';

import '../../../feature/settings/data/models/user.dart';

class UserHiveAdapter extends TypeAdapter<User> {
  @override
  User read(BinaryReader reader) {
    var fieldsCount = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < fieldsCount; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as int?,
      name: fields[1] as String?,
      surname: fields[2] as String?,
      uniqueId: fields[3] as String?,
      email: fields[4] as String?,
      imageUrl: fields[5] as String?,
      coins: fields[6] as int?,
      isPremium: fields[7] as bool?,
      systemRoleName: fields[8] as String?,
      enabled: fields[9] as bool?,
      isAccountNonExpired: fields[10] as bool?,
      isAccountNonLocked: fields[11] as bool?,
      isCredentialsNonExpired: fields[12] as bool?,
      password: fields[13] as String?,
      username: fields[14] as String?,
      authorities: (fields[15] as List).cast<Authorities>(),
      accountNonExpired: fields[16] as bool?,
      credentialsNonExpired: fields[17] as bool?,
      accountNonLocked: fields[18] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.writeByte(19); // Number of fields in the User class

    writer.writeByte(0);
    writer.write(obj.id);

    writer.writeByte(1);
    writer.write(obj.name);

    writer.writeByte(2);
    writer.write(obj.surname);

    writer.writeByte(3);
    writer.write(obj.uniqueId);

    writer.writeByte(4);
    writer.write(obj.email);

    writer.writeByte(5);
    writer.write(obj.imageUrl);

    writer.writeByte(6);
    writer.write(obj.coins);

    writer.writeByte(7);
    writer.write(obj.isPremium);

    writer.writeByte(8);
    writer.write(obj.systemRoleName);

    writer.writeByte(9);
    writer.write(obj.enabled);

    writer.writeByte(10);
    writer.write(obj.isAccountNonExpired);

    writer.writeByte(11);
    writer.write(obj.isAccountNonLocked);

    writer.writeByte(12);
    writer.write(obj.isCredentialsNonExpired);

    writer.writeByte(13);
    writer.write(obj.password);

    writer.writeByte(14);
    writer.write(obj.username);

    writer.writeByte(15);
    writer.write(obj.authorities);

    writer.writeByte(16);
    writer.write(obj.accountNonExpired);

    writer.writeByte(17);
    writer.write(obj.credentialsNonExpired);

    writer.writeByte(18);
    writer.write(obj.accountNonLocked);
  }

  @override
  int get typeId => 1; // Ensure a unique type ID for each TypeAdapter
}
