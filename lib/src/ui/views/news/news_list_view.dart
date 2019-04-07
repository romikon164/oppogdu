import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:oppo_gdu/src/presenters/news/news_list_presenter.dart';
import 'package:oppo_gdu/src/data/models/news/news.dart';
import 'package:oppo_gdu/src/ui/views/news/news_list_item_view.dart';
import 'package:oppo_gdu/src/ui/views/news/news_list_item_without_image_view.dart';
import 'package:oppo_gdu/src/ui/views/news/news_list_view_delegate.dart';
import 'package:oppo_gdu/src/ui/components/bottom_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:oppo_gdu/src/ui/components/main_menu_component.dart';

typedef void NewsListItemOnTapCallback(News news);

class NewsListView extends StatefulWidget
{
    final NewsListPresenter presenter;

    NewsListView({Key key, @required this.presenter}): super(key: key)
    {
        presenter.view = this;
    }

    @override
    _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsListView> implements NewsListViewDelegate
{
    List<News> news = [];

    bool _isFinish = false;
    bool _isError = false;

    AnimatedBottomNavigationBarController _bottomNavigationBarController;

    @override
    void initState()
    {
        super.initState();

        widget.presenter?.viewDelegate = this;
        widget.presenter?.didInitState();

        _bottomNavigationBarController = AnimatedBottomNavigationBarController();
        _bottomNavigationBarController.delegate = widget.presenter;
    }

    @override
    void didUpdateWidget(NewsListView oldWidget)
    {
        super.didUpdateWidget(oldWidget);

        widget.presenter?.viewDelegate = this;
    }

    @override
    void dispose() {
        widget.presenter?.viewDelegate = null;

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
                            title: Text(widget.presenter?.configuration?.title),
                            floating: true,
                            snap: true,
                            backgroundColor: Theme.of(context).appBarTheme.color,
                            brightness: Theme.of(context).appBarTheme.brightness,
                            iconTheme: Theme.of(context).appBarTheme.iconTheme,
                            textTheme: Theme.of(context).appBarTheme.textTheme,
                        )
                    ];
                },
                body: Builder(
                    builder: (BuildContext context) {
                        return NotificationListener<ScrollNotification>(
                            child: RefreshIndicator(
                                child: CustomScrollView(
                                    slivers: [
                                        SliverList(
                                            delegate: SliverChildBuilderDelegate(_buildItem),
                                        )
                                    ],
                                ),
                                onRefresh: _didRefresh
                            ),
                            onNotification: _didScrollNotification,
                        );
                    },
                )
            ),
            bottomNavigationBar: AnimatedBottomNavigationBar(
                controller: _bottomNavigationBarController,
                currentIndex: AnimatedBottomNavigationBar.newsItem,
            ),
            drawer: MainMenuComponent(
                delegate: widget.presenter,
                currentIndex: MainMenuComponent.newsItem
            ),
        );
    }

    bool _didScrollNotification(ScrollNotification scrollNotification) {
        if(scrollNotification is UserScrollNotification) {
            _onUserScroll(scrollNotification);
        }

        if(scrollNotification is ScrollUpdateNotification) {
            _onUpdateScroll(scrollNotification);
        }

        return true;
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

    void _onUpdateScroll(ScrollUpdateNotification notification)
    {
        if(notification.metrics.pixels >= notification.metrics.maxScrollExtent) {
            if(!_isFinish && !_isError) {
                widget.presenter?.didLoad();
            }
        }
    }

    Future<void> _didRefresh() async
    {
        news = [];
        await widget.presenter?.didRefresh();
    }

    void onLoadComplete(List<News> newNews)
    {
        setState(() {
            news = newNews;
            _isError = false;
            _isFinish = false;
        });
    }

    void onLoadFinish()
    {
        setState(() {
            _isFinish = true;
            _isError = false;
        });
    }

    void onLoadFail()
    {
        setState(() {
            _isError = true;
            _isFinish = false;
        });
    }

    Widget _buildItem(BuildContext context, int index)
    {
        if(index >= news.length) {
            return _buildFooter(context, index);
        }

        News newsItem = news[index];

        return newsItem.thumb == null
            ? NewsListItemWithoutImageView(news: newsItem, onTap: widget.presenter?.didTapListItem)
            : NewsListItemView(news: newsItem, onTap: widget.presenter?.didTapListItem);
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