import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../view_contract.dart';
import 'package:oppo_gdu/src/presenters/news/comments_presenter.dart';
import '../future_contract.dart';
import '../../components/navigation/bottom/widget.dart';
import 'package:oppo_gdu/src/data/models/news/comment.dart';
import 'package:oppo_gdu/src/support/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:oppo_gdu/src/support/datetime/formatter.dart';

class NewsCommentsView extends StatefulWidget implements ViewContract
{
    final NewsCommentsPresenter presenter;

    NewsCommentsView({Key key, this.presenter}): super(key: key);

    @override
    _NewsCommentsViewState createState() => _NewsCommentsViewState();
}

class _NewsCommentsViewState extends State<NewsCommentsView> implements ViewFutureContract<List<Comment>>
{
    List<Comment> _comments;

    bool _isError = false;

    BottomNavigationController _bottomNavigationBarController;

    _NewsCommentsViewState(): super();

    @override
    void initState()
    {
        super.initState();

        _bottomNavigationBarController = BottomNavigationController();
        _bottomNavigationBarController.delegate = widget.presenter;

        widget.presenter?.onInitState(this);
    }

    @override
    void didUpdateWidget(NewsCommentsView oldWidget)
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

    void onLoad(List<Comment> data)
    {
        setState(() {
            _comments = data;
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
        return _comments == null
            ? (_isError ? _buildErrorWidget(context) : _buildLoadingWidget(context))
            : _buildWidget(context);
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

    Widget _buildWidget(BuildContext context)
    {
        return Scaffold(
            body: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                        SliverAppBar(
                            title: Text("Комментарии"),
                            floating: true,
                            snap: true,
                        )
                    ];
                },
                body: Builder(
                    builder: (BuildContext context) {
                        return NotificationListener<UserScrollNotification>(
                            child: _buildCommentsWidget(context),
                            onNotification: _onUserScroll,
                        );
                    },
                )
            ),
            bottomNavigationBar: BottomNavigationWidget(
                controller: _bottomNavigationBarController,
                currentIndex: BottomNavigationWidget.newsItem,
            ),
            floatingActionButton: _buildNewCommentActionWidget(context),
        );
    }

    bool _onUserScroll(UserScrollNotification notification)
    {
        if(notification.direction == ScrollDirection.forward) {
            _bottomNavigationBarController.show();
        }

        if(notification.direction == ScrollDirection.reverse) {
            _bottomNavigationBarController.hide();
        }

        return true;
    }

    Widget _buildCommentsWidget(BuildContext context)
    {
        if(_comments.isEmpty) {
            return Center(
                child: Text("Нет комментариев"),
            );
        } else {
            return ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: _comments.length,
                itemBuilder: _buildCommentItemWidget
            );
        }
    }

    Widget _buildCommentItemWidget(BuildContext context, int index)
    {
        if(_comments == null || index >= _comments.length) {
            return null;
        }

        Comment comment = _comments[index];

        return Card(
            child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: CircleAvatar(
                                backgroundColor: comment.user?.photo == null
                                    ? Utils.avatarBackgroundColor(
                                        comment.user?.firstname?.substring(0, 1) ?? ""
                                    )
                                    : Colors.white,
                                backgroundImage: comment.user?.photo != null
                                    ? CachedNetworkImageProvider(comment.user?.photo)
                                    : null,
                                child: comment.user?.photo == null
                                    ? Text(comment.user?.firstname?.substring(0, 1) ?? "")
                                    : null,
                                radius: 24,
                            ),
                        ),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(
                                    comment.user?.fullname,
                                    style: Theme.of(context).textTheme.headline
                                ),
                                Text(comment.text),
                                Padding(
                                    padding: EdgeInsets.only(top: 16),
                                    child: Text(
                                        DateTimeFormatter.format(comment.createdAt, pattern: "dd.MM.yyyy HH:mm:ss"),
                                        style: Theme.of(context).textTheme.overline
                                    ),
                                )
                            ]
                        )
                    ],
                ),
            ),
        );
    }

    Widget _buildNewCommentActionWidget(BuildContext context)
    {
        return FloatingActionButton(
            onPressed: _onNewCommentPressed,
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.edit, size: 24, color: Colors.white),
        );
    }

    void _onNewCommentPressed()
    {
        widget.presenter?.didNewCommentPressed();
    }
}