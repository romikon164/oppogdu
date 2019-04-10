import 'package:oppo_gdu/src/presenters/streamable_listenable_contract.dart';

abstract class ViewStreamableDelegate
{
    void onInitState(StreamableListenableContract listen);

    void didRefresh();

    void onEndOfData();
}