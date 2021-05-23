import 'package:momentum/momentum.dart';

import 'index.dart';

class HomeViewController extends MomentumController<HomeViewModel> {
  @override
  HomeViewModel init() {
    return HomeViewModel(
      this,
     currentView: 0,
    );
  }
}
