import 'package:flutter/material.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';
import 'package:oppo_gdu/src/presenters/sportcomplex/sportcomplex.dart';
import 'package:oppo_gdu/src/ui/components/widgets/scaffold.dart';
import 'package:oppo_gdu/src/ui/components/navigation/drawer/widget.dart';
import 'package:oppo_gdu/src/ui/components/navigation/bottom/widget.dart';
import 'package:oppo_gdu/src/ui/views/sportcomplex/about.dart';
import 'package:oppo_gdu/src/ui/views/sportcomplex/schedule.dart';
import 'package:oppo_gdu/src/ui/views/sportcomplex/trainers.dart';
import 'package:oppo_gdu/src/ui/views/sportcomplex/leadership.dart';
import '../../flutter_fixes/bottom_sheet.dart' as FlutterFixBottomSheet;
import 'package:oppo_gdu/src/data/models/sportcomplex/schedule_filter.dart';
import 'package:oppo_gdu/src/ui/views/sportcomplex/schedule_filter.dart';
import 'package:oppo_gdu/src/data/repositories/sportcomplex/trainers/api_repository.dart';
import 'package:oppo_gdu/src/data/repositories/sportcomplex/halls/api_repository.dart';
import 'package:oppo_gdu/src/data/models/sportcomplex/hall.dart';
import 'package:oppo_gdu/src/data/models/sportcomplex/trainer.dart';

class SportComplexView extends StatefulWidget implements ViewContract
{
    final SportComplexPresenter presenter;

    SportComplexView({Key key, this.presenter}): super(key: key);

    @override
    _SportComplexViewState createState() => _SportComplexViewState();
}

class _SportComplexViewState extends State<SportComplexView> with SingleTickerProviderStateMixin
{
    static const APP_BAR_TITLE = "Спортивный комплекс";

    static const TAB_ABOUT_INDEX = 0;
    static const TAB_SCHEDULE_INDEX = 1;
    static const TAB_TRAINERS_INDEX = 2;
    static const TAB_LEADERSHIP_INDEX = 3;

    static const TAB_ABOUT_TITLE = "Описание";
    static const TAB_SCHEDULE_TITLE = "Расписание";
    static const TAB_TRAINERS_TITLE = "Тренерский состав";
    static const TAB_LEADERSHIP_TITLE = "Руководство";

    GlobalKey<SportComplexScheduleState> _scheduleState = GlobalKey<SportComplexScheduleState>();

    TabController _tabController;
    int _currentTabIndex = TAB_ABOUT_INDEX;

    /*
     * Schedule filters
     */
    bool _scheduleFilterViewShowed = false;
    ScheduleFilter _scheduleFilter = ScheduleFilter(date: DateTime.now());

    TrainerApiRepository _trainerApiRepository = TrainerApiRepository();
    HallApiRepository _hallApiRepository = HallApiRepository();

    List<Trainer> _trainers;
    List<Hall> _halls;

    @override
    void initState()
    {
        super.initState();

        _tabController = TabController(
            initialIndex: _currentTabIndex,
            length: _tabsCount(),
            vsync: this
        );
        _tabController.addListener(_onTabChange);

        _loadTrainers();
        _loadHalls();
    }

    @override
    void dispose()
    {
        _tabController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context)
    {
        return ScaffoldWithBottomNavigation(
            drawerDelegate: widget.presenter,
            drawerCurrentIndex: DrawerNavigationWidget.sportComplexItem,
            bottomNavigationDelegate: widget.presenter,
            bottomNavigationCurrentIndex: BottomNavigationWidget.sportComplexItem,
            body: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                        _buildAppBar(context),
                        SliverPersistentHeader(
                            delegate: _SliverAppBarDelegate(
                                TabBar(
                                    controller: _tabController,
                                    isScrollable: true,
                                    tabs: _buildTabs(context),
                                ),
                            ),
                            pinned: true,
                        )
                    ];
                },
                body: TabBarView(
                    controller: _tabController,
                    children: _buildViews(context),
                )
            ),
        );
    }

    Future<void> _loadTrainers() async
    {
        if(_trainers == null) {
            try {
                _trainers = await _trainerApiRepository.get();
            } catch(e) {
                //
            }
        }
    }

    Future<void> _loadHalls() async
    {
        if(_halls == null) {
            try {
                _halls = await _hallApiRepository.get();
            } catch(e) {
                //
            }
        }
    }

    int _tabsCount()
    {
        return 4;
    }

    List<Widget> _buildTabs(BuildContext context)
    {
        return [
            Tab(text: TAB_ABOUT_TITLE),
            Tab(text: TAB_SCHEDULE_TITLE),
            Tab(text: TAB_TRAINERS_TITLE),
            Tab(text: TAB_LEADERSHIP_TITLE),
        ];
    }

    List<Widget> _buildViews(BuildContext context)
    {
        return [
            SportComplexAboutView(),
            SportComplexScheduleView(
                key: _scheduleState,
                filter: _scheduleFilter,
            ),
            SportComplexTrainersView(router: widget.presenter.router,),
            SportComplexLeadershipView(router: widget.presenter.router,),
        ];
    }

    Widget _buildAppBar(BuildContext context)
    {
        return SliverAppBar(
            floating: true,
            pinned: true,
            title: Text(APP_BAR_TITLE),
            actions: _buildAppBarActions(context),
        );
    }

    List<Widget> _buildAppBarActions(BuildContext context)
    {
        if (_currentTabIndex == TAB_SCHEDULE_INDEX) {
            return _buildAppBarScheduleActions(context);
        }

        return [];
    }

    List<Widget> _buildAppBarScheduleActions(BuildContext context)
    {
        return [
            IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: _showScheduleFilterView,
            )
        ];
    }

    void _onTabChange()
    {
        if (_currentTabIndex != _tabController.index) {
            setState(() {
                _currentTabIndex = _tabController.index;
            });
        }
    }

    void _showScheduleFilterView()
    {
        if (_scheduleFilterViewShowed) {
            return ;
        }

        setState(() {
            _scheduleFilterViewShowed = true;
        });

        FlutterFixBottomSheet.showModalBottomSheet(context: context, builder: (BuildContext context) {
            return ScheduleFilterView(
                filter: _scheduleFilter,
                trainers: _trainers ?? [],
                halls: _halls ?? [],
            );
        }).then((dynamic data) {
            _scheduleState.currentState.schedules = null;
            _scheduleState.currentState.loadSchedules();
            setState(() {
                _scheduleFilterViewShowed = false;

                if(data is ScheduleFilter) {
                    _scheduleFilter = data;
                }
            });

        });
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