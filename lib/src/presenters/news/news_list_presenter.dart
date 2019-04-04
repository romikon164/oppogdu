import 'package:flutter/material.dart';
import 'package:oppo_gdu/src/ui/views/news/news_list_view.dart';
import 'package:oppo_gdu/src/ui/views/news/news_list_view_delegate.dart';
import 'package:oppo_gdu/src/data/repositories/news/news_repository.dart';
import 'package:oppo_gdu/src/data/models/news/news.dart';
import 'package:oppo_gdu/src/config/news/news_list_configuration.dart';
import 'package:oppo_gdu/src/support/routing/router.dart';

class NewsListPresenter
{

    final Router router;

    NewsListView view;

    NewsListViewDelegate viewDelegate;

    NewsRepository repository;

    final NewsListConfiguration configuration;

    List<News> news = [];

    bool isLoading = false;

    NewsListPresenter({@required this.router, this.configuration});

    Future<void> didInitState() async
    {
        await didLoad();
    }

    Future<void> didTapListItem(News news) async
    {
        // router.presentNewsDetailPresenter(news);
    }

    Future<void> didLoad() async
    {
        if(isLoading) return ;

        isLoading = true;

        List<News> loadedNews = [];

        try {
            if(news.isEmpty) {
                loadedNews = await repository.fetch(configuration.loadLimit);
            } else {
                loadedNews = await repository.fetchAfter(news.last, configuration.loadLimit);
            }
        } catch (e) {
            if(viewDelegate != null) {
                viewDelegate.onLoadFail();
            }

            isLoading = false;
            return ;
        }

        news.addAll(loadedNews);

        if(viewDelegate != null) {
            if (loadedNews.isEmpty) {
                viewDelegate.onLoadFinish();
            } else {
                viewDelegate.onLoadComplete(news);
            }
        }

        isLoading = false;
    }

    Future<void> didRefresh() async
    {
        news = [];
        await didLoad();
    }
}