import 'package:momentum/momentum.dart';

import 'index.dart';

class UserController extends MomentumController<UserModel> {
  @override
  UserModel init() {
    return UserModel(
      this,
      loading: false,
      name: '',
    );
  }
}
