import 'dart:io';

import 'package:document_viewer/utilities/constants.dart';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:flutter/material.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:photo_view/photo_view.dart';

/// A widget for displaying various types of documents, including PDF, TXT, DOC, DOCX, and images.
///
/// The [DocumentViewer] widget takes a [filePath] parameter, which is the path to the document
/// you want to display. It automatically determines the document type based on its extension
/// and provides the appropriate viewer for that type.
///
/// Supported document types:
/// - PDF: Displayed using the [PdfView] widget from the 'pdf_viewer_plugin' package.
/// - TXT, DOC, DOCX: Displayed as text using a [Text] widget after converting the document
///   content from binary (DOCX) or plain text (TXT).
/// - JPEG, JPG, PNG: Displayed as an image using the [PhotoView] widget.
///
/// Example usage:
///
/// dart
/// DocumentViewer(filePath: '/path/to/your/document.pdf')
///
class DocumentViewer extends StatefulWidget {
  /// The path to the document file to be displayed.
  final String filePath;

  /// Creates a [DocumentViewer] widget.
  ///
  /// The [filePath] parameter is required and should be the path to the document file
  /// you want to view.
  const DocumentViewer({Key? key, required this.filePath}) : super(key: key);

  @override
  State<DocumentViewer> createState() => _DocumentViewerState();
}

/// The state class for the [DocumentViewer] widget.
class _DocumentViewerState extends State<DocumentViewer> {
  int columns = 0;
  int rows = 0;
  String filePath = "";

  /// Retrieves the file extension of the document.
  getDocExtension() {
    if (widget.filePath != "") {
      return widget.filePath.substring(
          widget.filePath.lastIndexOf('.')); // To get the file extension
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

  /// Reads the content of a TXT file and updates the [content] variable.
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

  /// Reads the content of a DOCX file and updates the [content] variable.
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
            Expanded(child: PdfView(path: widget.filePath)), // To open the pdf
          ] else if (getDocExtension() == Constants.txt ||
              getDocExtension() == Constants.docx ||
              getDocExtension() == Constants.doc) ...[
            Expanded(
                child: SingleChildScrollView(
                    child: Container(
                        padding: const EdgeInsets.all(20.0),
                        color: Colors.white,
                        child: Text(content)))), // To open docx and doc files
          ] else if (getDocExtension() == Constants.jpeg ||
              getDocExtension() == Constants.jpg ||
              getDocExtension() == Constants.png) ...[
            Expanded(
              child: PhotoView(
                imageProvider: FileImage(File(
                    widget.filePath)), // To view image such as jpg, jpeg, png
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
