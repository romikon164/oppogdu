import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';
import '../view_contract.dart';
import 'package:oppo_gdu/src/presenters/organizations/detail.dart';
import '../future_contract.dart';
import 'package:oppo_gdu/src/data/models/users/organization.dart';
import 'package:oppo_gdu/src/data/models/users/worker.dart';
import '../../components/markdown/markdown.dart';
import 'package:oppo_gdu/src/support/url.dart' as UrlService;
import '../../components/widgets/loading.dart';
import '../../components/widgets/empty.dart';
import '../../components/widgets/scaffold.dart';
import '../../components/widgets/scrolled_title.dart';
import '../../components/users/worker.dart';
import 'package:oppo_gdu/src/support/url.dart' as UrlUtils;
import '../../components/widgets/static_google_map.dart';

class OrganizationDetailView extends StatefulWidget implements ViewContract
{
    final OrganizationDetailPresenter presenter;

    OrganizationDetailView({Key key, @required this.presenter}): super(key: key);

    @override
    _OrganizationDetailViewState createState() => _OrganizationDetailViewState();
}

class _OrganizationDetailViewState extends State<OrganizationDetailView> implements ViewFutureContract<Organization>
{
    Organization _organization;

    bool _isError = false;

    @override
    void initState()
    {
        super.initState();

        widget.presenter?.onInitState(this);
    }

    @override
    void didUpdateWidget(OrganizationDetailView oldWidget)
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

    void onLoad(Organization data)
    {
        setState(() {
            _organization = data;
            print(data.toMap());
        });
    }

    void onError()
    {
        setState(() {
            _isError = true;
        });
    }

    @override
    Widget build(BuildContext context) {
        return _organization == null
            ? (_isError ? _buildErrorWidget(context) : _buildLoadingWidget(context))
            : _buildWidget(context);
    }

