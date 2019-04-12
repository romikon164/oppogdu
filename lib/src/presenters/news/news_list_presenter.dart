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
import 'package:rxdart/rxdart.dart';
import '../presenter.dart';
import 'package:oppo_gdu/src/ui/components/lists/streamable.dart';
import 'package:oppo_gdu/src/data/repositories/database_criteria.dart';
import 'package:oppo_gdu/src/data/repositories/criteria.dart';
import 'package:oppo_gdu/src/data/repositories/api_criteria.dart';

class NewsListPresenter extends NewsListDelegate implements StreamableListViewDelegate
{
    NewsListView _view;

    PublishSubject<News> _newsStream;

    NewsListPresenter(RouterContract router): super(router) {
        _view = NewsListView(delegate: this);
    }

    ViewContract get view => _view;

    News _streamStartWith;

    int _pageSize = 15;

    int _currentPage;

    NewsDatabaseRepository _databaseRepository = NewsDatabaseRepository();

    NewsApiRepository _apiRepository = NewsApiRepository();

    void onInitState()
    {
        _startNewsStream();
    }

    void didRefresh()
    {
        _newsStream.close();
        _startNewsStream();
    }

    void didScrollToEnd()
    {
        _loadNews(_currentPage + 1);
    }

    Future<void> _startNewsStream() async
    {
        _newsStream = PublishSubject<News>();

        try {
            _streamStartWith = await _databaseRepository.getFirst(
                DatabaseCriteria().sortByDesc("created_at")
            );
        } catch(e) {
            _streamStartWith = null;
        }

        _loadNews(1);

        _loadFreshNewsFromApi();
    }

    Future<void> _loadNews(int page) async
    {
        _currentPage = page;
        
        List<News> newses = await _loadNewsFromDatabase(page);
        
        if(newses.isEmpty) {
            newses = await _loadNewsFromApi();
            
            if(newses.isEmpty) {
                _newsStream.close();
                
                return ;
            }

            _cacheNewsToDatabase(newses);
        }
        
        newses.forEach((news) => _newsStream.add(news));
    }
    
    Future<List<News>> _loadNewsFromDatabase(int page) async
    {
        DatabaseCriteria criteria = DatabaseCriteria()
            .sortByDesc("created_at")
            .skip((page - 1) * _pageSize)
            .take(_pageSize);

        if(_streamStartWith != null) {
            criteria.where("id", CriteriaOperator.lessOrEqual, _streamStartWith.id);
        }

        return await _databaseRepository.get(criteria);
    }

    Future<List<News>> _loadNewsFromApi() async
    {
        ApiCriteria criteria = ApiCriteria()
            .sortByDesc("created_at")
            .skip((page - 1) * _pageSize)
            .take(_pageSize);

        if(_streamStartWith != null) {
            criteria.where("right_bound", CriteriaOperator.equal, _streamStartWith.id);
        }

        return await _apiRepository.get(criteria);
    }

    Future<void> _cacheNewsToDatabase(List<News> newses) async
    {
        newses.forEach((news) => _databaseRepository.add(news));
    }
}