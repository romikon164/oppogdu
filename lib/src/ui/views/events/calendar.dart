import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../view_contract.dart';
import 'package:oppo_gdu/src/presenters/events/calendar.dart';
import '../future_contract.dart';
import '../../components/navigation/drawer/widget.dart';
import '../../components/navigation/bottom/widget.dart';
import 'package:oppo_gdu/src/data/models/events/event.dart';
import 'package:oppo_gdu/src/data/models/events/category.dart';
import '../../components/widgets/loading.dart';
import '../../components/widgets/empty.dart';
import '../../components/widgets/scaffold.dart';
import 'package:oppo_gdu/src/support/datetime/formatter.dart';
import 'package:table_calendar/table_calendar.dart';

class EventsCalendarView extends StatefulWidget implements ViewContract
{
    final EventsCalendarPresenter presenter;

    EventsCalendarView({Key key, this.presenter}): super(key: key);

    @override
    _EventsCalendarViewState createState() => _EventsCalendarViewState();
}

class _EventsCalendarViewState extends State<EventsCalendarView>
    with TickerProviderStateMixin
    implements ViewFutureContract<List<Event>>

{
    List<Event> _events;

    List<Event> _filteredByCategoryEvents;

    List<Event> _filteredEvents;

    List<EventCategory> _categories;

    bool _isError = false;

    EventCategory _currentEventCategory;

    EventCategory _nullEventCategory = EventCategory(id: 0, name: "Все мероприятия");

    DateTime _selectedDay = DateTime.now();

    _EventsCalendarViewState(): super();

    @override
    void initState()
    {
        super.initState();

        _currentEventCategory = _nullEventCategory;

        widget.presenter?.onInitState(this);
    }

    @override
    void didUpdateWidget(EventsCalendarView oldWidget)
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

    void onLoad(List<Event> data)
    {
        setState(() {
            _events = data.map((event) {
                if(event.category == null) {
                    event.category = _nullEventCategory;
                }

                return event;
            }).toList();

            _updateCategoryList();
            _filterEventList();
        });
    }

    void onError()
    {
        setState(() {
            _isError = true;
        });
    }

    void _updateCategoryList()
    {
        _categories = List<EventCategory>();

        _events.forEach((event) {
            if(event.category != _nullEventCategory) {
                if(_categories.where((c) => c.name == event.category.name).isEmpty) {
                    _categories.add(event.category);
                }
            }
        });
    }

    void _filterEventList()
    {
        if(_currentEventCategory == _nullEventCategory) {
            _filteredByCategoryEvents = _events;
        } else {
            _filteredByCategoryEvents = _events.where(
                (event) => event.category.name == _currentEventCategory.name
            ).toList();
        }

        _filteredEvents = _filteredByCategoryEvents.where((event) {
            return event.startsAt.year == _selectedDay.year
                && event.startsAt.month == _selectedDay.month
                && event.startsAt.day == _selectedDay.day;
        }).toList();
    }

    @override
    Widget build(BuildContext context) {
        return _events == null
          ? (_isError ? _buildErrorWidget(context) : _buildLoadingWidget(context))
          : _buildWidget(context);
    }

    Widget _buildLoadingWidget(BuildContext context)
    {
        return LoadingWidget(
            drawerDelegate: widget.presenter,
            drawerCurrentIndex: DrawerNavigationWidget.sportComplexItem,
            bottomNavigationDelegate: widget.presenter,
            bottomNavigationCurrentIndex: BottomNavigationWidget.sportComplexItem,
        );
    }

    Widget _buildErrorWidget(BuildContext context)
    {
        return EmptyWidget(
            drawerDelegate: widget.presenter,
            drawerCurrentIndex: DrawerNavigationWidget.sportComplexItem,
            bottomNavigationDelegate: widget.presenter,
            bottomNavigationCurrentIndex: BottomNavigationWidget.sportComplexItem,
            appBarTitle: 'Ошибка',
            emptyMessage: 'Возникла ошибка при загрузке данных',
        );
    }

    Widget _buildWidget(BuildContext context)
    {
        return ScaffoldWithBottomNavigation(
            drawerDelegate: widget.presenter,
            drawerCurrentIndex: DrawerNavigationWidget.sportComplexItem,
            bottomNavigationDelegate: widget.presenter,
            bottomNavigationCurrentIndex: BottomNavigationWidget.sportComplexItem,
            appBar: _buildAppBar(context),
            body: SafeArea(
                child: Flex(
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                        Flexible(
                            fit: FlexFit.tight,
                            flex: 0,
                            child: _buildEventsWidget(context),
                        ),
                        Flexible(
                            fit: FlexFit.tight,
                            flex: 0,
                            child: Container(height: 1, color: Colors.white54),
                        ),
                        Flexible(
                            fit: FlexFit.loose,
                            flex: 1,
                            child: _buildEventListWidget(context),
                        )
                    ],
                )
            ),
        );
    }

    Widget _buildAppBar(BuildContext context)
    {
        Widget title;

        if(_categories.isEmpty) {
            title = Text("Спортивный комплекс");
        } else {
            title = PopupMenuButton<EventCategory>(
                child: Row(
                    children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width - 200,
                            child: Text(
                                _currentEventCategory.name,
                                style: Theme.of(context)
                                  .appBarTheme
                                  .textTheme
                                  .title
                                  .copyWith(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                            ),
                        ),
                        Padding(
                            child: Icon(Icons.arrow_drop_down, size: 24, color: Colors.white),
                            padding: EdgeInsets.all(8.0),
                        )
                    ],
                ),
                initialValue: _currentEventCategory,
                itemBuilder: _buildEventCategories,
                onSelected: (category) {
                    setState(() {
                        _currentEventCategory = category;
                        _filterEventList();
                    });
                },
            );
        }

        return AppBar(
            title: title,
            actions: [
                IconButton(
                    icon: Icon(Icons.refresh),
                    color: Colors.white,
                    onPressed: _onRefresh,
                )
            ]
        );
    }

    List<PopupMenuItem<EventCategory>> _buildEventCategories(BuildContext context)
    {
        if(_categories.isEmpty) {
            return [];
        }

        List<PopupMenuItem<EventCategory>> categoryWidgets = [
            PopupMenuItem<EventCategory>(
                value: _nullEventCategory,
                child: Text(_nullEventCategory.name),
            )
        ];

        _categories.forEach((category) {
            categoryWidgets.add(
              PopupMenuItem<EventCategory>(
                  value: category,
                  child: Text(category.name),
              )
            );
        });

        return categoryWidgets;
    }

    Widget _buildEventsWidget(BuildContext context)
    {
        return Card(
            margin: EdgeInsets.all(0),
            child: TableCalendar(
                selectedDay: DateTime.now(),
                locale: 'ru_RU',
                onDaySelected: (DateTime date, List<dynamic> events) {
                    setState(() {
                        _selectedDay = date;
                        _filterEventList();
                    });
                },
                availableGestures: AvailableGestures.horizontalSwipe,
                initialCalendarFormat: CalendarFormat.week,
                availableCalendarFormats: const {
                    CalendarFormat.week: '',
                    CalendarFormat.month: ''
                },
                headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    centerHeaderTitle: true
                ),
                calendarStyle: CalendarStyle(
                    markersMaxAmount: 1,
                    selectedColor: Theme.of(context).primaryColor,
                    todayColor: Theme.of(context).primaryColor.withOpacity(0.6),
                    weekendStyle: TextStyle(color: Theme.of(context).primaryColor),
                    holidayStyle: TextStyle(color: Theme.of(context).primaryColor),

                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                    weekendStyle: TextStyle(color: Theme.of(context).primaryColor)
                ),
                startingDayOfWeek: StartingDayOfWeek.monday,
                builders: CalendarBuilders(
                    selectedDayBuilder: _buildSelectedCalendarDay,
                    todayDayBuilder: _buildCalendarDay,
                    holidayDayBuilder: _buildWeekendDay,
                    weekendDayBuilder: _buildWeekendDay,
                    outsideDayBuilder: _buildOutsideCalendarDay,
                    outsideHolidayDayBuilder: _buildWeekendDay,
                    outsideWeekendDayBuilder: _buildWeekendDay,
                    markersBuilder: (context,date,events,_) { return []; },
                    dayBuilder: _buildCalendarDay
                ),
            ),
        );
    }

    Widget _buildEventListWidget(BuildContext context)
    {
        if(_filteredEvents.isEmpty) {
            return Center(
                child: Text("Событий нет"),
            );
        } else {
            return ListView.builder(
                padding: EdgeInsets.all(0),
                physics: BouncingScrollPhysics(),
                itemCount: _filteredEvents.length,
                itemBuilder: (BuildContext context, int index) {
                    return _buildEventItem(context, _filteredEvents[index]);
                }
            );
        }
    }

    Widget _buildEventItem(BuildContext context, Event event)
    {
        Duration timeToEvent = DateTime.now().difference(event.startsAt);
        bool isCurrentEvent = !timeToEvent.isNegative && timeToEvent.inMinutes < 60;

        return Card(
            margin: EdgeInsets.only(top: 8),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Container(
                        width: 4,
                        height: 80,
                        color: isCurrentEvent ? Colors.blueAccent : Colors.greenAccent,
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(8, 12, 8, 12),
                        child: Column(
                            children: [
                                Text(
                                    DateTimeFormatter.format(event.startsAt, pattern: "HH:mm"),
                                    style: Theme.of(context).textTheme.headline,
                                ),
                                Text(
                                    event.endsAt != null && event.endsAt.millisecondsSinceEpoch != 0
                                        ? DateTimeFormatter.format(event.startsAt, pattern: "HH:mm")
                                        : "",
                                    style: Theme.of(context).textTheme.headline,
                                )
                            ],
                        ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(8, 12, 8, 12),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                                SizedBox(
                                    child: Text(
                                        event.name,
                                        style: Theme.of(context).textTheme.headline,
                                    ),
                                    width: MediaQuery.of(context).size.width - 120,
                                ),
                                Container(height: 12),
                                SizedBox(
                                    child: Text(
                                        event.description ?? '',
                                        style: Theme.of(context).textTheme.overline,
                                    ),
                                    width: MediaQuery.of(context).size.width - 120,
                                ),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }

    Future<void> _onRefresh() async
    {
        widget.presenter?.didRefresh();
    }

    Widget _buildWeekendDay(BuildContext context, DateTime date, List<dynamic> events)
    {
        bool isEmptyEvents = _filteredByCategoryEvents.where((event) {
            return event.startsAt.year == date.year
              && event.startsAt.month == date.month
              && event.startsAt.day == date.day;
        }).toList().isEmpty;

        if(isEmptyEvents) {
            return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(shape: BoxShape.circle),
                margin: const EdgeInsets.all(6.0),
                alignment: Alignment.center,
                child: Text(
                    '${date.day}',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                ),
            );
        } else {
            return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                margin: const EdgeInsets.all(6.0),
                alignment: Alignment.center,
                child: Text(
                    '${date.day}',
                    style: TextStyle(color: Colors.white),
                ),
            );
        }
    }

    Widget _buildSelectedCalendarDay(BuildContext context, DateTime date, List<dynamic> events)
    {
        return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.pinkAccent),
            margin: const EdgeInsets.all(6.0),
            alignment: Alignment.center,
            child: Text(
                '${date.day}',
                style: TextStyle(color: Colors.white),
            ),
        );
    }

    Widget _buildCalendarDay(BuildContext context, DateTime date, List<dynamic> _)
    {
        bool isEmptyEvents = _filteredByCategoryEvents.where((event) {
            return event.startsAt.year == date.year
                && event.startsAt.month == date.month
                && event.startsAt.day == date.day;
        }).toList().isEmpty;

        if(isEmptyEvents) {
            return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(shape: BoxShape.circle),
                margin: const EdgeInsets.all(6.0),
                alignment: Alignment.center,
                child: Text(
                    '${date.day}',
                    style: TextStyle(color: Theme.of(context).textTheme.overline.color),
                ),
            );
        } else {
            return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                margin: const EdgeInsets.all(6.0),
                alignment: Alignment.center,
                child: Text(
                    '${date.day}',
                    style: TextStyle(color: Colors.white),
                ),
            );
        }
    }

    Widget _buildOutsideCalendarDay(BuildContext context, DateTime date, List<dynamic> events)
    {
        bool isEmptyEvents = _filteredByCategoryEvents.where((event) {
            return event.startsAt.year == date.year
              && event.startsAt.month == date.month
              && event.startsAt.day == date.day;
        }).toList().isEmpty;

        if(isEmptyEvents) {
            return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(shape: BoxShape.circle),
                margin: const EdgeInsets.all(6.0),
                alignment: Alignment.center,
                child: Text(
                    '${date.day}',
                    style: TextStyle(color: Theme.of(context).textTheme.overline.color.withOpacity(0.4)),
                ),
            );
        } else {
            return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green.withOpacity(0.4)),
                margin: const EdgeInsets.all(6.0),
                alignment: Alignment.center,
                child: Text(
                    '${date.day}',
                    style: TextStyle(color: Colors.white.withOpacity(0.4)),
                ),
            );
        }
    }
}