    Widget _buildWidget(BuildContext context)
    {
        List<Widget> tabs = List<Widget>();
        List<Widget> views = List<Widget>();
        
        _buildTabs(context, tabs, views);


        return ScaffoldWithBottomNavigation(
            includeDrawer: false,
            bottomNavigationDelegate: widget.presenter,
            body: DefaultTabController(
                length: tabs.length,
                child: NestedScrollView(
                    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                        return [
                            _buildAppBar(context),
                            SliverPersistentHeader(
                                delegate: _SliverAppBarDelegate(
                                    TabBar(
                                        isScrollable: true,
                                        tabs: tabs,
                                    ),
                                ),
                                pinned: true,
                            )
                        ];
                    },
                    body: TabBarView(
                        children: views,
                    )
                )
            )
        );
    }

    Widget _buildAppBar(BuildContext context)
    {
        if(_organization.image != null && _organization.image.isNotEmpty) {
            return SliverAppBar(
                floating: true,
                pinned: true,
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    centerTitle: true,
                    title: Container(
                        width: MediaQuery.of(context).size.width - 90,
                        child: Text(
                            _organization.name,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                shadows: [
                                    Shadow(color: Colors.black12, offset: Offset(2.0, 3.0))
                                ]
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                        ),
                    ),
                    background: Image.network(_organization.image, fit: BoxFit.cover),
                )
            );
        } else {
            return SliverAppBar(
                floating: true,
                pinned: true,
                title: Text(_organization.name, style: TextStyle(fontSize: 12),),
            );
        }
    }

    Widget _buildLoadingWidget(BuildContext context)
    {
        return LoadingWidget(
            includeDrawer: false,
            bottomNavigationDelegate: widget.presenter,
        );
    }

    Widget _buildErrorWidget(BuildContext context)
    {
        return EmptyWidget(
            includeDrawer: false,
            bottomNavigationDelegate: widget.presenter,
            appBarTitle: 'Ошибка',
            emptyMessage: 'Возникла ошибка при загрузке данных',
        );
    }
    
    void _buildTabs(BuildContext context, List<Widget> tabs, List<Widget> views)
    {
        tabs.add(
            Tab(text: "Об организации")
        );

        Widget descriptionWidget;
        if(_organization.description != null && _organization.description.isNotEmpty) {
            descriptionWidget = MarkDownComponent(
                data: _organization.description,
                onTapLink: _onTapBodyLink,
                onTapImage: _onTapBodyImage,
            );
        } else {
            descriptionWidget = Center(child: Text("Пусто"));
        }

        views.add(
            SingleChildScrollView(
                child: Container(
                    child: descriptionWidget,
                    padding: EdgeInsets.all(12),
                    color: Colors.white,
                ),
            )
        );

        if(_organization.address != null && _organization.address.isNotEmpty) {
            tabs.add(Tab(text: "Контакты"));
            views.add(
                Stack(
                    fit: StackFit.expand,
                    children: [
                        _buildMap(context),
                        _buildContacts(context),
                    ],
                )
            );
        }

        List<Worker> workers = _organization.workers;

        if(_organization.chairman != null) {
            _organization.chairman.position = 'Председатель';
            workers.insert(0, _organization.chairman);
        }

        if(workers.isNotEmpty) {
            tabs.add(Tab(text: "Сотрудники"));
            views.add(_buildWorkerList(context, workers));
        }

        if(_organization.commissioners.isNotEmpty) {
            tabs.add(Tab(text: "Уполномоченные по охране труда"));
            views.add(
                _buildWorkerList(
                    context,
                    _organization.commissioners.map((worker) {
                        worker.position = 'Уполномоченный по охране труда';
                        return worker;
                    }).toList()
                )
            );
        }
    }

    Widget _buildWorkerList(BuildContext context, List<Worker> workers)
    {
        print(workers);
        return ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: workers.length,
            itemBuilder: (BuildContext context, int index) {
                if(index < workers.length) {
                    Worker worker = workers[index];

                    return WorkerListItemWidget(
                        name: worker.name,
                        position: worker.position,
                        phone: worker.phone,
                        email: worker.email,
                        photo: worker.photo,
                        onTap: () {
                            widget.presenter?.didTapWorkerItem(worker);
                        },
                    );
                }
            }
        );
    }

    Widget _buildMap(BuildContext context)
    {
        return StaticGoogleMap(
            latitude: _organization.latitude,
            longitude: _organization.longitude,
            zoom: 17,
            width: 640,
            height: 440,
        );
    }

    Widget _buildContacts(BuildContext context)
    {
        List<Widget> contactWidgets = List<Widget>();

        if(_organization.phone != null && _organization.phone.isNotEmpty) {
            contactWidgets.add(
                _buildContactItem(
                    context,
                    name: 'Телефон',
                    value: _organization.phone,
                    onTap: () {
                        UrlUtils.launchUrl("tel:${_organization.phone}");
                    }
                )
            );
        }

        if(_organization.email != null && _organization.email.isNotEmpty) {
            contactWidgets.add(
                _buildContactItem(
                    context,
                    name: 'E-mail',
                    value: _organization.email,
                    onTap: () {
                        UrlUtils.launchUrl("mailto:${_organization.email}");
                    }
                )
            );
        }

        if(_organization.address != null && _organization.address.isNotEmpty) {
            contactWidgets.add(
                _buildContactItem(
                    context,
                    name: 'Адрес',
                    value: _organization.address,
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

    void _onTapBodyImage(String src, String title, String alt)
    {
        widget.presenter?.router?.presentSinglePhoto(src, title: title);
    }

    void _onTapBodyLink(String href)
    {
        UrlService.launchUrl(href);
    }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {

    final TabBar _tabBar;

    _SliverAppBarDelegate(this._tabBar);

    @override
    double get minExtent => _tabBar.preferredSize.height;
    @override
    double get maxExtent => _tabBar.preferredSize.height;

    @override
    Widget build(
        BuildContext context, double shrinkOffset, bool overlapsContent) {
        return new Container(
            color: Colors.white,
            child: _tabBar,
        );
    }

    @override
    bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
        return false;
    }

}