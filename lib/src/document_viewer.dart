import 'dart:io';

import 'package:document_viewer/utilities/constants.dart';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:flutter/material.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:photo_view/photo_view.dart';

class DocumentViewer extends StatefulWidget {
  final String filePath;
  const DocumentViewer({Key? key, required this.filePath}) : super(key: key);

  @override
  State<DocumentViewer> createState() => _DocumentViewerState();
}

class _DocumentViewerState extends State<DocumentViewer> {
  int columns = 0;
  int rows = 0;
  String filePath = "";

  getDocExtension() {
    if (widget.filePath != "") {
      return widget.filePath.substring(
          widget.filePath.lastIndexOf('.')); //To get the file extension
    }
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
    super.initState();
  }

  String content = "";
  Future<String> readFromTxtFile() async {
    try {
      final file = File(widget.filePath);
      content = await file.readAsString();
      setState(() {});
      return content;
    } catch (e) {
      return "$e";
    }
  }

  Future<String> readFromDocxFile() async {
    final file = File(widget.filePath);
    final bytes = await file.readAsBytes();
    content = docxToText(bytes);
    setState(() {});

    return content; // docx to text
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.sizeOf(context).width,
      child: Column(
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
                        padding: const EdgeInsets.all(20.0),
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
          ]
        ],
      ),
    );
  }
}
