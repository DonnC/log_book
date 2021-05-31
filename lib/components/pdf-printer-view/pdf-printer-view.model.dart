import 'dart:typed_data';

import 'package:momentum/momentum.dart';

import 'index.dart';

class PdfPrinterViewModel extends MomentumModel<PdfPrinterViewController> {
  PdfPrinterViewModel(
    PdfPrinterViewController controller, {
    this.logBookEntries,
    this.loading,
    this.logBookData,
  }) : super(controller);

  final List<List> logBookEntries;
  final Uint8List logBookData;
  final bool loading;

  @override
  void update({
    List<List> logBookEntries,
    bool loading,
    Uint8List logBookData,
  }) {
    PdfPrinterViewModel(
      controller,
      loading: loading ?? this.loading,
      logBookEntries: logBookEntries ?? this.logBookEntries,
      logBookData: logBookData ?? this.logBookData,
    ).updateMomentum();
  }
}
