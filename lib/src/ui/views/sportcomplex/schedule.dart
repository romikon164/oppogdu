import 'package:flutter/material.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';
import 'package:oppo_gdu/src/data/models/sportcomplex/schedule_filter.dart';
import 'package:oppo_gdu/src/data/models/sportcomplex/schedule.dart';
import 'package:oppo_gdu/src/data/repositories/sportcomplex/schedules/api_repository.dart';
import 'package:oppo_gdu/src/data/repositories/criteria.dart';
import 'package:oppo_gdu/src/data/repositories/api_criteria.dart';
import 'package:oppo_gdu/src/support/datetime/formatter.dart';

class SportComplexScheduleView extends StatefulWidget implements ViewContract
{
    final ScheduleFilter filter;

    SportComplexScheduleView({Key key, this.filter}): super(key: key);

    @override
    SportComplexScheduleState createState() => SportComplexScheduleState();
}

class SportComplexScheduleState extends State<SportComplexScheduleView>
{
    ScheduleApiRepository _apiRepository = ScheduleApiRepository();

    List<Schedule> schedules;

    bool _isLoad = false;
    bool _isError = false;

    @override void initState()
    {
        super.initState();

        loadSchedules();
    }

    @override
    Widget build(BuildContext context)
    {
        return schedules == null
            ? (_isError ? _buildErrorWidget(context) : _buildLoadingWidget(context))
            : _buildWidget(context);
    }

    Future<void> loadSchedules() async
    {
        print('loaded');
        if (_canLoad()) {
            print('can load');
            _initLoader();

            try {
                ApiCriteria apiCriteria = ApiCriteria();
                apiCriteria.where('date', CriteriaOperator.equal, widget.filter.date);

                if ( widget.filter.trainer != null) {
                    apiCriteria.where('trainer', CriteriaOperator.equal, widget.filter.trainer.id);
                }

                if ( widget.filter.hall != null) {
                    apiCriteria.where('hall', CriteriaOperator.equal, widget.filter.hall.id);
                }

                List<Schedule> schedules = await _apiRepository.get(apiCriteria);
                print(schedules);
                _onLoad(schedules);
            } catch(e) {
                _onError();
            }
        }
    }

    bool _canLoad()
    {
        return schedules == null && !_isLoad && !_isError;
    }

    void _initLoader()
    {
        _isError = false;
        _isLoad = true;
    }

    void _onLoad(List<Schedule> schedules)
    {
        setState(() {
            this.schedules = schedules;
            _isLoad = false;
            _isError = false;
        });
    }

    void _onError()
    {
        setState(() {
            _isLoad = false;
            _isError = true;
            schedules = null;
        });
    }

    Widget _buildWidget(BuildContext context)
    {
        if (schedules.isEmpty) {
            return Center(
                child: Text("Список пуст"),
            );
        }

        return ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(0),
            physics: BouncingScrollPhysics(),
            itemCount: schedules.length,
            itemBuilder: (BuildContext context, int index) {
                return _buildEventItem(context, schedules[index]);
            }
        );
    }

    Widget _buildHeader(BuildContext context)
    {
        return Card(
            child: Padding(
                padding: EdgeInsets.all(12),
                child: Wrap(
                    children: _buildFilterChips(context),
                ),
            ),
        );
    }

    List<Widget> _buildFilterChips(BuildContext context)
    {
        List<Widget> chips = [
            Chip(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                elevation: 4.0,
                padding: EdgeInsets.only(left: 8, right: 8),
                backgroundColor: Theme.of(context).primaryColor,
                label: Text(_filterDateText()),
            ),
        ];

        if (widget.filter.trainer != null) {
            chips.add(
                Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(widget.filter.trainer.name),
                    onDeleted: () {

                    },
                )
            );
        }

        if (widget.filter.hall != null) {
            chips.add(
                Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(widget.filter.hall.name),
                    onDeleted: () {

                    },
                )
            );
        }

        return chips;
    }

    String _filterDateText()
    {
        if (widget.filter.date == null) {
            return 'Не выбрано';
        }

        String month = DateTimeFormatter.monthText(widget.filter.date);
        String weekday = DateTimeFormatter.weekdayText(widget.filter.date);

        return "${weekday.toUpperCase()}, ${widget.filter.date.day} $month";
    }

    Widget _buildEventItem(BuildContext context, Schedule schedule)
    {
        Duration timeToEvent = DateTime.now().difference(schedule.startedAt);
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
                                    DateTimeFormatter.format(schedule.startedAt, pattern: "HH:mm"),
                                    style: Theme.of(context).textTheme.headline,
                                ),
                                Text(
                                    schedule.finishedAt != null && schedule.finishedAt.millisecondsSinceEpoch != 0
                                        ? DateTimeFormatter.format(schedule.finishedAt, pattern: "HH:mm")
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
                                        schedule.name,
                                        style: Theme.of(context).textTheme.headline,
                                    ),
                                    width: MediaQuery.of(context).size.width - 120,
                                ),
                                Container(height: 12),
                                SizedBox(
                                    child: Text(
                                        schedule.description ?? '',
                                        style: Theme.of(context).textTheme.overline,
                                    ),
                                    width: MediaQuery.of(context).size.width - 120,
                                ),
                                Container(height: 12),
                                SizedBox(
                                    child: Text(
                                        schedule.trainer != null ? "Тренер: ${schedule.trainer.name}" : '',
                                        style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                                    ),
                                    width: MediaQuery.of(context).size.width - 120,
                                ),
                                Container(height: 12),
                                SizedBox(
                                    child: Text(
                                        schedule.hall != null ? "Зал: ${schedule.hall.name}" : '',
                                        style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
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

    Widget _buildLoadingWidget(BuildContext context)
    {
        return Center(
            child: CircularProgressIndicator(),
        );
    }

    Widget _buildErrorWidget(BuildContext context)
    {
        return Center(
            child: Text('Возникла ошибка при загрузке данных'),
        );
    }
}