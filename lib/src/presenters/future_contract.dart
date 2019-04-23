import 'presenter.dart';
import 'package:oppo_gdu/src/ui/views/future_delegate.dart';
import 'package:oppo_gdu/src/data/models/model.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';

abstract class FuturePresenterContract<T extends Model> extends Presenter implements ViewFutureDelegate<T>
{
    FuturePresenterContract(RouterContract router): super(router);
}