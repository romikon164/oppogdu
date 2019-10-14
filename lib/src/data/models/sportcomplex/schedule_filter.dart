import 'package:oppo_gdu/src/data/models/sportcomplex/hall.dart';
import 'package:oppo_gdu/src/data/models/sportcomplex/trainer.dart';

class ScheduleFilter
{
    DateTime date;
    Trainer trainer;
    Hall hall;

    ScheduleFilter({this.date, this.trainer, this.hall});
}