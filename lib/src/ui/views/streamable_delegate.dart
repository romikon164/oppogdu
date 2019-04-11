import 'package:oppo_gdu/src/presenters/streamable_listenable_contract.dart';

abstract class ViewStreamableDelegate<T>
{
    void onInitState(StreamableListenableContract<T> listen);

    void didRefresh();

    void onEndOfData();

    void onDisposeState();
}