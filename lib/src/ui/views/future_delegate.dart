import 'future_contract.dart';

abstract class ViewFutureDelegate<T>
{
    void onInitState(ViewFutureContract<T> listen);

    void didRefresh();

    void onDisposeState();
}