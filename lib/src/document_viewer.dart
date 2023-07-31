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
  getDocExtension() {
    if (widget.filePath != "") {
      return widget.filePath.substring(widget.filePath.lastIndexOf('.'));
    }

    // if (widget.filePath != null) {
    // }
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
      return content;
    } catch (e) {
      return "$e";
    }
  }

  Future<String> readFromDocxFile() async {
    final file = File(widget.filePath);
    final bytes = await file.readAsBytes();
    content = docxToText(bytes);
    return content;
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
            Expanded(child: PdfView(path: widget.filePath)),
          ] else if (getDocExtension() == Constants.txt ||
              getDocExtension() == Constants.docx ||
              getDocExtension() == Constants.doc) ...[
            Expanded(
                child: SingleChildScrollView(
                    child:
                        Container(color: Colors.white, child: Text(content)))),
          ] else if (getDocExtension() == Constants.jpeg ||
              getDocExtension() == Constants.jpg ||
              getDocExtension() == Constants.png) ...[
            Expanded(
              child: PhotoView(
                imageProvider: FileImage(File(widget.filePath)),
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
