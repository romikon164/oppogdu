import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../view_contract.dart';
import 'package:oppo_gdu/src/presenters/news/news_detail_presenter.dart';
import '../future_contract.dart';
import 'package:oppo_gdu/src/data/models/news/news.dart';
import '../../components/navigation/bottom/widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:oppo_gdu/src/support/datetime/formatter.dart';
import 'package:oppo_gdu/src/support/auth/service.dart';
import 'package:share/share.dart';
import '../../components/markdown/markdown.dart';
import 'package:oppo_gdu/src/support/url.dart' as UrlService;

class NewsDetailView extends StatefulWidget implements ViewContract
{
    final NewsDetailPresenter presenter;

    NewsDetailView({Key key, @required this.presenter}): super(key: key);

    @override
    _NewsDetailViewState createState() => _NewsDetailViewState();
}

class _NewsDetailViewState extends State<NewsDetailView> implements ViewFutureContract<News>
{
    BottomNavigationController _bottomNavigationBarController;

    News _news;

    bool _isError = false;

    double _flexibleSpaceHeight = 200.0;

    bool _appBarTitleVisibled = false;

    double _appBarTitleMarginTop = 0;

    double _bodyTitleMarginTop = 16;

    @override
    void initState()
    {
        super.initState();

        _bottomNavigationBarController = BottomNavigationController();
        _bottomNavigationBarController.delegate = widget.presenter;

        widget.presenter?.onInitState(this);
    }

    @override
    void didUpdateWidget(NewsDetailView oldWidget)
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

