import 'package:oppo_gdu/src/presenters/news/news_list_presenter.dart';
import 'package:oppo_gdu/src/data/models/news/news.dart';

abstract class NewsRepository
{
    NewsListPresenter presenter;

    Future<List<News>> fetch(int limit);

    Future<List<News>> fetchAfter(News news, int limit) async
    {
        return await fetchAfterId(news.id, limit);
    }

    Future<List<News>> fetchAfterId(int id, int limit);
}