import 'package:flutter/material.dart';
import 'package:oppo_gdu/src/data/models/news/news.dart';
import 'package:oppo_gdu/src/ui/views/news/news_list_item_view.dart';
import 'package:oppo_gdu/src/ui/components/navigation/bottom/widget.dart';
import 'package:oppo_gdu/src/ui/components/navigation/drawer/widget.dart';
import '../view_contract.dart';
import '../../components/lists/streamable.dart';
import 'package:oppo_gdu/src/presenters/presenter.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';
import 'package:rxdart/rxdart.dart';
import '../../components/widgets/scaffold.dart';

typedef void NewsListItemOnTapCallback(News news);

abstract class NewsListDelegate extends Presenter
{
    NewsListDelegate(RouterContract router): super(router);

    Observable<News> get stream;

    void onInitState();

    void onDisposeState();

    void didNewsListItemPressed(News news);

    void didFavoritePressed(News news);

    void didUnFavoritePressed(News news);

    void didCommentsPressed(News news);
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
    BottomNavigationController _bottomNavigationBarController;

    @override
    void initState()
    {
        super.initState();

        widget.delegate?.onInitState();

        _bottomNavigationBarController = BottomNavigationController();
        _bottomNavigationBarController.delegate = widget.delegate;
    }

    @override
    void didChangeDependencies()
    {
        super.didChangeDependencies();
    }

    @override
    void didUpdateWidget(NewsListView oldWidget)
    {
        super.didUpdateWidget(oldWidget);
    }

    @override
    void dispose() {
        widget.delegate?.onDisposeState();

        super.dispose();
    }

    @override
    Widget build(BuildContext context)
    {
        return ScaffoldWithBottomNavigation(
            drawerDelegate: widget.delegate,
            drawerCurrentIndex: DrawerNavigationWidget.newsItem,
            bottomNavigationDelegate: widget.delegate,
            bottomNavigationCurrentIndex: BottomNavigationWidget.newsItem,
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
                      return StreamableListView(
                          sortCompare: _newsSortCompare,
                          delegate: widget.delegate as StreamableListViewDelegate,
                          itemBuilder: _buildItem,
                          observable: widget.delegate?.stream,
                      );
                  },
              )
            ),
        );
    }

    int _newsSortCompare(News a, News b)
    {
        if(a.createdAt == null && b.createdAt == null) {
            return 0;
        }

        if(a.createdAt == null) {
            return 1;
        }

        if(b.createdAt == null) {
            return -1;
        }

        return b.createdAt.microsecondsSinceEpoch - a.createdAt.microsecondsSinceEpoch;
    }

    Widget _buildItem(BuildContext context, News news)
    {
        return NewsListItemView(
            news: news,
            delegate: widget.delegate,
        );
    }
}