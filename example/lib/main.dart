import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:document_viewer/document_viewer.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
    final file = File('${directory.path}/Sample11.pdf');
    String localFilePath = '$path/Sample11.pdf';
    File localFile = File(localFilePath);
    Uint8List bytes = localFile.readAsBytesSync();
    file.writeAsBytesSync(bytes);
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (pdfFlePath != null)
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: DocumentViewer(filePath: pdfFlePath!),
                    ),
                  )
                else
                  const Center(child: Text("Document is not Found")),
              ],
            ),
          ),
        );
      }),
    );
  }
}
