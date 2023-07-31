import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:document_viewer/document_viewer.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? pdfFlePath;

  listenForPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    } else {}
  }

  Future<String> downloadAndSavePdf() async {
    await Permission.manageExternalStorage.request();
    final directory = await getApplicationDocumentsDirectory();
    var path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    final file = File('${directory.path}/sample.pdf');
    String localFilePath = '$path/sample.pdf';
    File localFile = File(localFilePath);
    Uint8List bytes = localFile.readAsBytesSync();
    file.writeAsBytesSync(bytes!);
    return localFilePath;
  }

  void loadPdf() async {
    pdfFlePath = await downloadAndSavePdf();
    setState(() {});
  }

  @override
  void initState() {
    loadPdf();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Document Viewer'),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                if (pdfFlePath != null)
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: DocumentViewer(filePath: pdfFlePath!),
                    ),
                  )
                else
                  Text("Pdf is not Loaded"),
              ],
            ),
          ),
        );
      }),
    );
  }
}
