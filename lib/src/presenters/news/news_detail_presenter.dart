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
import 'package:oppo_gdu/src/support/auth/service.dart';

class NewsDetailPresenter extends FuturePresenterContract<News>
{
    int _newsId;

    News _news;

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

    void didCommentsPressed()
    {
        router.presentNewsComments(_newsId);
    }

    Future<void> didFavoritePressed() async
    {
        String deviceToken = AuthService.instance.firebaseToken;
        await _apiRepository.addToFavorite(_newsId, deviceToken);
        _news.isFavorited = true;
        await _updateNewsCounters();
    }

    Future<void> didUnFavoritePressed() async
    {
        String deviceToken = AuthService.instance.firebaseToken;
        await _apiRepository.removeFromFavorite(_newsId, deviceToken);
        _news.isFavorited = false;
        await _updateNewsCounters();
    }

    void onDisposeState()
    {
        _delegate = null;
    }

    Future<void> _loadNewsData() async
    {
        try {
            String deviceToken = AuthService.instance.firebaseToken;

            _news = await _apiRepository.getById(_newsId, deviceToken: deviceToken);

            _delegate.onLoad(_news);
        } on RepositoryNotFoundException {
            router.presentNewsList();
        } catch(e) {
            _delegate.onError();
        }
    }

    Future<void> _updateNewsCounters() async
    {
        if(_news == null) {
            return ;
        }

        try {
            if(await _apiRepository.getCounters(_news)) {
                _delegate.onLoad(_news);
            }
        } catch (_) {

        }
    }
}