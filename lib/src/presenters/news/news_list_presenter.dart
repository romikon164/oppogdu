import 'package:flutter/material.dart';
import 'package:oppo_gdu/src/ui/views/news/news_list_view.dart';
import 'package:oppo_gdu/src/ui/views/news/news_list_view_delegate.dart';
import 'package:oppo_gdu/src/data/repositories/news/news_repository.dart';
import 'package:oppo_gdu/src/data/models/news/news.dart';
import 'package:oppo_gdu/src/config/news/news_list_configuration.dart';
import 'package:oppo_gdu/src/support/routing/router.dart';
import 'package:oppo_gdu/src/ui/components/bottom_navigation_bar.dart';
import 'package:oppo_gdu/src/ui/components/main_menu_component.dart';
import 'package:oppo_gdu/src/data/models/users/user_profile.dart';
import 'package:oppo_gdu/src/http/api/service.dart';
import '../streamable_contract.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';
import 'package:rxdart/rxdart.dart';
import '../streamable_listenable_contract.dart';

class NewsListPresenter extends StreamablePresenterContract<News>
{
    NewsListPresenter(RouterContract router): super(router) {
        _stream = ReplaySubject<News>();
    }

    NewsListView _view;

    ViewContract get view => _view;

    set view(ViewContract view) {
        _view = view;
        _repository;
    }

    ReplaySubject<News> _sink;

    Sink<News> get sink => _sink;

    NewsApiRepository _apiRepository = NewsApiRepository();

    NewsDatabaseRepository _databaseRepository = NewsDatabaseRepository();

    StreamableListenableContract _listener;

    void onInitState(StreamableListenableContract listener)
    {
        _listener = listener;
    }

    void didRefresh()
    {
        _stream.
    }

    void onEndOfData()
    {

    }
}