import 'package:flutter/material.dart';
import 'future_contract.dart';
import 'package:oppo_gdu/src/data/models/contacts.dart';
import '../components/navigation/bottom/widget.dart';
import '../components/navigation/drawer/widget.dart';
import 'view_contract.dart';
import 'package:oppo_gdu/src/presenters/contacts.dart';
import 'package:flutter/rendering.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:oppo_gdu/src/support/url.dart' as UrlUtils;
import 'package:yandex_mapkit/yandex_mapkit.dart';

class ContactsView extends StatefulWidget implements ViewContract
{
    final ContactsPresenter presenter;

    ContactsView({Key key, this.presenter}): super(key: key);

    @override
    _ContactsViewState createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> implements ViewFutureContract<Contacts>
{
    Contacts _contacts;

    bool _isError = false;

    double _flexibleSpaceHeight = 200.0;

    bool _appBarTitleVisibled = false;

    double _appBarTitleMarginTop = 0;

    double _bodyTitleMarginTop = 16;

    BottomNavigationController _bottomNavigationBarController;

    YandexMapController _yandexMapController;

    @override
    void initState()
    {
        super.initState();

        _bottomNavigationBarController = BottomNavigationController();
        _bottomNavigationBarController.delegate = widget.presenter;

        widget.presenter?.onInitState(this);
    }

    @override
    void didUpdateWidget(ContactsView oldWidget)
    {
        super.didUpdateWidget(oldWidget);

        widget.presenter?.onInitState(this);
    }

    @override
    void didChangeDependencies()
    {
        super.didChangeDependencies();

        widget.presenter?.onInitState(this);
    }

    void onLoad(Contacts contacts)
    {
        setState(() {
            _contacts = contacts;
        });
    }

    void onError()
    {
        setState(() {
            _isError = true;
        });
    }

    @override
    Widget build(BuildContext context)
    {
        return _contacts == null
            ? (_isError ? _buildErrorWidget(context) : _buildLoadingWidget(context))
            : _buildWidget(context);
    }

    Widget _buildLoadingWidget(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(
                title: Text("Загрузка"),
            ),
            body: Center(
                child: CircularProgressIndicator(),
            ),
            bottomNavigationBar: BottomNavigationWidget(
                controller: _bottomNavigationBarController,
            ),
            drawer: DrawerNavigationWidget(
                delegate: widget.presenter,
                currentIndex: DrawerNavigationWidget.contactsItem
            ),
        );
    }

