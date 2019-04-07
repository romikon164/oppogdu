import 'package:flutter/material.dart';
import 'package:oppo_gdu/src/presenters/news/news_list_presenter.dart';
import 'package:oppo_gdu/src/data/repositories/news/news_api_repository.dart';
import 'package:oppo_gdu/src/ui/views/news/news_list_view.dart';
import 'package:oppo_gdu/src/config/news/news_list_configuration.dart';
import 'package:oppo_gdu/src/presenters/auth/login/login_presenter.dart';
import 'package:oppo_gdu/src/ui/views/auth/login/login_view.dart';

class Router
{
    GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    void pop()
    {
        navigatorKey.currentState.pop();
    }
    
    NewsListPresenter createNewsListPresenter()
    {
        NewsListPresenter newsListPresenter = NewsListPresenter(
            router: this,
            configuration: NewsListConfiguration()
        );

        newsListPresenter.repository = NewsApiRepository();

        NewsListView(presenter: newsListPresenter);

        return newsListPresenter;
    }

    void presentNewsList()
    {
        navigatorKey.currentState.pushReplacement(
            MaterialPageRoute(
                builder: (context) => createNewsListPresenter().view
            )
        );
    }

    LoginPresenter createLoginPresenter()
    {
        LoginPresenter loginPresenter = LoginPresenter(
            router: this
        );

        LoginView(presenter: loginPresenter);

        return loginPresenter;
    }

    void presentLogin()
    {
        navigatorKey.currentState.push(
            MaterialPageRoute(
                builder: (context) => createLoginPresenter().view
            )
        );
    }
}