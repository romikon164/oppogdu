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

class NewsListPresenter implements AnimatedBottomNavigationBarDelegate, MainMenuDelegate
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
            viewDelegate?.onLoadFail();

            isLoading = false;
            return ;
        }

        news.addAll(loadedNews);

        if (loadedNews.isEmpty) {
            viewDelegate?.onLoadFinish();
        } else {
            viewDelegate?.onLoadComplete(news);
        }

        isLoading = false;
    }

    Future<void> didRefresh() async
    {
        news = [];
        await didLoad();
    }

    // AnimatedBottomNavigationBar implements
    void onNewsTap()
    {

    }

    void onSportComplexTap()
    {

    }

    void onCallbackTap()
    {

    }

    // MainMenuDelegate implements
    UserProfile getUserProfile()
    {
        return Api.getInstance().auth.getCurrentUserProfile();
    }

    void onUserProfileTap()
    {

    }

    void onUserLoginTap()
    {
        router.pop();
        router.presentLogin();
    }

    void onPhotoGalleryTap()
    {

    }
}