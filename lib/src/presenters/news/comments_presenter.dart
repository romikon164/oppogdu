import 'package:flutter/material.dart';
import '../future_contract.dart';
import 'package:oppo_gdu/src/data/models/news/comment.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';
import 'package:oppo_gdu/src/ui/views/news/comments.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';
import 'package:oppo_gdu/src/ui/views/future_contract.dart';
import 'package:oppo_gdu/src/data/repositories/comments/api_repository.dart';
import 'package:oppo_gdu/src/data/repositories/exceptions/not_found.dart';
import 'package:oppo_gdu/src/support/auth/service.dart';

class NewsCommentsPresenter extends FuturePresenterContract<List<Comment>>
{
    int _newsId;

    NewsCommentsView _view;

    NewsCommentsDelegate _delegate;

    CommentsApiRepository _apiRepository = CommentsApiRepository();

    NewsCommentsPresenter(RouterContract router, {@required int id}): super(router) {
        _newsId = id;
        _view = NewsCommentsView(presenter: this);
    }

    ViewContract get view => _view;

    void onInitState(ViewFutureContract<List<Comment>> delegate)
    {
        if(_delegate != delegate) {
            _delegate = delegate;
            _loadNewsComments();
        }
    }

    Future<void> didRefresh() async
    {
        await _loadNewsComments();
    }

    void onDisposeState()
    {
        _delegate = null;
    }

    Future<void> _loadNewsComments() async
    {
        try {
            List<Comment> _comments = await _apiRepository.getByNewsId(_newsId);

            _delegate.onLoad(_comments);
        } on RepositoryNotFoundException {
            router.presentNewsList();
        } catch(e) {
            _delegate.onError();
        }
    }

    Future<void> didNewCommentPressed(String message) async
    {
        Comment comment = Comment(
            id: null,
            user: AuthService.instance.user,
            text: message,
            createdAt: DateTime.now()
        );

        comment.newsId = _newsId;

        try {
            if (await _apiRepository.add(comment)) {
                _delegate.onCommentSuccess(comment);
            } else {
                _delegate.onCommentError();
            }
        } catch(_) {
            _delegate.onCommentError();
        }
    }
}