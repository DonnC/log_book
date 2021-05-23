import 'package:momentum/momentum.dart';

import 'index.dart';

class HomeViewModel extends MomentumModel<HomeViewController> {
  HomeViewModel(
    HomeViewController controller, {
    this.currentView,
  }) : super(controller);

  final int currentView;

  @override
  void update({
    int currentView,
  }) {
    HomeViewModel(
      controller,
      currentView: currentView ?? this.currentView,
    ).updateMomentum();
  }
}
