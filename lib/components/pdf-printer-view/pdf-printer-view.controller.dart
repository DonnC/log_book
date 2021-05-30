import 'package:intl/intl.dart';
import 'package:momentum/momentum.dart';

import 'package:log_book/components/index.dart';
import 'package:log_book/services/index.dart';

import 'index.dart';

class PdfPrinterViewController extends MomentumController<PdfPrinterViewModel> {
  @override
  PdfPrinterViewModel init() {
    return PdfPrinterViewModel(
      this,
      loading: false,
      logBookEntries: [],
    );
  }

  @override
  Future<void> bootstrapAsync() async {
    await _processRecords();
  }

  /// translate logbook model to printable strings
  Future<void> _processRecords() async {
    final _service = service<AppService>();
    model.update(loading: true);

    final response = await _service.getLogBooks(descendSort: true);

    // TODO: Got lazy to check response action here
    final _logBooks = response.data;

    List<List> _entries = [];

    for (var entry in _logBooks) {
      List<String> innerList = [
        _formatDate(entry.date.toDateTime()),
        entry.workdone,
        '' // signature will be included manually by supervisor here when printed, for now
      ];

      _entries.add(innerList);
    }

    List<List> data = List<List>.from(model.logBookEntries);
    data.addAll(_entries);

    model.update(logBookEntries: data, loading: false);
  }

  String _formatDate(DateTime date) {
    final format = DateFormat('dd/M/yyyy', 'en_US');

    return format.format(date);
  }
}
