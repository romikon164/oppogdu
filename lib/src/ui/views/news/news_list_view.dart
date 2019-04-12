import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:oppo_gdu/src/presenters/news/news_list_presenter.dart';
import 'package:oppo_gdu/src/presenters/streamable_listenable_contract.dart';
import 'package:oppo_gdu/src/data/models/news/news.dart';
import 'package:oppo_gdu/src/ui/views/news/news_list_item_view.dart';
import 'package:oppo_gdu/src/ui/views/news/news_list_item_without_image_view.dart';
import 'package:oppo_gdu/src/ui/components/navigation/bottom/widget.dart';
import 'package:oppo_gdu/src/ui/components/navigation/drawer/widget.dart';
import '../view_contract.dart';
import '../streamable_delegate.dart';
import 'package:oppo_gdu/src/presenters/streamable_contract.dart';
import '../../components/lists/streamable.dart';
import 'package:oppo_gdu/src/presenters/presenter.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';

typedef void NewsListItemOnTapCallback(News news);

abstract class NewsListDelegate extends Presenter
{
    NewsListDelegate(RouterContract router): super(router);

    void onInitState();
}

class NewsListView extends StatefulWidget implements ViewContract
{
    final NewsListDelegate delegate;

    NewsListView({Key key, @required this.delegate}): super(key: key);

    @override
    _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsListView>
{
    Stream<News> _stream;

    StreamSubscription<News> _subscription;

    List<News> _newsList = [];

    bool _isLoading = false;
    bool _isFinish = false;
    bool _isError = false;

    BottomNavigationController _bottomNavigationBarController;

    set stream(Stream<News> newStream)
    {
        if(_subscription != null) {
            _subscription.cancel();
        }

        _stream = newStream;
        _subscription = _stream.listen((newsItem) {
            setState(() {
                _newsList.add(newsItem);
            });
        }, onDone: () {
            setState(() {
                _isFinish = true;
                _isError = false;
            });
        }, onError: () {
            setState(() {
                _isError = true;
            });
        });
    }

    @override
    void initState()
    {
        super.initState();

        widget.presenter?.onInitState(this);

        _bottomNavigationBarController = AnimatedBottomNavigationBarController();
        _bottomNavigationBarController.delegate = widget.presenter;
    }

    @override
    void didChangeDependencies()
    {
        super.didChangeDependencies();
        widget.presenter?.onInitState(this);
    }

    @override
    void didUpdateWidget(NewsListView oldWidget)
    {
        super.didUpdateWidget(oldWidget);

        widget.presenter?.onInitState(this);
    }

    @override
    void dispose() {
        widget.presenter?.onDisposeState();

        super.dispose();
    }

    @override
    Widget build(BuildContext context)
    {
        SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Theme.of(context).appBarTheme.color,
            )
        );

        return Scaffold(
            body: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                        SliverAppBar(
                            title: Text("Новости"),
                            floating: true,
                            snap: true,
                        )
                    ];
                },
                body: Builder(
                    builder: (BuildContext context) {
                        return NotificationListener<UserScrollNotification>(
                            child: StreamableListView(
                                sortCompare: _newsSortCompare,
                                delegate: widget?.presenter,
                                itemBuilder: _buildItem,
                                observable: null
                            ),
                            onNotification: _onUserScroll,
                        );
                    },
                )
            ),
            bottomNavigationBar: BottomNavigationWidget(
                controller: _bottomNavigationBarController,
                currentIndex: BottomNavigationWidget.newsItem,
            ),
            drawer: DrawerNavigationWidget(
                delegate: widget.presenter,
                currentIndex: DrawerNavigationWidget.newsItem
            ),
        );
    }

    void _onUserScroll(UserScrollNotification notification)
    {
        if(notification.direction == ScrollDirection.forward) {
            _bottomNavigationBarController.show();
        }

        if(notification.direction == ScrollDirection.reverse) {
            _bottomNavigationBarController.hide();
        }
    }

    Widget _buildItem(BuildContext context, News news)
    {
        return news.thumb == null
            ? NewsListItemWithoutImageView(news: news)
            : NewsListItemView(news: news);
    }

    Widget _buildFooter(BuildContext context, int index)
    {
        if(_isFinish) {
            return null;
        }

        if(index == news.length) {

            if(_isError) {
                return _buildErrorMessage(context);
            }

            return _buildProgressIndicator(context);

        }

        return null;
    }

    Widget _buildErrorMessage(BuildContext context)
    {
        return Container(
            width: MediaQuery.of(context).size.width,
            height: 48,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                    Text(widget.presenter?.configuration?.errorMessage),
                    InkWell(
                        onTap: () {
                            setState(() {
                                _isError = false;
                                _isFinish = false;
                                widget.presenter?.didLoad();
                            });
                        },
                        child: Text(widget.presenter?.configuration?.updateLabel),
                    )
                ],
            ),
        );
    }

    Widget _buildProgressIndicator(BuildContext context)
    {
        return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 48,
            child: Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
            ),
        );
    }
}