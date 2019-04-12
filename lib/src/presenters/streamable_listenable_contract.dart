///

abstract class StreamableListenableContract<T>
{
    void onStreamError();

    void onStreamReceivedData(T data, [bool toEnd = true]);

    void onStreamEndOfData();
}