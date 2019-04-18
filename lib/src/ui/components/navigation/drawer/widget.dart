import 'package:flutter/material.dart';
import 'package:oppo_gdu/src/data/models/users/user.dart';
import 'delegate.dart';

class DrawerNavigationWidget extends StatefulWidget
{
    static const newsItem = 0;

    final DrawerNavigationDelegate delegate;

    final int currentIndex;

    final User user;

    DrawerNavigationWidget({Key key, this.delegate, this.currentIndex, this.user});

    @override
    _DrawerNavigationWidgetState createState() => _DrawerNavigationWidgetState(currentIndex: currentIndex);
}

class _DrawerNavigationWidgetState extends State<DrawerNavigationWidget>
{
    int currentIndex;

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
        return widget.user == null
          ? _buildUnauthenticatedHeader(context)
          : _buildAuthenticatedHeader(context);
    }

    Widget _buildAuthenticatedHeader(BuildContext context)
    {
        return UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.color,
            ),
            accountName: Text("${widget.user.lastname} ${widget.user.firstname}".trim()),
            accountEmail: Text(widget.user.email),
            currentAccountPicture: CircleAvatar(
                backgroundColor: Theme.of(context).backgroundColor,
                child: widget.user.photo == null
                  ? Text(widget.user.firstname?.substring(0, 1))
                  : Image.network(widget.user.photo),
            ),
            onDetailsPressed: widget.delegate?.didDrawerNavigationProfilePressed,
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