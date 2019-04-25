import 'package:flutter/material.dart';
import 'package:oppo_gdu/src/data/models/users/user.dart';
import 'delegate.dart';
import 'dart:async';
import 'package:oppo_gdu/src/support/auth/service.dart';
import 'package:flutter/rendering.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:oppo_gdu/src/support/utils.dart';

class DrawerNavigationWidget extends StatefulWidget
{
    static const newsItem = 0;

    final DrawerNavigationDelegate delegate;

    final int currentIndex;

    DrawerNavigationWidget({Key key, this.delegate, this.currentIndex});

    @override
    _DrawerNavigationWidgetState createState() => _DrawerNavigationWidgetState(currentIndex: currentIndex);
}

class _DrawerNavigationWidgetState extends State<DrawerNavigationWidget> with TickerProviderStateMixin
{
    int currentIndex;

    bool _userMenuVisible = false;

    _DrawerNavigationWidgetState({this.currentIndex}): super();

    @override
    Widget build(BuildContext context)
    {
        return Drawer(
            child: ListView(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                children: [
                    _buildHeader(context),
                    _buildItem(
                        context,
                        title: "Новости",
                        icon: Icons.assignment,
                        onTap: widget.delegate.didDrawerNavigationNewsPressed
                    ),
                    _buildItem(
                        context,
                        title: "Фотогалерея",
                        icon: Icons.photo,
                        onTap: widget.delegate.didDrawerNavigationPhotoGalleryPressed
                    ),
                ]
            ),
        );
    }

    Widget _buildHeader(BuildContext context)
    {
        return FutureBuilder(
            future: _awaitAuthComplete(),
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                return !snapshot.hasData || snapshot.data == null
                  ? _buildUnauthenticatedHeader(context)
                  : _buildAuthenticatedHeader(context, snapshot.data);
            },
        );
    }

    Future<User> _awaitAuthComplete() async
    {
        while(!AuthService.instance.initialized) {
            await Future.delayed(Duration(milliseconds: 100));
        }

        return AuthService.instance.user;
    }

    Widget _buildAuthenticatedHeader(BuildContext context, User user)
    {
        String userNameFirstLetter = user.firstname?.substring(0, 1) ?? "";

        return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                UserAccountsDrawerHeader(
                    margin: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).appBarTheme.color,
                    ),
                    accountName: Text(
                      "${user.lastname ?? ""} ${user.firstname ?? ""}".trim(),
                      style: Theme.of(context).appBarTheme.textTheme.subtitle
                    ),
                    accountEmail: Text(
                        user.email ?? "",
                        style: Theme.of(context).appBarTheme.textTheme.subtitle.copyWith(fontWeight: FontWeight.normal),
                    ),
                    currentAccountPicture: GestureDetector(
                        onTap: widget.delegate?.didDrawerNavigationProfilePressed,
                        child: CircleAvatar(
                            radius: 32,
                            backgroundColor: user.photo == null
                                ? Utils.avatarBackgroundColor(userNameFirstLetter)
                                : Theme.of(context).appBarTheme.color,
                            backgroundImage: user.photo != null ? CachedNetworkImageProvider(user.photo) : null,
                            child: user.photo == null
                                ? Text(userNameFirstLetter)
                                : null,
                        ),
                    ),
                    onDetailsPressed: () {
                         setState(() {
                            _userMenuVisible = !_userMenuVisible;
                        });
                    },
                ),
                AnimatedSize(
                    alignment: Alignment.topCenter,
                    child: Container(
                        height: _userMenuVisible ? null : 0,
                        color: Theme.of(context).appBarTheme.color,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                ListTile(
                                    leading: Icon(Icons.settings, color: Colors.white),
                                    title: Text("Редактировать профиль", style: TextStyle(color: Colors.white)),
                                    onTap: () {
                                        widget.delegate?.didDrawerNavigationProfilePressed();
                                    },
                                ),
                                ListTile(
                                    leading: Icon(Icons.exit_to_app, color: Colors.white),
                                    title: Text("Выйти из аккаунта", style: TextStyle(color: Colors.white)),
                                    onTap: () {
                                        widget.delegate?.didDrawerNavigationLogoutPressed();
                                    },
                                ),
                            ],
                        ),
                    ),
                    vsync: this,
                    duration: Duration(milliseconds: 300),
                )
            ],
        );
    }

    Widget _buildUnauthenticatedHeader(BuildContext context)
    {
        return Container(
            height: 92,
            color: Theme.of(context).appBarTheme.color,
            child: GestureDetector(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 56, 16, 8),
                    child: Text(
                        "Вход / Регистрация",
                        style: Theme.of(context).appBarTheme.textTheme.subtitle,
                    ),
                ),
                onTap: widget.delegate?.didDrawerNavigationLoginPressed,
            ),
        );
    }

    Widget _buildItem(BuildContext context, {String title, IconData icon, GestureTapCallback onTap})
    {
        return ListTile(
            title: Text(title),
            leading: Icon(icon),
            onTap: onTap,
        );
    }
}