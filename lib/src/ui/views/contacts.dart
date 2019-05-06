import 'package:flutter/material.dart';
import 'future_contract.dart';
import 'package:oppo_gdu/src/data/models/contacts.dart';
import '../components/navigation/drawer/widget.dart';
import 'view_contract.dart';
import 'package:oppo_gdu/src/presenters/contacts.dart';
import 'package:flutter/rendering.dart';
import 'package:oppo_gdu/src/support/url.dart' as UrlUtils;
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../components/widgets/loading.dart';
import '../components/widgets/empty.dart';
import '../components/widgets/scaffold.dart';
import 'package:flutter/gestures.dart';

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

    YandexMapController _yandexMapController;

    @override
    void initState()
    {
        super.initState();

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
            if(_yandexMapController != null) {
                _yandexMapController.move(
                    point: Point(
                        latitude: _contacts.latitude,
                        longitude: _contacts.longitude
                    ),
                    zoom: 17,
                    animation: MapAnimation(
                        smooth: true,
                        duration: 2.0
                    )
                );
            }
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
        return LoadingWidget(
            includeDrawer: true,
            drawerDelegate: widget.presenter,
            drawerCurrentIndex: DrawerNavigationWidget.contactsItem,
            bottomNavigationDelegate: widget.presenter,
        );
    }

    Widget _buildErrorWidget(BuildContext context)
    {
        return EmptyWidget(
            includeDrawer: true,
            drawerDelegate: widget.presenter,
            drawerCurrentIndex: DrawerNavigationWidget.contactsItem,
            bottomNavigationDelegate: widget.presenter,
            appBarTitle: 'Ошибка',
            emptyMessage: 'Возникла ошибка при загрузке данных',
        );
    }

    Widget _buildWidget(BuildContext context)
    {
        return ScaffoldWithBottomNavigation(
            appBar: AppBar(
                title: Text('Контакты'),
                actions: [
                    IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: _onRefresh,
                    )
                ],

            ),
            drawerDelegate: widget.presenter,
            drawerCurrentIndex: DrawerNavigationWidget.contactsItem,
            bottomNavigationDelegate: widget.presenter,
            body: SafeArea(
                child: Stack(
                    fit: StackFit.expand,
                    children: [
                        _buildMap(context),
                        _buildContacts(context),
                    ],
                )
            ),
        );
    }

    Widget _buildMap(BuildContext context)
    {
        return YandexMap(
            onMapCreated: (controller) async {
                _yandexMapController = controller;

                _yandexMapController.move(
                    point: Point(
                        latitude: _contacts.latitude,
                        longitude: _contacts.longitude
                    ),
                    zoom: 17,
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
                        iconName: 'assets/place2.png'
                    )
                );
            },
        );
    }

    Widget _buildContacts(BuildContext context)
    {
        List<Widget> contactWidgets = List<Widget>();

        if(_contacts.phone != null && _contacts.phone.isNotEmpty) {
            contactWidgets.add(
                _buildContactItem(
                    context,
                    name: 'Телефон',
                    value: _contacts.phone,
                    onTap: () {
                        UrlUtils.launchUrl("tel:${_contacts.phone}");
                    }
                )
            );
        }

        if(_contacts.email != null && _contacts.email.isNotEmpty) {
            contactWidgets.add(
                _buildContactItem(
                    context,
                    name: 'E-mail',
                    value: _contacts.email,
                    onTap: () {
                        UrlUtils.launchUrl("mailto:${_contacts.email}");
                    }
                )
            );
        }

        if(_contacts.address != null && _contacts.address.isNotEmpty) {
            contactWidgets.add(
                _buildContactItem(
                    context,
                    name: 'Адрес',
                    value: _contacts.address,
                    onTap: () {}
                )
            );
        }

        return Positioned(
            bottom: 0,
            left: 12,
            right: 12,
            child: Card(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: contactWidgets,
                    ),
                ),
            ),
        );
    }

    Widget _buildContactItem(BuildContext context, {String name, String value, VoidCallback onTap})
    {
        TapGestureRecognizer tapGestureRecognizer;

        if(onTap != null) {
            tapGestureRecognizer = TapGestureRecognizer();
            tapGestureRecognizer.onTap = onTap;
        }

        return Padding(
            padding: EdgeInsets.only(top: 4, bottom: 4),
            child: Container(
                width: MediaQuery.of(context).size.width - 40,
                child: RichText(
                    text: TextSpan(
                        children: [
                            TextSpan(
                                text: "$name: ",
                                style: Theme.of(context).textTheme.headline
                            ),
                            TextSpan(
                                text: value,
                                style: Theme.of(context).textTheme.headline.copyWith(fontWeight: FontWeight.normal),
                                recognizer: tapGestureRecognizer
                            )
                        ]
                    ),
                ),
            ),
        );
    }

    Future<void> _onRefresh() async
    {
        await widget.presenter?.didRefresh();
    }
}