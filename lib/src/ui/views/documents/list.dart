import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../view_contract.dart';
import 'package:oppo_gdu/src/presenters/documents/list.dart';
import '../future_contract.dart';
import '../../components/navigation/drawer/widget.dart';
import 'package:oppo_gdu/src/data/models/documents/document.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../components/widgets/loading.dart';
import '../../components/widgets/empty.dart';
import '../../components/widgets/scaffold.dart';
import 'package:oppo_gdu/src/support/datetime/formatter.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:oppo_gdu/src/consts.dart';
import '../pdf.dart';

class DocumentListView extends StatefulWidget implements ViewContract
{
    final DocumentListPresenter presenter;

    DocumentListView({Key key, this.presenter}): super(key: key);

    @override
    _DocumentListViewState createState() => _DocumentListViewState();
}

class _DocumentListViewState extends State<DocumentListView> implements ViewFutureContract<List<Document>>
{
    List<Document> _documents;

    bool _isError = false;

    String _noPhotoUrl = 'http://api.oppo-gdu.ru/img/prints-no-photo.png';

    _DocumentListViewState(): super();

    @override
    void initState()
    {
        super.initState();

        widget.presenter?.onInitState(this);
    }

    @override
    void didUpdateWidget(DocumentListView oldWidget)
    {
        super.didUpdateWidget(oldWidget);

        widget.presenter?.onInitState(this);
    }

    @override
    void didChangeDependencies()
    {
        super.didChangeDependencies();

        widget.presenter?.onInitState(this);
    }

    void onLoad(List<Document> data)
    {
        setState(() {
            _documents = data;
        });
    }

    void onError()
    {
        setState(() {
            _isError = true;
        });
    }

    @override
    Widget build(BuildContext context) {
        return _documents == null
            ? (_isError ? _buildErrorWidget(context) : _buildLoadingWidget(context))
            : _buildWidget(context);
    }

    Widget _buildLoadingWidget(BuildContext context)
    {
        return LoadingWidget(
            drawerDelegate: widget.presenter,
            drawerCurrentIndex: DrawerNavigationWidget.videosItem,
            bottomNavigationDelegate: widget.presenter,
        );
    }

    Widget _buildErrorWidget(BuildContext context)
    {
        return EmptyWidget(
            drawerDelegate: widget.presenter,
            drawerCurrentIndex: DrawerNavigationWidget.videosItem,
            bottomNavigationDelegate: widget.presenter,
            appBarTitle: 'Ошибка',
            emptyMessage: 'Возникла ошибка при загрузке данных',
        );
    }

    Widget _buildWidget(BuildContext context)
    {
        int drawerMenuItem = 0;

        if(widget.presenter.documentsType == DocumentTypes.PRINTS) {
            drawerMenuItem = DrawerNavigationWidget.printsItem;
        } else if(widget.presenter.documentsType == DocumentTypes.ACTS) {
            drawerMenuItem = DrawerNavigationWidget.regulationsItem;
        }

        return ScaffoldWithBottomNavigation(
            drawerDelegate: widget.presenter,
            drawerCurrentIndex: drawerMenuItem,
            bottomNavigationDelegate: widget.presenter,
            body: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                        _buildAppBar(context)
                    ];
                },
                body: Builder(
                    builder: (BuildContext context) {
                        return RefreshIndicator(
                            child: _buildDocumentsWidget(context),
                            onRefresh: _onRefresh,
                        );
                    },
                )
            ),
        );
    }

    Widget _buildAppBar(BuildContext context)
    {
        String title = "Документы";

        if(widget.presenter.documentsType == DocumentTypes.PRINTS) {
            title = "Печатные издания";
        } else if(widget.presenter.documentsType == DocumentTypes.PRINTS) {
            title = "Нормативные акты";
        }

        return SliverAppBar(
            title: Text(title),
            floating: true,
            snap: true,
        );
    }

    Widget _buildDocumentsWidget(BuildContext context)
    {
        if(_documents.isEmpty) {
            return Center(
                child: Text("Нет видеозаписей"),
            );
        } else {
            return ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: _documents.length,
                itemBuilder: _buildDocumentItemWidget,
            );
        }
    }

    Widget _buildDocumentItemWidget(BuildContext context, int index)
    {
        if(_documents == null || index >= _documents.length) {
            return null;
        }

        Document document = _documents[index];

        List<Widget> widgets = [
            Padding(
                padding: EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Text(
                    document.name,
                    style: Theme.of(context).textTheme.headline,
                ),
            )
        ];

        if(document.createdAt != null) {
            widgets.add(
                Padding(
                    padding: EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: Text(
                        "Опубликованно " + DateTimeFormatter.format(document.createdAt),
                        style: Theme.of(context).textTheme.overline
                    ),
                )
            );
        }

        if(document.description != null && document.description.isNotEmpty) {
            widgets.add(
                Padding(
                    padding: EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: Text(
                        document.description,
                        style: Theme.of(context).textTheme.overline
                    ),
                )
            );
        }

        return Card(
            child: InkWell(
                onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => PdfViewWidget(title: document.name, url: document.url)
                        )
                    );

                },
                child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Flexible(
                            child: Container(
                                width: 120,
                                height: 120,
                                child: CachedNetworkImage(
                                    imageUrl: document.thumb ?? _noPhotoUrl,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover
                                ),
                            ),
                            flex: 0,
                            fit: FlexFit.tight,
                        ),
                        Flexible(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: widgets,
                            ),
                            flex: 1,
                            fit: FlexFit.loose,
                        )
                    ],
                )
            ),
        );
    }

    Future<void> _onRefresh() async
    {
        widget.presenter?.didRefresh();
    }
}