    void onLoad(News data)
    {
        setState(() {
            _news = data;
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
        return _news == null
          ? (_isError ? _buildErrorWidget(context) : _buildLoadingWidget(context))
          : _buildWidget(context);
    }

    Widget _buildWidget(BuildContext context)
    {
//        SystemChrome.setSystemUIOverlayStyle(
//            SystemUiOverlayStyle.light.copyWith(
//                statusBarColor: Colors.transparent,
//                statusBarIconBrightness: Theme.of(context).brightness
//            )
//        );

        return Scaffold(
            body: NotificationListener<ScrollNotification>(
                child: RefreshIndicator(
                    child: CustomScrollView(
                        slivers: [
                            SliverAppBar(
                                centerTitle: false,
                                expandedHeight: _flexibleSpaceHeight,
                                floating: false,
                                pinned: true,
                                title: _buildAppBarTitle(context),
                                flexibleSpace: FlexibleSpaceBar(
                                    background: Image(
                                        image: CachedNetworkImageProvider(_news.image),
                                        fit: BoxFit.cover,
                                    ),
                                ),
                            ),
                            SliverToBoxAdapter(
                                child: Card(
                                    child: Padding(
                                        padding: EdgeInsets.all(_bodyTitleMarginTop),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                Text(
                                                    _news.name,
                                                    style: Theme.of(context).textTheme.headline,
                                                ),
                                                Container(height: 8),
                                                Text(
                                                    "Опубликованно " + DateTimeFormatter.format(_news.createdAt),
                                                    style: Theme.of(context).textTheme.overline,
                                                )
                                            ],
                                        ),
                                    ),
                                ),
                            ),
                            SliverToBoxAdapter(
                                child: Card(
                                    child: Padding(
                                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: _buildNewsToolBar(context),
                                        ),
                                    ),
                                ),
                            ),
                            SliverToBoxAdapter(
                                child: Card(
                                    child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: MarkDownComponent(
                                            data: _news.content,
                                            onTapImage: _onTapBodyImage,
                                            onTapLink: _onTapBodyLink,
                                        ),
                                    )
                                ),
                            )
                        ],
                    ),
                    onRefresh: _onRefresh
                ),
                onNotification: _onScrollNotification,
            ),
            bottomNavigationBar: BottomNavigationWidget(
                controller: _bottomNavigationBarController,
                currentIndex: BottomNavigationWidget.newsItem,
            ),
        );
    }

    Widget _buildLoadingWidget(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(
                title: Text("Загрузка"),
            ),
            body: Center(
                child: CircularProgressIndicator(),
            ),
            bottomNavigationBar: BottomNavigationWidget(currentIndex: BottomNavigationWidget.newsItem),
        );
    }

    Widget _buildErrorWidget(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(
                title: Text("Ошибка"),
            ),
            body: Center(
                child: Text(
                    "Возникла ошибка при загрузке данных"
                ),
            ),
            bottomNavigationBar: BottomNavigationWidget(currentIndex: BottomNavigationWidget.newsItem),
        );
    }

    Widget _buildAppBarTitle(BuildContext context)
    {
        if(_appBarTitleVisibled) {
            return ClipRect(
                child: Padding(
                    padding: EdgeInsets.only(top: _appBarTitleMarginTop),
                    child: Text(_news.name, textScaleFactor: 0.6),
                ),
            );
        }

        return null;
    }

    List<Widget> _buildNewsToolBar(BuildContext context)
    {
        List<Widget> actions = [];

        if(AuthService.instance.isAuthenticated()) {
            if(_news.isFavorited) {
                actions.add(
                    FlatButton.icon(
                        onPressed: () {
                            widget.presenter?.didUnFavoritePressed();
                        },
                        icon: Icon(Icons.favorite, color: Colors.red),
                        label: Text(
                            "${_news.favoritesCount}",
                            style: Theme.of(context).textTheme.button
                        ),
                    )
                );
            } else {
                actions.add(
                    FlatButton.icon(
                        onPressed: () {
                            widget.presenter?.didFavoritePressed();
                        },
                        icon: Icon(Icons.favorite_border, color: Color(0xFF9B9B9B)),
                        label: Text(
                            "${_news.favoritesCount}",
                            style: Theme.of(context).textTheme.button
                        ),
                    )
                );
            }
        }

        actions.add(
            FlatButton.icon(
                onPressed: () {
                    widget.presenter?.didCommentsPressed();
                },
                icon: Icon(Icons.forum, color: Color(0xFF9B9B9B)),
                label: Text("${_news.commentsCount}", style: Theme.of(context).textTheme.button)
            )
        );

        actions.add(
            FlatButton.icon(
                onPressed: () {
                    Share.share(
                        "${_news.name} ${_news.sharedUrl}"
                    );
                },
                icon: Icon(Icons.share, color: Color(0xFF9B9B9B)),
                label: Text("", style: Theme.of(context).textTheme.button)
            )
        );

        actions.add(
            Padding(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Icon(Icons.remove_red_eye, color: Color(0xFF9B9B9B)),
                        Container(width: 8),
                        Text("${_news.viewsCount}", style: Theme.of(context).textTheme.button)
                    ],
                ),
            )
        );

        return actions;
    }

    Future<void> _onRefresh() async
    {
        // TODO
    }

    bool _onScrollNotification(ScrollNotification notification)
    {
        double scrollTop = notification.metrics.pixels;

        if(scrollTop > _flexibleSpaceHeight - kToolbarHeight + _bodyTitleMarginTop) {
            if(!_appBarTitleVisibled) {
                setState(() {
                    _appBarTitleVisibled = true;
                    _appBarTitleMarginTop = kToolbarHeight;
                });
            } else {
                setState(() {
                    _appBarTitleMarginTop = _flexibleSpaceHeight - scrollTop + _bodyTitleMarginTop;

                    if(_appBarTitleMarginTop < 0) {
                        _appBarTitleMarginTop = 0;
                    }
                });
            }
        } else {
            if (_appBarTitleVisibled) {
                setState(() {
                    _appBarTitleVisibled = false;
                });
            }
        }

        if(notification is UserScrollNotification) {
            if(notification.direction == ScrollDirection.forward) {
                _bottomNavigationBarController.show();
            }

            if(notification.direction == ScrollDirection.reverse) {
                _bottomNavigationBarController.hide();
            }
        }

        return true;
    }

    void _onTapBodyImage(String src, String title, String alt)
    {
        widget.presenter?.router?.presentSinglePhoto(src, title: title);
    }

    void _onTapBodyLink(String href)
    {
        UrlService.launchUrl(href);
    }
}