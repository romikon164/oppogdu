import 'package:flutter/material.dart';
import 'future_contract.dart';
import 'package:oppo_gdu/src/data/models/news/news.dart';
import 'package:oppo_gdu/src/data/models/page.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';
import 'package:oppo_gdu/src/ui/views/about.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';
import 'package:oppo_gdu/src/ui/views/future_contract.dart';
import 'package:oppo_gdu/src/data/repositories/news/api_repository.dart';
import 'package:oppo_gdu/src/data/repositories/pages/api_repository.dart';
import 'package:oppo_gdu/src/data/repositories/exceptions/not_found.dart';
import 'package:oppo_gdu/src/support/auth/service.dart';

class AboutPresenter extends FuturePresenterContract<News>
{
    int _newsId;

    News _news = News();

    AboutView _view;

    ViewFutureContract<News> _delegate;

    PageApiRepository _apiRepository = PageApiRepository();

    AboutPresenter(RouterContract router, {@required int id}): super(router) {
        _newsId = id;
        _view = AboutView(presenter: this);
    }

    ViewContract get view => _view;

    void onInitState(ViewFutureContract<News> delegate)
    {
        if(_delegate != delegate) {
            _delegate = delegate;
            _loadData();
        }
    }

    Future<void> didRefresh() async
    {
        await _loadData();
    }

    void onDisposeState()
    {
        _delegate = null;
    }

    Future<void> _loadData() async
    {
        try {
            String deviceToken = AuthService.instance.firebaseToken;

            Page page = await _apiRepository.getByCode('about');
            _news.content = page.content;

            _delegate.onLoad(_news);
        } on RepositoryNotFoundException {
            router.presentNewsList();
        } catch(e) {
            _delegate.onError();
        }
    }
}