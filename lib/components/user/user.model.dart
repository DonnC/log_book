import 'package:momentum/momentum.dart';

import 'index.dart';

class UserModel extends MomentumModel<UserController> {
  UserModel(
    UserController controller, {
    this.loading,
    this.name,
  }) : super(controller);

  final bool loading;
  final String name;

  @override
  void update({
    bool loading,
    bool isAdmin,
    String name,
  }) {
    UserModel(
      controller,
      loading: loading ?? this.loading,
      name: name ?? this.name,
    ).updateMomentum();
  }

  Map<String, dynamic> toJson() {
    return {
      'loading': loading ?? false,
      'name': name ?? 'User',
    };
  }

  UserModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;

    return UserModel(
      controller,
      loading: map['loading'] ?? false,
      name: map['name'] ?? 'User',
    );
  }
}
