import 'package:flutter/material.dart';
import 'future_contract.dart';
import 'package:oppo_gdu/src/data/models/contacts.dart';
import '../components/navigation/drawer/widget.dart';
import 'view_contract.dart';
import 'package:oppo_gdu/src/presenters/contacts.dart';
import 'package:flutter/rendering.dart';
import 'package:oppo_gdu/src/support/url.dart' as UrlUtils;
import '../components/widgets/loading.dart';
import '../components/widgets/empty.dart';
import '../components/widgets/scaffold.dart';
import 'package:flutter/gestures.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

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

    Completer<GoogleMapController> _mapsController = Completer();

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

    void _onMapCreated(GoogleMapController controller) {
        _mapsController.complete(controller);
    }

    Widget _buildMap(BuildContext context)
    {
        Set<Marker> markers = Set<Marker>();

        markers.add(
            Marker(
                markerId: MarkerId("company-location"),
                position: LatLng(_contacts.latitude, _contacts.longitude)
            )
        );

        return GoogleMap(
            myLocationButtonEnabled: false,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
                target: LatLng(_contacts.latitude, _contacts.longitude),
                zoom: 17.0,
            ),
            markers: markers,
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