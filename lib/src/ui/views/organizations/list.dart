import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../view_contract.dart';
import 'package:oppo_gdu/src/presenters/organizations/list.dart';
import '../future_contract.dart';
import '../../components/navigation/drawer/widget.dart';
import 'package:oppo_gdu/src/data/models/users/organization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../components/widgets/loading.dart';
import '../../components/widgets/empty.dart';
import '../../components/widgets/scaffold.dart';

class OrganizationListView extends StatefulWidget implements ViewContract
{
    final OrganizationListPresenter presenter;

    OrganizationListView({Key key, this.presenter}): super(key: key);

    @override
    _OrganizationListViewState createState() => _OrganizationListViewState();
}

class _OrganizationListViewState extends State<OrganizationListView> implements ViewFutureContract<List<Organization>>
{
    List<Organization> _organizations;

    bool _isError = false;

    String _noPhotoImage = 'http://api.oppo-gdu.ru/img/no-photo-organization.jpg';

    _OrganizationListViewState(): super();

    @override
    void initState()
    {
        super.initState();

        widget.presenter?.onInitState(this);
    }

    @override
    void didUpdateWidget(OrganizationListView oldWidget)
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

    void onLoad(List<Organization> data)
    {
        setState(() {
            _organizations = data;
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
        return _organizations == null
            ? (_isError ? _buildErrorWidget(context) : _buildLoadingWidget(context))
            : _buildWidget(context);
    }

    Widget _buildLoadingWidget(BuildContext context)
    {
        return LoadingWidget(
            drawerDelegate: widget.presenter,
            drawerCurrentIndex: DrawerNavigationWidget.leadersItem,
            bottomNavigationDelegate: widget.presenter,
        );
    }

    Widget _buildErrorWidget(BuildContext context)
    {
        return EmptyWidget(
            drawerDelegate: widget.presenter,
            drawerCurrentIndex: DrawerNavigationWidget.leadersItem,
            bottomNavigationDelegate: widget.presenter,
            appBarTitle: 'Ошибка',
            emptyMessage: 'Возникла ошибка при загрузке данных',
        );
    }

    Widget _buildWidget(BuildContext context)
    {
        return ScaffoldWithBottomNavigation(
            drawerDelegate: widget.presenter,
            drawerCurrentIndex: DrawerNavigationWidget.structureItem,
            bottomNavigationDelegate: widget.presenter,
            body: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                        SliverAppBar(
                            title: Text("Структура"),
                            floating: true,
                            snap: true,
                        )
                    ];
                },
                body: Builder(
                    builder: (BuildContext context) {
                        return RefreshIndicator(
                            child: _buildOrganizationsWidget(context),
                            onRefresh: _onRefresh,
                        );
                    },
                )
            ),
        );
    }

    Widget _buildOrganizationsWidget(BuildContext context)
    {
        if(_organizations.isEmpty) {
            return Center(
                child: Text("Пусто"),
            );
        } else {
            return ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: _organizations.length,
                itemBuilder: _buildOrganizationItemWidget,
            );
        }
    }

    Widget _buildOrganizationItemWidget(BuildContext context, int index)
    {
        if(_organizations == null || index >= _organizations.length) {
            return null;
        }

        Organization organization = _organizations[index];

        List<Widget> widgets = [
            Padding(
                padding: EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Text(
                    organization.name,
                    style: Theme.of(context).textTheme.headline,
                ),
            )
        ];

        if(organization.address != null && organization.address.isNotEmpty) {
            widgets.add(
                Padding(
                    padding: EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            Icon(
                                Icons.place,
                                size: 16,
                                color: Colors.black54,
                            ),
                            Container(width: 8),
                            Container(
                                width: MediaQuery.of(context).size.width - 180,
                                child: Text(
                                    organization.address,
                                    style: Theme.of(context).textTheme.overline
                                ),
                            )
                        ],
                    ),
                )
            );
        }

        if(organization.phone != null && organization.phone.isNotEmpty) {
            widgets.add(
                Padding(
                    padding: EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            Icon(
                                Icons.phone,
                                size: 16,
                                color: Colors.black54,
                            ),
                            Container(width: 8),
                            Text(
                                organization.phone,
                                style: Theme.of(context).textTheme.overline
                            )
                        ],
                    ),
                )
            );
        }

        if(organization.email != null && organization.email.isNotEmpty) {
            widgets.add(
                Padding(
                    padding: EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            Icon(
                                Icons.alternate_email,
                                size: 16,
                                color: Colors.black54,
                            ),
                            Container(width: 8),
                            Text(
                                organization.email,
                                style: Theme.of(context).textTheme.overline
                            )
                        ],
                    ),
                )
            );
        }

        return Card(
            child: InkWell(
                onTap: () {
                    widget.presenter?.didTapLeadershipItem(organization);
                },
                child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Flexible(
                            child: CachedNetworkImage(
                                imageUrl: organization.thumb ?? _noPhotoImage,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover
                            ),
                            flex: 0,
                            fit: FlexFit.tight,
                        ),
                        Flexible(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: widgets,
                            ),
                            flex: 1,
                            fit: FlexFit.loose,
                        )
                    ],
                )
            ),
        );
    }

    Future<void> _onRefresh() async
    {
        widget.presenter?.didRefresh();
    }
}