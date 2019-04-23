import 'package:flutter/material.dart';
import '../future_contract.dart';
import 'package:oppo_gdu/src/data/models/news/news.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';
import 'package:oppo_gdu/src/ui/views/news/news_detail_view.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';
import 'package:oppo_gdu/src/ui/views/future_contract.dart';
import 'package:oppo_gdu/src/data/repositories/news/api_repository.dart';
import 'package:oppo_gdu/src/data/repositories/criteria.dart';
import 'package:oppo_gdu/src/data/repositories/api_criteria.dart';
import 'package:oppo_gdu/src/data/repositories/exceptions/not_found.dart';

class NewsDetailPresenter extends FuturePresenterContract<News>
{
    int _newsId;

    NewsDetailView _view;

    ViewFutureContract<News> _delegate;

    NewsApiRepository _apiRepository = NewsApiRepository();

    NewsDetailPresenter(RouterContract router, {@required int id}): super(router) {
        _newsId = id;
        _view = NewsDetailView(presenter: this);
    }

    ViewContract get view => _view;

    void onInitState(ViewFutureContract<News> delegate)
    {
        if(_delegate != delegate) {
            _delegate = delegate;
            _loadNewsData();
        }
    }

    void didRefresh()
    {
        _loadNewsData();
    }

    void onDisposeState()
    {
        _delegate = null;
    }

    Future<void> _loadNewsData() async
    {
        try {
            News news = await _apiRepository.getFirst(
                ApiCriteria()
                    .where("id", CriteriaOperator.equal, _newsId)
            );

            _delegate.onLoad(news);
        } on RepositoryNotFoundException {
            router.presentNewsList();
        }
    }
}