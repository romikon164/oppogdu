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

    static const photosItem = 1;

    static const videosItem = 2;

    static const sportComplexItem = 3;

    static const structureItem = 4;

    static const printsItem = 5;

    static const regulationsItem = 6;

    static const leadersItem = 7;

    static const agreementItem = 8;

    static const contactsItem = 9;

    static const followUsItem = 10;

    static const callbackItem = 11;

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
                        onTap: widget.delegate.didDrawerNavigationNewsPressed,
                        active: currentIndex == DrawerNavigationWidget.newsItem,
                    ),
                    _buildItem(
                        context,
                        title: "Фотогалерея",
                        icon: Icons.photo,
                        onTap: widget.delegate.didDrawerNavigationPhotoGalleryPressed,
                        active: currentIndex == DrawerNavigationWidget.photosItem,
                    ),
                    _buildItem(
                        context,
                        title: "Видеозаписи",
                        icon: Icons.videocam,
                        onTap: widget.delegate.didDrawerNavigationVideoGalleryPressed,
                        active: currentIndex == DrawerNavigationWidget.videosItem,
                    ),
                    Container(height: 1, color: Colors.black12),
                    _buildItem(
                        context,
                        title: "Спортивный комплекс",
                        icon: Icons.business,
                        onTap: widget.delegate.didDrawerNavigationSportComplexPressed,
                        active: currentIndex == DrawerNavigationWidget.sportComplexItem,
                    ),
                    _buildItem(
                        context,
                        title: "Структура",
                        icon: Icons.account_balance,
                        onTap: widget.delegate.didDrawerNavigationStructurePressed,
                        active: currentIndex == DrawerNavigationWidget.structureItem,
                    ),
                    _buildItem(
                        context,
                        title: "Печатные издания",
                        icon: Icons.library_books,
                        onTap: widget.delegate.didDrawerNavigationPrintsPressed,
                        active: currentIndex == DrawerNavigationWidget.printsItem,
                    ),
                    _buildItem(
                        context,
                        title: "Нормативные акты",
                        icon: Icons.collections_bookmark,
                        onTap: widget.delegate.didDrawerNavigationRegulationsPressed,
                        active: currentIndex == DrawerNavigationWidget.regulationsItem,
                    ),
                    _buildItem(
                        context,
                        title: "Руководство",
                        icon: Icons.people,
                        onTap: widget.delegate.didDrawerNavigationLeadershipPressed,
                        active: currentIndex == DrawerNavigationWidget.leadersItem,
                    ),
                    _buildItem(
                        context,
                        title: "Коллективный договор",
                        icon: Icons.thumbs_up_down,
                        onTap: widget.delegate.didDrawerNavigationCollectiveAgreementPressed,
                        active: currentIndex == DrawerNavigationWidget.agreementItem,
                    ),
                    Container(height: 1, color: Colors.black12),
                    _buildItem(
                        context,
                        title: "Контакты",
                        icon: Icons.perm_contact_calendar,
                        onTap: widget.delegate.didDrawerNavigationContactsPressed,
                        active: currentIndex == DrawerNavigationWidget.contactsItem,
                    ),
                    _buildItem(
                        context,
                        title: "Следите за нами",
                        icon: Icons.remove_red_eye,
                        onTap: widget.delegate.didDrawerNavigationFollowsUsPressed,
                        active: currentIndex == DrawerNavigationWidget.followUsItem,
                    ),
                    _buildItem(
                        context,
                        title: "Напишите нам",
                        icon: Icons.mail,
                        onTap: widget.delegate.didDrawerNavigationWriteToUsPressed,
                        active: currentIndex == DrawerNavigationWidget.callbackItem,
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

    Widget _buildItem(BuildContext context, {String title, IconData icon, GestureTapCallback onTap, bool active = false})
    {
        return ListTile(
            selected: active,
            title: Text(title),
            leading: Icon(icon),
            onTap: onTap,
        );
    }
}