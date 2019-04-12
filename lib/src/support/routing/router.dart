import 'package:flutter/material.dart';
import 'package:oppo_gdu/src/presenters/news/news_list_presenter.dart';
import 'package:oppo_gdu/src/data/repositories/news/api_repository.dart';
import 'package:oppo_gdu/src/ui/views/news/news_list_view.dart';
import 'package:oppo_gdu/src/config/news/news_list_configuration.dart';
import 'package:oppo_gdu/src/presenters/auth/login/login_presenter.dart';
import 'package:oppo_gdu/src/ui/views/auth/login/login_view.dart';
import 'package:oppo_gdu/src/presenters/contract.dart';
import 'router_contract.dart';

class Router implements RouterContract
{
    GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    void push(PresenterContract presenter)
    {
        navigatorKey.currentState.pushReplacement(
            MaterialPageRoute(
                builder: (context) => presenter.view as StatefulWidget
            )
        );
    }

    void pop()
    {
        navigatorKey.currentState.pop();
    }

    void presentNewsList()
    {
        push(createNewsListPresenter());
    }

    void presentNewsDetail()
    {

    }

    void presentLogin()
    {

    }

    void presentRegister()
    {

    }
    
    NewsListPresenter createNewsListPresenter()
    {
        NewsListPresenter newsListPresenter = NewsListPresenter(this);

        NewsListView(presenter: newsListPresenter);

        return newsListPresenter;
    }

    LoginPresenter createLoginPresenter()
    {
        LoginPresenter loginPresenter = LoginPresenter(
            router: this
        );

        LoginView(presenter: loginPresenter);

        return loginPresenter;
    }
}