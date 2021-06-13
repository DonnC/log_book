import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:momentum/momentum.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:relative_scale/relative_scale.dart';

import 'package:log_book/components/index.dart';
import 'package:log_book/constants.dart';
import 'package:log_book/services/index.dart';
import 'package:log_book/utils/index.dart';
import 'package:log_book/widgets/index.dart';

class PdfGenView extends StatelessWidget {
  pw.Widget _contentTable(pw.Context context, List<List> dataRecords) {
    final tableHeaders = [
      'Date',
      'Work Done',
      'Signature',
    ];

    return pw.Table.fromTextArray(
      cellAlignment: pw.Alignment.centerLeft,
      columnWidths: {
        0: pw.FixedColumnWidth(70.0),
        1: pw.FlexColumnWidth(),
        2: pw.FixedColumnWidth(80.0),
      },
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.center,
      },
      headerAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
      },
      headerStyle: pw.TextStyle(
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
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
    final regular = pw.Font.ttf(
        await rootBundle.load("assets/fonts/NunitoSans-Regular.ttf"));
    final bold =
        pw.Font.ttf(await rootBundle.load("assets/fonts/NunitoSans-Bold.ttf"));
    final italic = pw.Font.ttf(
        await rootBundle.load("assets/fonts/NunitoSans-Italic.ttf"));

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: regular,
        bold: bold,
        italic: italic,
      ),
    );

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
      child: CustomAppBar(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Log Book Preview'),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: () => MomentumRouter.pop(context),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: IconButton(
                  tooltip: 'save log book as .pdf to disk',
                  splashRadius: 5,
                  hoverColor: secondaryColor,
                  icon: Icon(FontAwesome.file_pdf_o),
                  onPressed: () {
                    final dialogService =
                        Momentum.service<DialogService>(context);
                    final bytes =
                        Momentum.controller<PdfPrinterViewController>(context)
                            .model
                            ?.logBookData;

                    if (bytes != null) {
                      Momentum.service<AppService>(context)
                          .savePdfToDisk(bytes)
                          .then((value) {
                        switch (value.action) {
                          case ResponseAction.Success:
                            dialogService.showFlashInfoDialog(
                              context,
                              value.message,
                              'LogBook',
                            );

                            break;
                          default:
                            dialogService.showFlashInfoDialog(
                              context,
                              value.message,
                              'LogBook',
                            );
                        }
                      });
                    }

                    // show prompt
                    else {
                      dialogService.showFlashBar(
                        context,
                        'no generated log book data found for saving',
                        'LogBook',
                      );
                    }
                  },
                ),
              ),
            ],
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
                          build: (format) async {
                            final _data =
                                _generatePdf(format, model.logBookEntries);
                            var logData = await _data;
                            model.update(logBookData: logData);
                            return _data;
                          },
                        );
                });
          }),
        ),
      ),
    );
  }
}
