import 'package:oppo_gdu/src/ui/views/news/news_list_view.dart';
import 'package:oppo_gdu/src/data/models/news/news.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';
import 'dart:async';
import 'package:oppo_gdu/src/data/repositories/news/api_repository.dart';
import 'package:oppo_gdu/src/data/repositories/news/database_repository.dart';
import 'package:rxdart/rxdart.dart';
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

    Observable<News> get stream => _newsStream;

    void onInitState()
    {
        _startNewsStream();
    }

    void onDisposeState()
    {
//        if(_newsStream != null) {
//            _newsStream.close();
//        }
    }

    void didNewsListItemPressed(News news)
    {
        router.presentNewsDetail(news.id);
    }

    Future<Observable<News>> didRefresh() async
    {
        await _databaseRepository.deleteAll();

        _newsStream = PublishSubject<News>();

        _startNewsStream();

        return _newsStream;
    }

    void didScrollToEnd()
    {
        _loadNews(_currentPage + 1);
    }

    Future<void> _startNewsStream() async
    {
        if(_newsStream == null) {
            _newsStream = PublishSubject<News>();
        }

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
            try {
                newses = await _loadNewsFromApi(page);

                if (newses.isEmpty) {
                    _newsStream.close();

                    return;
                }

                _cacheNewsToDatabase(newses);
            } catch(e) {
                _newsStream.addError(e);
            }
        } else {
            _updateNewsCounters(newses);
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

        return (await _databaseRepository.get(criteria)).delegate;
    }

    Future<List<News>> _loadNewsFromApi(int page) async
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

    Future<void> _loadFreshNewsFromApi() async
    {
        if(_streamStartWith == null) {
            return ;
        }

        ApiCriteria criteria = ApiCriteria()
            .sortByDesc("created_at")
            .where("left_bound", CriteriaOperator.equal, _streamStartWith.id);

        List<News> newses = await _apiRepository.get(criteria);

        if(newses.isNotEmpty) {
            _cacheNewsToDatabase(newses);

            newses.forEach((news) => _newsStream.add(news));
        }
    }

    Future<void> _updateNewsCounters(List<News> newses) async
    {
        // TODO
    }
}