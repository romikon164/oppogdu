import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../view_contract.dart';
import 'package:oppo_gdu/src/presenters/news/news_detail_presenter.dart';
import '../future_contract.dart';
import 'package:oppo_gdu/src/data/models/news/news.dart';
import '../../components/navigation/bottom/widget.dart';
import 'package:oppo_gdu/src/support/datetime/formatter.dart';
import 'package:share/share.dart';
import '../../components/markdown/markdown.dart';
import 'package:oppo_gdu/src/support/url.dart' as UrlService;
import '../../components/widgets/loading.dart';
import '../../components/widgets/empty.dart';
import '../../components/widgets/scaffold.dart';
import '../../components/widgets/scrolled_title.dart';

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

    bool _isError = false;

    MarkDownComponent _bodyWidget;

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
        if(_bodyWidget == null) {
            _bodyWidget = MarkDownComponent(
                data: _news.content,
                onTapImage: _onTapBodyImage,
                onTapLink: _onTapBodyLink,
            );
        }

        return ScaffoldWithBottomNavigation(
            includeDrawer: false,
            bottomNavigationDelegate: widget.presenter,
            bottomNavigationCurrentIndex: BottomNavigationWidget.newsItem,
            body: CustomScrollViewWithScrolledTitle(
                title: _news.name,
                image: _news.image,
                subTitle: Text(
                    "Опубликовано " + DateTimeFormatter.format(_news.createdAt),
                    style: Theme.of(context).textTheme.overline,
                ),
                children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: _buildNewsToolBar(context),
                        ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(16),
                        child: _bodyWidget,
                    )
                ],
                onRefresh: _onRefresh,
            )
        );
    }

    Widget _buildLoadingWidget(BuildContext context)
    {
        return LoadingWidget(
            includeDrawer: false,
            bottomNavigationDelegate: widget.presenter,
            bottomNavigationCurrentIndex: BottomNavigationWidget.newsItem
        );
    }

    Widget _buildErrorWidget(BuildContext context)
    {
        return EmptyWidget(
            includeDrawer: false,
            bottomNavigationDelegate: widget.presenter,
            bottomNavigationCurrentIndex: BottomNavigationWidget.newsItem,
            appBarTitle: 'Ошибка',
            emptyMessage: 'Возникла ошибка при загрузке данных',
        );
    }

    List<Widget> _buildNewsToolBar(BuildContext context)
    {
        List<Widget> actions = [];

        if(_news.isFavorited) {
            actions.add(
                FlatButton.icon(
                    onPressed: () {
                        setState(() {
                            _news.isFavorited = false;
                            _news.favoritesCount--;
                            widget.presenter?.didUnFavoritePressed();
                        });
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
                        setState(() {
                            _news.isFavorited = true;
                            _news.favoritesCount++;
                            widget.presenter?.didFavoritePressed();
                        });
                    },
                    icon: Icon(Icons.favorite_border, color: Color(0xFF9B9B9B)),
                    label: Text(
                        "${_news.favoritesCount}",
                        style: Theme.of(context).textTheme.button
                    ),
                )
            );
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
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
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
        await widget.presenter?.didRefresh();
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