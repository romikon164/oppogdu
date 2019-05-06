import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:oppo_gdu/src/presenters/news/comments_presenter.dart';
import 'package:oppo_gdu/src/data/models/news/comment.dart';
import 'package:oppo_gdu/src/support/auth/service.dart';
import '../../components/navigation/bottom/widget.dart';
import '../../flutter_fixes/bottom_sheet.dart' as FlutterFixBottomSheet;
import '../../components/widgets/loading.dart';
import '../../components/widgets/empty.dart';
import '../../components/widgets/scaffold.dart';
import '../view_contract.dart';
import '../future_contract.dart';
import 'send_comment.dart';
import 'comment_item.dart';

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

    bool _showNewCommentForm = false;

    _NewsCommentsViewState(): super();

    @override
    void initState()
    {
        super.initState();

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

    Widget _buildWidget(BuildContext context)
    {
        return ScaffoldWithBottomNavigation(
            includeDrawer: false,
            includeBottomNavigationBar: !_showNewCommentForm,
            bottomNavigationDelegate: widget.presenter,
            bottomNavigationCurrentIndex: BottomNavigationWidget.newsItem,
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
                            child: _buildCommentsWidget(context),
                            onRefresh: _onRefresh,
                        );
                    },
                )
            ),
            floatingActionButton: _buildNewCommentActionWidget(context)
        );
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
        if(index >= _comments.length) {
            return null;
        }

        return CommentItemWidget(comment: _comments[index]);
    }

    Widget _buildNewCommentActionWidget(BuildContext context)
    {
        if(AuthService.instance.isAuthenticated() && !_showNewCommentForm) {
            return FloatingActionButton(
                onPressed: _onNewCommentPressed,
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(Icons.edit, size: 24, color: Colors.white),
            );
        }

        return null;
    }

    void _onNewCommentPressed()
    {
        if(_showNewCommentForm) {
            return ;
        }

        setState(() {
            _showNewCommentForm = true;
        });

        FlutterFixBottomSheet.showModalBottomSheet(context: context, builder: (BuildContext context) {
            return SendCommentWidget(
                presenter: widget.presenter,
            );
        }).then((dynamic data) {
            setState(() {
                _showNewCommentForm = false;

                if(data is Comment) {
                    _comments.add(data);
                }
            });

        });
    }

    Future<void> _onRefresh() async
    {
        widget.presenter?.didRefresh();
    }
}