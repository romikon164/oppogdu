import 'package:flutter/material.dart';
import '../future_contract.dart';
import 'package:oppo_gdu/src/data/models/news/comment.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';
import 'package:oppo_gdu/src/ui/views/news/comments.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';
import 'package:oppo_gdu/src/ui/views/future_contract.dart';
import 'package:oppo_gdu/src/data/repositories/comments/api_repository.dart';
import 'package:oppo_gdu/src/data/repositories/criteria.dart';
import 'package:oppo_gdu/src/data/repositories/api_criteria.dart';
import 'package:oppo_gdu/src/data/repositories/exceptions/not_found.dart';
import 'package:oppo_gdu/src/support/auth/service.dart';

class NewsCommentsPresenter extends FuturePresenterContract<List<Comment>>
{
    int _newsId;

    NewsCommentsView _view;

    ViewFutureContract<List<Comment>> _delegate;

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

    void didRefresh()
    {
        _loadNewsComments();
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
            print(e.toString());
            _delegate.onError();
        }
    }

    void didNewCommentPressed()
    {

    }
}