    Widget _buildErrorWidget(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(
                title: Text("Ошибка"),
            ),
            body: Center(
                child: Text(
                    "Возникла ошибка при загрузке данных"
                ),
            ),
            bottomNavigationBar: BottomNavigationWidget(
                controller: _bottomNavigationBarController,
            ),
            drawer: DrawerNavigationWidget(
                delegate: widget.presenter,
                currentIndex: DrawerNavigationWidget.contactsItem
            ),
        );
    }

    Widget _buildWidget(BuildContext context)
    {
        return Scaffold(
            body: RefreshIndicator(
                child: NotificationListener<ScrollNotification>(
                    child:  CustomScrollView(
                        slivers: [
                            _buildAppBar(context),
                            SliverToBoxAdapter(
                                child: Card(
                                    child: Padding(
                                        padding: EdgeInsets.all(_bodyTitleMarginTop),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                Text(
                                                    _contacts.name,
                                                    style: Theme.of(context).textTheme.headline,
                                                )
                                            ],
                                        ),
                                    ),
                                ),
                            ),
                            _buildContactsWidget(context)
                        ]
                    ),
                    onNotification: _onUserScroll,
                ),
                onRefresh: _onRefresh,
            ),
            bottomNavigationBar: BottomNavigationWidget(
                controller: _bottomNavigationBarController,
            ),
            drawer: DrawerNavigationWidget(
                delegate: widget.presenter,
                currentIndex: DrawerNavigationWidget.contactsItem,
            ),
        );
    }

    Widget _buildAppBar(BuildContext context)
    {
        if(_contacts.logo == null) {
            _flexibleSpaceHeight = kToolbarHeight;

            return SliverAppBar(
                centerTitle: false,
                floating: false,
                pinned: true,
                title: _buildAppBarTitle(context),
            );
        } else {
            return SliverAppBar(
                centerTitle: false,
                expandedHeight: _flexibleSpaceHeight,
                floating: false,
                pinned: true,
                title: _buildAppBarTitle(context),
                flexibleSpace: FlexibleSpaceBar(
                    background: Image(
                        image: CachedNetworkImageProvider(_contacts.logo),
                        fit: BoxFit.cover,
                    ),
                ),
            );
        }
    }

    Widget _buildAppBarTitle(BuildContext context)
    {
        if(_appBarTitleVisibled) {
            return ClipRect(
                child: Padding(
                    padding: EdgeInsets.only(top: _appBarTitleMarginTop),
                    child: Text(_contacts.name, textScaleFactor: 0.6),
                ),
            );
        }

        return null;
    }

    Widget _buildContactsWidget(BuildContext context)
    {
        List<Widget> contactWidgets = List<Widget>();

        if(_contacts.phone != null && _contacts.phone.isNotEmpty) {
            contactWidgets.add(
                Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: Text("Телефон:"),
                            ),
                            InkWell(
                                child: Text(_contacts.phone),
                                onTap: () {
                                    UrlUtils.launchUrl("tel:${_contacts.phone}");
                                },
                            )
                        ],
                    ),
                )
            );
        }

        if(_contacts.email != null && _contacts.email.isNotEmpty) {
            contactWidgets.add(
                Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: Text("E-mail:"),
                            ),
                            InkWell(
                                child: Text(_contacts.email),
                                onTap: () {
                                    UrlUtils.launchUrl("mailto:${_contacts.email}");
                                },
                            )
                        ],
                    ),
                )
            );
        }

        if(_contacts.city != null && _contacts.city.isNotEmpty) {
            contactWidgets.add(
                Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: Text("Город:"),
                            ),
                            Text(_contacts.city),
                        ],
                    ),
                )
            );
        }

        if(_contacts.address != null && _contacts.address.isNotEmpty) {
            contactWidgets.add(
                Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: Text("Адрес:"),
                            ),
                            Text(_contacts.address),
                        ],
                    ),
                )
            );
        }

        if(_contacts.latitude != null && _contacts.longitude != null) {
            contactWidgets.add(
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 200,
                    child: YandexMap(
                        onMapCreated: (controller) async {
                            _yandexMapController = controller;
                            
                            _yandexMapController.move(
                                point: Point(
                                    latitude: _contacts.latitude,
                                    longitude: _contacts.longitude
                                ),
                                zoom: 14,
                                animation: MapAnimation(
                                    smooth: true,
                                    duration: 2.0
                                )
                            );

                            _yandexMapController.addPlacemark(
                                Placemark(
                                    point: Point(
                                        latitude: _contacts.latitude,
                                        longitude: _contacts.longitude
                                    ),
                                )
                            );
                        },
                    ),
                )
            );
        }

        return SliverToBoxAdapter(
            child: Card(
                child: Padding(
                    padding: EdgeInsets.all(_bodyTitleMarginTop),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: contactWidgets,
                    ),
                ),
            ),
        );
    }

    bool _onUserScroll(ScrollNotification notification)
    {
        double scrollTop = notification.metrics.pixels;

        if(scrollTop > _flexibleSpaceHeight - kToolbarHeight + _bodyTitleMarginTop) {
            if(!_appBarTitleVisibled) {
                setState(() {
                    _appBarTitleVisibled = true;
                    _appBarTitleMarginTop = kToolbarHeight;
                });
            } else {
                setState(() {
                    _appBarTitleMarginTop = _flexibleSpaceHeight - scrollTop + _bodyTitleMarginTop;

                    if(_appBarTitleMarginTop < 0) {
                        _appBarTitleMarginTop = 0;
                    }
                });
            }
        } else {
            if (_appBarTitleVisibled) {
                setState(() {
                    _appBarTitleVisibled = false;
                });
            }
        }

        if(notification is UserScrollNotification) {
            if(notification.direction == ScrollDirection.forward) {
                _bottomNavigationBarController.show();
            }

            if(notification.direction == ScrollDirection.reverse) {
                _bottomNavigationBarController.hide();
            }
        }

        return true;
    }

    Future<void> _onRefresh() async
    {
        widget.presenter?.didRefresh();
    }
}