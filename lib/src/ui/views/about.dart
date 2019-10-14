import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'view_contract.dart';
import 'package:oppo_gdu/src/presenters/about.dart';
import 'future_contract.dart';
import 'package:oppo_gdu/src/data/models/news/news.dart';
import '../components/navigation/drawer/widget.dart';
import '../components/navigation/bottom/widget.dart';
import 'package:oppo_gdu/src/support/datetime/formatter.dart';
import 'package:share/share.dart';
import '../components/markdown/markdown.dart';
import 'package:oppo_gdu/src/support/url.dart' as UrlService;
import '../components/widgets/loading.dart';
import '../components/widgets/empty.dart';
import '../components/widgets/scaffold.dart';
import '../components/widgets/scrolled_title.dart';

class AboutView extends StatefulWidget implements ViewContract
{
    final AboutPresenter presenter;

    AboutView({Key key, @required this.presenter}): super(key: key);

    @override
    _AboutViewState createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> implements ViewFutureContract<News>
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
    void didUpdateWidget(AboutView oldWidget)
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
            drawerDelegate: widget.presenter,
            drawerCurrentIndex: DrawerNavigationWidget.aboutItem,
            bottomNavigationDelegate: widget.presenter,
            bottomNavigationCurrentIndex: BottomNavigationWidget.newsItem,
            body: CustomScrollViewWithScrolledTitle(
                title: 'Об организации',
                subTitle: Text(
                    'ОППО Газпром Добыча Уренгой Профсоюз',
                    style: Theme.of(context).textTheme.overline,
                ),
                children: [
                    Padding(
                        padding: EdgeInsets.all(16),
                        child: _bodyWidget,
                    )
                ],
                onRefresh: _onRefresh,
            )
        );
    }

    Future<void> _onRefresh() async
    {
        await widget.presenter?.didRefresh();
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

    void _onTapBodyImage(String src, String title, String alt)
    {
        widget.presenter?.router?.presentSinglePhoto(src, title: title);
    }

    void _onTapBodyLink(String href)
    {
        UrlService.launchUrl(href);
    }
}