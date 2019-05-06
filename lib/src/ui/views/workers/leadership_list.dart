import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../view_contract.dart';
import 'package:oppo_gdu/src/presenters/workers/leadership_list.dart';
import '../future_contract.dart';
import '../../components/navigation/drawer/widget.dart';
import 'package:oppo_gdu/src/data/models/users/worker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../components/widgets/loading.dart';
import '../../components/widgets/empty.dart';
import '../../components/widgets/scaffold.dart';

class LeadershipListView extends StatefulWidget implements ViewContract
{
    final LeadershipListPresenter presenter;

    LeadershipListView({Key key, this.presenter}): super(key: key);

    @override
    _LeadershipListViewState createState() => _LeadershipListViewState();
}

class _LeadershipListViewState extends State<LeadershipListView> implements ViewFutureContract<List<Worker>>
{
    List<Worker> _leaderships;

    bool _isError = false;

    _LeadershipListViewState(): super();

    @override
    void initState()
    {
        super.initState();

        widget.presenter?.onInitState(this);
    }

    @override
    void didUpdateWidget(LeadershipListView oldWidget)
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

    void onLoad(List<Worker> data)
    {
        setState(() {
            _leaderships = data;
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
        return _leaderships == null
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
            drawerCurrentIndex: DrawerNavigationWidget.leadersItem,
            bottomNavigationDelegate: widget.presenter,
            body: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                      SliverAppBar(
                          title: Text("Руководство"),
                          floating: true,
                          snap: true,
                      )
                  ];
              },
              body: Builder(
                  builder: (BuildContext context) {
                      return RefreshIndicator(
                          child: _buildLeadershipWidget(context),
                          onRefresh: _onRefresh,
                      );
                  },
              )
            ),
        );
    }

    Widget _buildLeadershipWidget(BuildContext context)
    {
        if(_leaderships.isEmpty) {
            return Center(
                child: Text("Пусто"),
            );
        } else {
            return ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: _leaderships.length,
                itemBuilder: _buildLeadershipItemWidget,
            );
        }
    }

    Widget _buildLeadershipItemWidget(BuildContext context, int index)
    {
        if(_leaderships == null || index >= _leaderships.length) {
            return null;
        }

        Worker leadership = _leaderships[index];

        List<Widget> widgets = [
            Padding(
                padding: EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Text(
                    leadership.name,
                    style: Theme.of(context).textTheme.headline,
                ),
            )
        ];

        if(leadership.position != null && leadership.position.isNotEmpty) {
            widgets.add(
              Padding(
                  padding: EdgeInsets.fromLTRB(12, 0, 12, 8),
                  child: Text(
                    leadership.position,
                    style: Theme.of(context).textTheme.overline
                  ),
              )
            );
        }

        if(leadership.phone != null && leadership.phone.isNotEmpty) {
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
                            leadership.phone,
                            style: Theme.of(context).textTheme.overline
                          )
                      ],
                  ),
              )
            );
        }

        if(leadership.email != null && leadership.email.isNotEmpty) {
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
                            leadership.email,
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
                  widget.presenter?.didTapLeadershipItem(leadership);
              },
              child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Flexible(
                          child: CachedNetworkImage(
                            imageUrl: leadership.thumb,
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