import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import '../components/widgets/loading.dart';
import '../components/widgets/empty.dart';
import '../components/widgets/scaffold.dart';

import 'dart:async';
import 'dart:io';

class PdfViewWidget extends StatefulWidget
{
    final title;

    final String url;

    PdfViewWidget({Key key, this.title, this.url}): super(key: key);

    @override
    _PdfViewState createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfViewWidget>
{
    bool _isLoading = true;

    bool _isError = false;

    File _pdfFile;

    @override
    void initState()
    {
        super.initState();

        _isLoading = true;
        _isError = false;

        createFileOfPdfUrl().then((file) {
            setState(() {
                _pdfFile = file;
                _isLoading = false;
                _isError = false;
            });
        }).catchError((_) {
            setState(() {
                _isLoading = false;
                _isError = true;
            });
        });
    }

    @override
    Widget build(BuildContext context) {
        return _pdfFile == null
            ? (_isError ? _buildErrorWidget(context) : _buildLoadingWidget(context))
            : _buildWidget(context);
    }

    Widget _buildLoadingWidget(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(title: Text("Загрузка")),
            body: Center(
                child: CircularProgressIndicator(),
            ),
        );
    }

    Widget _buildErrorWidget(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(title: Text("Ошибка")),
            body: Center(
                child: Text('Возникла ошибка при загрузке данных'),
            ),
        );
    }

    Widget _buildWidget(BuildContext context)
    {
        return PDFViewerScaffold(
            appBar: AppBar(
                title: Text(widget.title),
                actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () {
                            _downloadFile();
                        },
                    ),
                ],
            ),
            path: _pdfFile.path);
    }

    Future<File> createFileOfPdfUrl() async {
        final url = widget.url;
        final filename = url.substring(url.lastIndexOf("/") + 1);

        String dir = (await getApplicationDocumentsDirectory()).path;
        Directory directory = Directory('$dir/documents');
        if(!directory.existsSync()) {
            directory.create(recursive: true);
        }

        _pdfFile = new File('$dir/documents/$filename');

        if(!_pdfFile.existsSync()) {
            var request = await HttpClient().getUrl(Uri.parse(url));
            var response = await request.close();
            var bytes = await consolidateHttpClientResponseBytes(response);
            await _pdfFile.writeAsBytes(bytes);
        }

        print(_pdfFile.path);

        return _pdfFile;
    }

    Future<void> _downloadFile() async
    {
        if(await _checkPermission()) {
            String _localPath = (await _findLocalPath()) + '/Download';

            final savedDir = Directory(_localPath);

            if (!savedDir.existsSync()) {
                savedDir.create();
            }

            await FlutterDownloader.enqueue(
                url: widget.url,
                savedDir: _localPath,
                showNotification: true,
                openFileFromNotification: true
            );
        }
    }

    Future<String> _findLocalPath() async {
        final directory = Platform.isAndroid
            ? await getExternalStorageDirectory()
            : await getApplicationDocumentsDirectory();
        return directory.path;
    }

    Future<bool> _checkPermission() async {
        if (Platform.isAndroid) {
            PermissionStatus permission = await PermissionHandler()
                .checkPermissionStatus(PermissionGroup.storage);
            if (permission != PermissionStatus.granted) {
                Map<PermissionGroup, PermissionStatus> permissions =
                await PermissionHandler()
                    .requestPermissions([PermissionGroup.storage]);
                if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
                    return true;
                }
            } else {
                return true;
            }
        } else {
            return true;
        }
        return false;
    }
}