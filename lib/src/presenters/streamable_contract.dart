import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'presenter.dart';
import 'package:oppo_gdu/src/ui/views/streamable_delegate.dart';
import 'package:oppo_gdu/src/data/models/model.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';

abstract class StreamablePresenterContract<T extends Model> extends Presenter implements ViewStreamableDelegate<T>
{
    StreamablePresenterContract(RouterContract router): super(router);
}