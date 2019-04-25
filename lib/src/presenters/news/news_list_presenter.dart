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
import 'package:oppo_gdu/src/support/auth/service.dart';

class NewsListPresenter extends NewsListDelegate implements StreamableListViewDelegate
{
    NewsListView _view;

    PublishSubject<News> _newsStream;

    NewsListPresenter(RouterContract router): super(router) {
        _view = NewsListView(delegate: this);
    }

    ViewContract get view => _view;

    News _streamStartWith;

    int _pageSize = 5;

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


    void didFavoritePressed(News news)
    {
        news.isFavorited = true;
        _addToFavorite(news);
    }

    void didUnFavoritePressed(News news)
    {
        news.isFavorited = false;
        _removeFromFavorite(news);
    }

    void didCommentsPressed(News news)
    {
        router.presentNewsComments(news.id);
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
            print(e.toString());
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
                    _newsStream.add(null);

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
        String authDeviceToken = AuthService.instance.firebaseToken;

        ApiCriteria criteria = ApiCriteria()
            .sortByDesc("created_at")
            .skip((page - 1) * _pageSize)
            .take(_pageSize);

        if(_streamStartWith != null) {
            criteria.where("right_bound", CriteriaOperator.equal, _streamStartWith.id);
        }

        return await _apiRepository.get(criteria, deviceToken: authDeviceToken);
    }

    Future<void> _cacheNewsToDatabase(List<News> newses) async
    {
        for(News news in newses) {
            await _databaseRepository.add(news);
        }
    }

    Future<void> _loadFreshNewsFromApi() async
    {
        if(_streamStartWith == null) {
            return ;
        }

        String authDeviceToken = AuthService.instance.firebaseToken;

        ApiCriteria criteria = ApiCriteria()
            .sortByDesc("created_at")
            .where("left_bound", CriteriaOperator.equal, _streamStartWith.id);

        try {
            List<News> newses = await _apiRepository.get(
                criteria,
                deviceToken: authDeviceToken
            );

            if(newses.isNotEmpty) {
                _cacheNewsToDatabase(newses);

                newses.forEach((news) => _newsStream.add(news));
            }
        } catch(e) {

        }
    }

    Future<void> _updateNewsCounters(List<News> newses) async
    {
        if(newses.isEmpty) {
            return ;
        }

        try {
            for(News news in newses) {
                if(await _apiRepository.getCounters(news)) {
                    await _databaseRepository.updateCounters(
                        news.id,
                        favorites: news.favoritesCount,
                        views: news.viewsCount,
                        comments: news.commentsCount
                    );

                    _newsStream.add(news);
                }
            }
        } catch (_) {

        }
    }

    Future<void> _addToFavorite(News news) async
    {
        String authDeviceToken = AuthService.instance.firebaseToken;

        if(authDeviceToken != null && authDeviceToken.isNotEmpty) {
            try {
                await _apiRepository.addToFavorite(news.id, authDeviceToken);
                await _databaseRepository.addToFavorite(news.id);

                await _updateNewsCounters([news]);
            } catch (_) {

            }
        }
    }

    Future<void> _removeFromFavorite(News news) async
    {
        String authDeviceToken = AuthService.instance.firebaseToken;

        if(authDeviceToken != null && authDeviceToken.isNotEmpty) {
            try {
                await _apiRepository.removeFromFavorite(news.id, authDeviceToken);
                await _databaseRepository.removeFromFavorite(news.id);

                await _updateNewsCounters([news]);
            } catch (_) {

            }
        }
    }
}