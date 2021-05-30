import 'package:momentum/momentum.dart';

import 'index.dart';

class PdfPrinterViewModel extends MomentumModel<PdfPrinterViewController> {
  PdfPrinterViewModel(
    PdfPrinterViewController controller, {
    this.logBookEntries,
    this.loading,
  }) : super(controller);

  final List<List> logBookEntries;
  final bool loading;

  @override
  void update({
    List<List> logBookEntries,
    bool loading,
  }) {
    PdfPrinterViewModel(controller,
            loading: loading ?? this.loading,
            logBookEntries: logBookEntries ?? this.logBookEntries)
        .updateMomentum();
  }
}
