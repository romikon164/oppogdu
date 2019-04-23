import 'package:flutter/material.dart';
import 'router_contract.dart';
import 'package:oppo_gdu/src/presenters/contract.dart';
import 'package:oppo_gdu/src/presenters/auth/login/login_presenter.dart';
import 'package:oppo_gdu/src/presenters/auth/register/register_presenter.dart';
import 'package:oppo_gdu/src/presenters/news/news_list_presenter.dart';
import 'package:oppo_gdu/src/presenters/news/news_detail_presenter.dart';

class Router implements RouterContract
{
    GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    void replace(PresenterContract presenter)
    {
        navigatorKey.currentState.pushReplacement(
            MaterialPageRoute(
                builder: (context) => presenter.view as StatefulWidget
            )
        );
    }

    void push(PresenterContract presenter)
    {
        navigatorKey.currentState.push(
            MaterialPageRoute(
                builder: (context) => presenter.view as StatefulWidget
            )
        );
    }

    void pop()
    {
        navigatorKey.currentState.pop();
    }

    void presentHomeScreen()
    {
        presentNewsList();
    }

    void presentNewsList()
    {
        replace(NewsListPresenter(this));
    }

    void presentNewsDetail(int newsId)
    {
        push(NewsDetailPresenter(this, id: newsId));
    }

    void presentLogin()
    {
        replace(LoginPresenter(this));
    }

    void presentRegister()
    {
        replace(RegisterPresenter(this));
    }
}