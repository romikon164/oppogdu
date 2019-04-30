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
import 'package:oppo_gdu/src/support/auth/service.dart';
import '../../flutter_fixes/bottom_sheet.dart' as FlutterFixBottomSheet;
import 'package:fluttertoast/fluttertoast.dart';

abstract class NewsCommentsDelegate implements ViewFutureContract<List<Comment>>
{
    void onCommentSuccess(Comment comment);

    Future<void> onCommentError();
}

class NewsCommentsView extends StatefulWidget implements ViewContract
{
    final NewsCommentsPresenter presenter;

    NewsCommentsView({Key key, this.presenter}): super(key: key);

    @override
    _NewsCommentsViewState createState() => _NewsCommentsViewState();
}

class _NewsCommentsViewState extends State<NewsCommentsView> implements NewsCommentsDelegate
{
    List<Comment> _comments;

    bool _isError = false;

    BottomNavigationController _bottomNavigationBarController;

    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    bool _showNewCommentForm = false;

    bool _loading = false;

    String _message;

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

    void onCommentSuccess(Comment comment)
    {
        _closeLoadingIndicator();

        widget.presenter?.router?.pop();

        setState(() {
            _comments.add(comment);
        });
    }

    Future<void> onCommentError() async
    {
        _closeLoadingIndicator();

        await Fluttertoast.cancel();

        Fluttertoast.showToast(
            msg: "Возникла ошибка при отправке данных",
            fontSize: 12,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 3,
        );
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
            key: _scaffoldKey,
            appBar: AppBar(
                title: Text("Загрузка"),
            ),
            body: Center(
                child: CircularProgressIndicator(),
            ),
            bottomNavigationBar: BottomNavigationWidget(
                controller: _bottomNavigationBarController,
                currentIndex: BottomNavigationWidget.newsItem
            ),
            resizeToAvoidBottomPadding: true,
            resizeToAvoidBottomInset: true,
        );
    }

    Widget _buildErrorWidget(BuildContext context)
    {
        return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
                title: Text("Ошибка"),
            ),
            body: Center(
                child: Text(
                    "Возникла ошибка при загрузке данных"
                ),
            ),
            bottomNavigationBar: BottomNavigationWidget(
                controller: _bottomNavigationBarController,
                currentIndex: BottomNavigationWidget.newsItem
            ),
            resizeToAvoidBottomPadding: true,
            resizeToAvoidBottomInset: true,
        );
    }

    Widget _buildWidget(BuildContext context)
    {
        return Scaffold(
            key: _scaffoldKey,
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
                        return RefreshIndicator(
                            child: NotificationListener<UserScrollNotification>(
                                child: _buildCommentsWidget(context),
                                onNotification: _onUserScroll,
                            ),
                            onRefresh: _onRefresh,
                        );
                    },
                )
            ),
            bottomNavigationBar: BottomNavigationWidget(
                controller: _bottomNavigationBarController,
                currentIndex: BottomNavigationWidget.newsItem,
            ),
            floatingActionButton: _buildNewCommentActionWidget(context),
            resizeToAvoidBottomPadding: true,
            resizeToAvoidBottomInset: true,
        );
    }

    bool _onUserScroll(UserScrollNotification notification)
    {
        if(notification.direction == ScrollDirection.forward && !_showNewCommentForm) {
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
                itemBuilder: _buildCommentItemWidget,
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
        return AuthService.instance.isAuthenticated() && !_showNewCommentForm
            ? FloatingActionButton(
                onPressed: _onNewCommentPressed,
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(Icons.edit, size: 24, color: Colors.white),
            )
            : null;
    }

    void _onNewCommentPressed()
    {
        if(_showNewCommentForm) {
            return ;
        }

        // widget.presenter?.didNewCommentPressed();
        _bottomNavigationBarController.hide();

        setState(() {
            _showNewCommentForm = true;
        });

        FlutterFixBottomSheet.showModalBottomSheet(context: context, builder: (BuildContext context) {
            return Form(
                key: _formKey,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        new Padding(
                            padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                            child: TextFormField(
                                autofocus: true,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                    labelText: "Текст комментария",
                                ),
                                style: Theme.of(context).textTheme.button,
                                validator: (String message) {
                                    if(message.isEmpty) {
                                        return "Укажите текст комментария";
                                    }

                                    return null;
                                },
                                onSaved: (String message) {
                                    _message = message;
                                },
                            ),
                        ),
                        new Padding(
                            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
                            child: RaisedButton(
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                    FocusScope.of(context).requestFocus(FocusNode());

                                    if(_formKey.currentState.validate()) {

                                        _showLoadingIndicator(context);

                                        _formKey.currentState.save();

                                        widget.presenter?.didNewCommentPressed(_message);
                                    }
                                },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        Text("Отправить", style: TextStyle(color: Colors.white)),
                                        Container(width: 8),
                                        Icon(Icons.exit_to_app, color: Colors.white)
                                    ],
                                ),
                            ),
                        )
                    ],
                ),
            );
        }).then((dynamic _) {
            setState(() {
                _showNewCommentForm = false;
                _bottomNavigationBarController.show();
            });
        });
    }

    void _showLoadingIndicator(BuildContext context)
    {
        if(!_loading) {
            _loading = true;

            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                    return Dialog(
                        child: Container(
                            height: 80,
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Padding(
                                        padding: EdgeInsets.all(16),
                                        child: CircularProgressIndicator(),
                                    ),
                                    Text("Пожалуйста, подождите"),
                                ],
                            ),
                        ),
                    );
                }
            );
        }
    }

    void _closeLoadingIndicator()
    {
        if(_loading) {
            widget.presenter?.router?.pop();

            _loading = false;
        }
    }

    Future<void> _onRefresh() async
    {
        widget.presenter?.didRefresh();
    }
}