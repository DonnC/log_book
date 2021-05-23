import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:momentum/momentum.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfGenView extends StatefulWidget {
  @override
  _PdfGenViewState createState() => _PdfGenViewState();
}

class _PdfGenViewState extends MomentumState<PdfGenView> {
  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Center(
            child: pw.Text(title),
          );
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pdf Printing'),
        ),
        body: PdfPreview(
          build: (format) => _generatePdf(format, 'Sample'),
        ),

      ),
    );
  }
}
