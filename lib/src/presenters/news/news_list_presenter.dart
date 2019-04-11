import 'package:flutter/material.dart';
import 'package:oppo_gdu/src/ui/views/news/news_list_view.dart';
import 'package:oppo_gdu/src/ui/views/news/news_list_view_delegate.dart';
import 'package:oppo_gdu/src/data/models/news/news.dart';
import 'package:oppo_gdu/src/support/routing/router.dart';
import 'package:oppo_gdu/src/http/api/service.dart';
import '../streamable_contract.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';
import 'dart:async';
import '../streamable_listenable_contract.dart';
import 'package:oppo_gdu/src/data/repositories/news/api_repository.dart';
import 'package:oppo_gdu/src/data/repositories/news/database_repository.dart';

class NewsListPresenter extends StreamablePresenterContract<News>
{
    StreamController<News> _streamController;

    NewsListView _view;

    NewsApiRepository _apiRepository = NewsApiRepository();

    NewsDatabaseRepository _databaseRepository = NewsDatabaseRepository();

    StreamableListenableContract<News> _listener;

    NewsListPresenter(RouterContract router): super(router);

    StreamController<News> get streamController => _streamController;

    ViewContract get view => _view;

    int _currentNewsPage;

    set view(ViewContract view) {
        _view = view;
    }

    void onInitState(StreamableListenableContract<News> listener)
    {
        _listener = listener;

        _startStream();

        _listener.stream = _streamController.stream;
    }

    void didRefresh()
    {
        _streamController.close();
        _startStream();
    }

    void onEndOfData()
    {
        _addNewsToStreamFromDatabase(page: _currentNewsPage + 1);
    }

    Future<void> _startStream() async
    {
        print("start news stream");

        _streamController = StreamController<News>();

        _attemptLoadFreshNewsFromApiService();
        _addNewsToStreamFromDatabase();
    }

    Future<void> _addNewsToStreamFromDatabase({int page = 1, int withStartIndex}) async
    {
        print("loading page #$page from datebase");

        _currentNewsPage = page;

        List<News> newsList = await _databaseRepository.retrieveAll(page: page, withStartIndex: withStartIndex);

        if(newsList.length == 0) {
            print("page #$page not found in database");

            try {
                News firstSavedNews = await _databaseRepository.retrieveFirstSavedModel();
                newsList = await _attemptLoadNewsFromApiService(page: 1, withStartIndex: firstSavedNews.id);
            } catch(e) {
                newsList = await _attemptLoadNewsFromApiService(page: 1);
            }

            if(newsList.length == 0) {
                _streamController.close();

                return ;
            }

            _databaseRepository.persistsAll(newsList);
        }

        for(News newsItem in newsList) {
            _streamController.add(newsItem);
        }
    }

    Future<void> _attemptLoadFreshNewsFromApiService() async
    {
        int lastSavedNewsId;

        try {
            News lastSavedNews = await _databaseRepository.retrieveLastSavedModel();
            lastSavedNewsId = lastSavedNews.id;
            print("load fresh data from api with last saved id #$lastSavedNewsId");
        } catch(e) {
            print("load last saved id error \"${e.toString()}\"");
            return ;
        }

        try {
            List<News> freshNewsList = await _loadFreshNewsFromApiService(lastSavedNewsId);
            _addFreshNewsToDatabase(freshNewsList);
        } catch(e) {
            print("error network \"${e.toString()}\"");
            _listener.onNetworkError();
        }
    }

    Future<List<News>> _loadFreshNewsFromApiService(int lastSavedNewsId, [int page = 1]) async
    {
        List<News> newsList = await _apiRepository.retrieveAll(page: page);
        List<News> newsListForAddingToDatabase = List<News>();

        for(News newsItem in newsList) {
            if(newsItem.id == lastSavedNewsId) {
                return newsListForAddingToDatabase;
            }

            newsListForAddingToDatabase.add(newsItem);
        }

        newsListForAddingToDatabase.addAll(
            await _loadFreshNewsFromApiService(lastSavedNewsId, page + 1)
        );

        return newsListForAddingToDatabase;
    }

    Future<void> _addFreshNewsToDatabase(List<News> newsList) async
    {
        await _databaseRepository.persistsAll(newsList);

        if(_streamController != null && !_streamController.isClosed) {
            _streamController.close();
        }

        _streamController = StreamController<News>();

        for(int i = 1; i < _currentNewsPage; i++) {
            await _addNewsToStreamFromDatabase(page: 1);
        }

        if(_listener != null) {
            _listener.stream = _streamController.stream;
            _listener.onRefresh();
        }
    }

    Future<List<News>> _attemptLoadNewsFromApiService({int page = 1, int withStartIndex}) async
    {
        try {
            return await _apiRepository.retrieveAll(page: page, withStartIndex: withStartIndex);
        } catch(e) {
            print("error network \"${e.toString()}\"");
            return [];
        }
    }
}