import 'package:flutter/material.dart';
import '../view_contract.dart';
import 'package:oppo_gdu/src/presenters/news/news_detail_presenter.dart';
import '../future_contract.dart';
import 'package:oppo_gdu/src/data/models/news/news.dart';
import '../../components/navigation/drawer/widget.dart';
import '../../components/navigation/bottom/widget.dart';

class NewsDetailView extends StatefulWidget implements ViewContract
{
    final NewsDetailPresenter presenter;

    NewsDetailView({Key key, @required this.presenter}): super(key: key);

    @override
    _NewsDetailViewState createState() => _NewsDetailViewState();
}

class _NewsDetailViewState extends State<NewsDetailView> implements ViewFutureContract<News>
{
    News _news;

    @override
    void initState()
    {
        super.initState();

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

    @override
    Widget build(BuildContext context) {
        return _news == null
          ? _buildLoadingWidget(context)
          : _buildWidget(context);
    }

    Widget _buildWidget(BuildContext context)
    {
        return null;
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
}