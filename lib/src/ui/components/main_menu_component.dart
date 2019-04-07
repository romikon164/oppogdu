import 'package:flutter/material.dart';
import 'package:oppo_gdu/src/data/models/users/user_profile.dart';

class MainMenuComponent extends StatefulWidget
{
    static const newsItem = 0;

    final MainMenuDelegate delegate;

    final int currentIndex;

    MainMenuComponent({Key key, this.delegate, this.currentIndex});

    @override
    _MainMenuComponentState createState() => _MainMenuComponentState(currentIndex: currentIndex);
}

class _MainMenuComponentState extends State<MainMenuComponent>
{
    int currentIndex;

    _MainMenuComponentState({this.currentIndex}): super();

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
                        onTap: widget.delegate.onNewsTap
                    ),
                    _buildItem(
                        context,
                        title: "Фотогалерея",
                        icon: Icons.photo,
                        onTap: widget.delegate.onPhotoGalleryTap
                    ),
                ]
            ),
        );
    }

    Widget _buildHeader(BuildContext context)
    {
        UserProfile user = widget.delegate?.getUserProfile();

        return user == null
            ? _buildUnauthenticatedHeader(context)
            : _buildAuthenticatedHeader(context, user);
    }

    Widget _buildAuthenticatedHeader(BuildContext context, UserProfile user)
    {
        return UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.color,
            ),
            accountName: Text("${user.lastname} ${user.firstname}".trim()),
            accountEmail: Text(user.email),
            currentAccountPicture: CircleAvatar(
                backgroundColor: Theme.of(context).backgroundColor,
                child: user.photo == null
                    ? Text(user.firstname?.substring(0, 1))
                    : Image.network(user.photo),
            ),
            onDetailsPressed: widget.delegate?.onUserProfileTap,
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
                        style: Theme.of(context).primaryTextTheme.subtitle,
                    ),
                ),
                onTap: widget.delegate.onUserLoginTap,
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

abstract class MainMenuDelegate
{
    UserProfile getUserProfile();

    void onUserProfileTap();

    void onUserLoginTap();

    void onNewsTap();

    void onPhotoGalleryTap();
}