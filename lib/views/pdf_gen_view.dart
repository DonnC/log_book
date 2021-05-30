import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:relative_scale/relative_scale.dart';

import 'package:log_book/components/index.dart';
import 'package:log_book/widgets/index.dart';

class PdfGenView extends StatelessWidget {
  pw.Widget _contentTable(pw.Context context, List<List> dataRecords) {
    final tableHeaders = [
      'Date',
      'Work Done',
      'Signature',
    ];

    return pw.Table.fromTextArray(
      // border: null,
      cellAlignment: pw.Alignment.centerLeft,
      //headerDecoration: pw.BoxDecoration(
      //  color: baseColor,
      //),
      //headerHeight: 25,
      //cellHeight: 40,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.center,
      },
      headerStyle: pw.TextStyle(
        //color: _baseTextColor,
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        // color: _darkColor,
        fontSize: 10,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.black, width: .5),
        ),
      ),
      headers: tableHeaders,
      data: dataRecords,
    );
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format, List<List> dataRecords) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          _contentTable(context, dataRecords),
        ],
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Log Book Preview'),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () => MomentumRouter.pop(context),
          ),
        ),
        body: RelativeBuilder(builder: (context, height, width, sy, sx) {
          return MomentumBuilder(
              controllers: [PdfPrinterViewController],
              builder: (context, snapshot) {
                final model = snapshot<PdfPrinterViewModel>();

                return model.loading
                    ? Center(
                        child: customLoader(
                          heightFromTop: height * 0.3,
                          loaderType: 2,
                          loaderText: 'loading log book preview..',
                        ),
                      )
                    : PdfPreview(
                        allowSharing: false,
                        build: (format) =>
                            _generatePdf(format, model.logBookEntries),
                      );
              });
        }),
      ),
    );
  }
}
