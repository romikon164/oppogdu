import 'package:flutter/material.dart';
import 'router_contract.dart';
import 'package:oppo_gdu/src/presenters/contract.dart';
import 'package:oppo_gdu/src/presenters/auth/login/login_presenter.dart';
import 'package:oppo_gdu/src/presenters/auth/register/register_presenter.dart';
import 'package:oppo_gdu/src/presenters/news/news_list_presenter.dart';
import 'package:oppo_gdu/src/presenters/news/news_detail_presenter.dart';
import 'package:oppo_gdu/src/presenters/news/comments_presenter.dart';
import 'package:oppo_gdu/src/presenters/photos/album_list.dart';
import 'package:oppo_gdu/src/presenters/photos/album_detail.dart';
import 'package:oppo_gdu/src/ui/views/photo/single.dart';

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

    void presentNewsComments(int newsId)
    {
        push(NewsCommentsPresenter(this, id: newsId));
    }

    void presentPhotoAlbums()
    {
        replace(PhotoAlbumListPresenter(this));
    }

    void presentPhotoAlbumDetail(int albumId)
    {
        push(PhotoAlbumDetailPresenter(this, id: albumId));
    }

    void presentLogin()
    {
        replace(LoginPresenter(this));
    }

    void presentRegister()
    {
        replace(RegisterPresenter(this));
    }

    void presentSinglePhoto(String imageUrl, {String title})
    {
        navigatorKey.currentState.push(
            MaterialPageRoute(
                builder: (context) => SinglePhotoView(imageUrl: imageUrl, title: title)
            )
        );
    }
}