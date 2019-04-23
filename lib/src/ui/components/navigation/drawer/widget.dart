import 'package:flutter/material.dart';
import 'package:oppo_gdu/src/data/models/users/user.dart';
import 'delegate.dart';
import 'dart:async';
import 'package:oppo_gdu/src/support/auth/service.dart';
import 'package:flutter/rendering.dart';

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
                    currentAccountPicture: CircleAvatar(
                        backgroundColor: _avatarBackgroundColor(userNameFirstLetter),
                        child: user.photo == null
                          ? Text(userNameFirstLetter)
                          : Image.network(user.photo),
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

    Color _avatarBackgroundColor(String l)
    {
        l = l.toLowerCase();
        if(l == "а" || l == "э" || l == "ю") {
            return Colors.amberAccent;
        } else if(l == "б") {
            return Colors.blue;
        } else if(l == "г" || l == "д" || l == "е" || l == "ё") {
            return Colors.deepOrangeAccent;
        } else if(l == "ж" || l == "з") {
            return Colors.blue;
        } else if(l == "и" || l == "й" || l == "к") {
            return Colors.indigoAccent;
        } else if(l == "л" || l == "м" || l == "н") {
            return Colors.lightBlueAccent;
        } else if(l == "о") {
            return Colors.orangeAccent;
        } else if(l == "п") {
            return Colors.pinkAccent;
        } else if(l == "р" || l == "с") {
            return Colors.redAccent;
        } else if(l == "т" || l == "у" || l == "ф" || l == "х") {
            return Colors.tealAccent;
        } else if(l == "ц" || l == "ч" || l == "ь" || l == "ъ") {
            return Colors.cyanAccent;
        } else if(l == "ш" || l == "щ" || l == "я") {
            return Colors.yellowAccent;
        } else {
            return Colors.lightBlueAccent;
        }
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