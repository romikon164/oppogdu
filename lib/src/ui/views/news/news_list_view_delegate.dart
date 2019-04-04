import 'package:oppo_gdu/src/data/models/news/news.dart';

abstract class NewsListViewDelegate
{
    void onLoadComplete(List<News> news);

    void onLoadFinish();

    void onLoadFail();
}