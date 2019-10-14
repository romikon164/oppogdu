import 'package:flutter/material.dart';
import '../view_contract.dart';
import 'package:oppo_gdu/src/data/models/sportcomplex/schedule_filter.dart';
import 'package:oppo_gdu/src/data/models/sportcomplex/hall.dart';
import 'package:oppo_gdu/src/data/models/sportcomplex/trainer.dart';
import 'package:oppo_gdu/src/support/datetime/formatter.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class ScheduleFilterView extends StatefulWidget implements ViewContract
{
    final ScheduleFilter filter;
    final List<Trainer> trainers;
    final List<Hall> halls;

    ScheduleFilterView({Key key, this.filter, this.trainers, this.halls}): super(key: key);

    ScheduleFilterState createState() => ScheduleFilterState();
}

class ScheduleFilterState extends State<ScheduleFilterView>
{
    ScheduleFilter _filter;

    @override
    void initState()
    {
        super.initState();

        _filter = widget.filter;
    }
    @override
    Widget build(BuildContext context)
    {
        return ListView(
            padding: EdgeInsets.all(16),
            children: [
                _buildDateFilter(context),
                _buildTrainerFilter(context),
                _buildHallFilter(context),
                _buildSubmitButton(context),
            ],
        );
    }

    Widget _buildDateFilter(BuildContext context)
    {
        return RaisedButton(
            child: Container(
                alignment: Alignment.center,
                height: 50.0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                        Row(
                            children: <Widget>[
                                Container(
                                    child: Row(
                                        children: <Widget>[
                                            Icon(
                                                Icons.date_range,
                                                size: 24.0,
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(left: 8.0),
                                                child: Text(
                                                    _dateTextValue(),
                                                    style: TextStyle(
                                                        fontSize: 14.0),
                                                ),
                                            ),
                                        ],
                                        mainAxisAlignment: MainAxisAlignment.center,
                                    ),
                                )
                            ],
                        ),
                        Text(
                            "Изменить",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0),
                        ),
                    ],
                ),
            ),
            color: Colors.white,
            elevation: 0.0,
            onPressed: _selectDate,
        );
    }

    String _dateTextValue()
    {
        if (_filter.date == null) {
            return 'Не выбрано';
        }

        String month = DateTimeFormatter.monthText(_filter.date);
        String weekday = DateTimeFormatter.weekdayText(_filter.date);

        return "${weekday.toUpperCase()}, ${_filter.date.day} $month";
    }

    Widget _buildTrainerFilter(BuildContext context)
    {
        Trainer nullTrainer = Trainer(name: 'Тренер');
        List<Trainer> trainers = List<Trainer>.from(widget.trainers);
        trainers.insert(0, nullTrainer);

        return Padding(
            padding: EdgeInsets.all(16),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    DropdownButton<Trainer>(
                        items: trainers
                            .map((Trainer trainer) => _buildTrainerItem(context, trainer))
                            .toList(),
                        value: _filter.trainer == null ? nullTrainer : _filter.trainer,
                        onChanged: _selectTrainer,
                    ),
                    Container(
                        width: 24,
                        child: IconButton(
                            icon: Icon(Icons.cancel),
                            color: Colors.red,
                            onPressed: () {
                                setState(() {
                                    _filter.trainer = null;
                                });
                            },
                        ),
                    )
                ],
            ),
        );
    }

    DropdownMenuItem<Trainer> _buildTrainerItem(BuildContext context, Trainer trainer)
    {
        return DropdownMenuItem<Trainer>(
            value: trainer,
            child: Text(trainer.name, style: TextStyle(fontWeight: FontWeight.normal)),
        );
    }

    Widget _buildHallFilter(BuildContext context)
    {
        Hall nullHall = Hall(name: 'Зал');
        List<Hall> halls = List<Hall>.from(widget.halls);
        halls.insert(0, nullHall);

        return Padding(
            padding: EdgeInsets.all(16),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    DropdownButton<Hall>(
                        items: halls
                            .map((Hall hall) => _buildHallItem(context, hall))
                            .toList(),
                        value: _filter.hall == null ? nullHall : _filter.hall,
                        onChanged: _selectHall,
                    ),
                    Container(
                        width: 24,
                        child: IconButton(
                            icon: Icon(Icons.cancel),
                            color: Colors.red,
                            onPressed: () {
                                setState(() {
                                    _filter.hall = null;
                                });
                            },
                        ),
                    )
                ],
            ),
        );
    }

    DropdownMenuItem<Hall> _buildHallItem(BuildContext context, Hall hall)
    {
        return DropdownMenuItem<Hall>(
            value: hall,
            child: Text(hall.name, style: TextStyle(fontWeight: FontWeight.normal)),
        );
    }

    Widget _buildSubmitButton(BuildContext context)
    {
        return Padding(
            padding: EdgeInsets.all(16),
            child: Builder(
                builder: (BuildContext context) {
                    return RaisedButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: _applyFilter,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Icon(Icons.check, color: Colors.white),
                                Container(width: 8),
                                Text("Применить", style: TextStyle(color: Colors.white)),
                            ],
                        ),
                    );
                }
            ),
        );
    }

    void _applyFilter()
    {
        Navigator.of(context).pop(_filter);
    }

    void _selectDate() async
    {
        DatePicker.showDatePicker(
            context,
            locale: LocaleType.ru,
            currentTime: _filter.date,
            minTime: DateTime(1970),
            maxTime: DateTime(
                DateTime.now().year + 100
            ),
            onConfirm: (selectedDate) {
                if (selectedDate != null && selectedDate != _filter.date) {
                    setState(() {
                        _filter.date = selectedDate;
                    });
                }
            }
        );
    }

    void _selectTrainer(Trainer trainer)
    {
        if(trainer.id == null) {
            trainer = null;
        }

        if (trainer != _filter.trainer) {
            setState(() {
                _filter.trainer = trainer;
            });
        }
    }

    void _selectHall(Hall hall)
    {
        if(hall.id == null) {
            hall = null;
        }

        if (hall != _filter.hall) {
            setState(() {
                _filter.hall = hall;
            });
        }
    }
}