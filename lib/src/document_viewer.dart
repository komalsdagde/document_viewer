import 'dart:io';

import 'package:document_viewer/utilities/constants.dart';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';
import 'package:photo_view/photo_view.dart';
// import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

class DocumentViewer extends StatefulWidget {
  final String filePath;
  const DocumentViewer({Key? key, required this.filePath}) : super(key: key);

  @override
  State<DocumentViewer> createState() => _DocumentViewerState();
}

class _DocumentViewerState extends State<DocumentViewer> {
  // ignore: unused_field
  String _version = 'Unknown';

  getDocExtension() {
    if (widget.filePath != "") {
      return widget.filePath.substring(
          widget.filePath.lastIndexOf('.')); //To get the file extension
    }
  }

  // List<Map> excelData = [];
  // List<String> headingList = [];
  // _importFromExcel() async {
  //   var file = widget.filePath;
  //   var bytes = File(file).readAsBytesSync();
  //   var decoder = SpreadsheetDecoder.decodeBytes(bytes, update: true);
  //   for (var table in decoder.tables.keys) {
  //     print(table);
  //     print(decoder.tables[table]!.maxCols);
  //     print(decoder.tables[table]!.maxRows);
  //     for (var row in decoder.tables[table]!.rows) {
  //       Map cell = {};
  //       cell = row.asMap();
  //       excelData.add(cell);
  //
  //       print('$row');
  //     }
  //     print("EXCELDATA FIRST: ${excelData.first.values.toList()}");
  //   }
  //
  //   // var bytes = File(file).readAsBytesSync();
  //   // var excel = Excel.decodeBytes(bytes);
  //   //
  //   // for (var table in excel.tables.keys) {
  //   //   for (var row in excel.tables[table]!.rows) {
  //   //     rowdetail = row;
  //   //   }
  //   // }
  //   //
  //   // var excel1 = Excel.createExcel();
  //   //
  //   // Sheet sheetObject = excel1['Sheet1'];
  //   //
  //   // CellStyle cellStyle = CellStyle(
  //   //     backgroundColorHex: '#1AFF1A',
  //   //     fontFamily: getFontFamily(FontFamily.Calibri));
  //   //
  //   // cellStyle.underline = Underline.Single; // or Underline.Double
  //   //
  //   // var cell = sheetObject.cell(CellIndex.indexByString('A1'));
  //   // cell.value = 8; // dynamic values support provided;
  //   //
  //   // List<String> data = ["Mr", "Joseph", "Isiyemi"];
  //   // sheetObject.appendRow(data);
  //   // // cell.cellStyle = cellStyle;
  //   //
  //   // print("sheetObject : ${sheetObject.rows}");
  // }

  Future<void> initPlatformState() async {
    // ignore: unused_local_variable
    String version;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      PdftronFlutter.initialize();
      version = await PdftronFlutter.version;
    } on PlatformException {
      version = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _version = version;
    });
  }

  @override
  void initState() {
    getDocExtension();
    if (getDocExtension() == Constants.txt) {
      readFromTxtFile();
    }
    if (getDocExtension() == Constants.docx ||
        getDocExtension() == Constants.doc) {
      readFromDocxFile();
    }
    // if (getDocExtension() == Constants.xlsx) {
    //   _importFromExcel();
    // }
    if (getDocExtension() == Constants.pptx) {
      initPlatformState(); //Initialization method
      PdftronFlutter.openDocument(widget.filePath); // To open the ppt file
    }

    super.initState();
  }

  String content = "";
  Future<String> readFromTxtFile() async {
    try {
      final file = File(widget.filePath);
      content = await file.readAsString();
      return content;
    } catch (e) {
      return "$e";
    }
  }

  Future<String> readFromDocxFile() async {
    final file = File(widget.filePath);
    final bytes = await file.readAsBytes(); // Convert file into bytes
    content = docxToText(bytes);
    setState(() {}); // docx to text

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (getDocExtension() == Constants.pdf) ...[
            Expanded(child: PdfView(path: widget.filePath)), //To open the pdf
          ] else if (getDocExtension() == Constants.txt ||
              getDocExtension() == Constants.docx ||
              getDocExtension() == Constants.doc) ...[
            Expanded(
                child: SingleChildScrollView(
                    child: Container(
                        color: Colors.white,
                        child: Text(content)))), //To open docx and doc files
          ] else if (getDocExtension() == Constants.jpeg ||
              getDocExtension() == Constants.jpg ||
              getDocExtension() == Constants.png) ...[
            Expanded(
              child: PhotoView(
                imageProvider: FileImage(File(
                    widget.filePath)), // To view image such as jpg,jpeg,png
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 1.4,
                initialScale: PhotoViewComputedScale.contained,
                basePosition: Alignment.topCenter,
                backgroundDecoration: const BoxDecoration(color: Colors.white),
              ),
            ),
          ] else if (getDocExtension() == Constants.xlsx) ...[
            // SizedBox(
            //   height: 900,
            //   width: 900,
            //   child: DataTable(
            //     columns: excelData.first.values
            //         .toList()
            //         .map((e) => DataColumn(label: Text(e.toString())))
            //         .toList(),
            //     // DataColumn(
            //     //   label: Text('ID'),
            //     // ),
            //
            //     rows: excelData
            //         . // Loops through dataColumnText, each iteration assigning the value to element
            //         first
            //         .values
            //         .map(
            //           ((element) => const DataRow(
            //                 cells: <DataCell>[
            //                   DataCell(Text("1")),
            //                   DataCell(Text("1")),
            //                   DataCell(Text("1")),
            //                   DataCell(Text("1")),
            //                   DataCell(Text("1")),
            //                   DataCell(Text("1")),
            //                   DataCell(Text("1")),
            //                   DataCell(Text(
            //                       "1")) //Extracting from Map element the value
            //                   // DataCell(Text(element["Number"])),
            //                   // DataCell(Text(element["State"])),
            //                 ],
            //               )),
            //         )
            //         .toList(),
            //   ),
            // )
          ] else if (getDocExtension() == Constants.pptx) ...[
            const Center(child: Text("Waiting..."))
          ]
        ],
      ),
    );
  }
}
