///

abstract class StreamableListenableContract<T>
{
    set stream(Stream<T> value);

    void onNetworkError();

    void onRefresh();
}