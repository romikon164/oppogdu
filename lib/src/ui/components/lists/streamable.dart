import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

typedef int SortListCompareCallback<T>(T a, T b);

typedef Widget StreamableListViewItemBuilder<T>(BuildContext context, T item);

enum StreamableListViewConnectionState
{
    Idle, Wait, Done, Error, Refresh
}

abstract class StreamableListViewDelegate<T>
{
    Future<Observable<T>> didRefresh();

    void didScrollToEnd();
}

class StreamableListView<T> extends StatefulWidget
{
    final Observable<T> observable;

    final SortListCompareCallback<T> sortCompare;

    final StreamableListViewDelegate delegate;

    final StreamableListViewItemBuilder<T> itemBuilder;

    StreamableListView({
        Key key,
        @required this.observable,
        this.sortCompare,
        this.delegate,
        this.itemBuilder
    }): super(key: key);

    @override
    StreamableListViewState<T> createState() => StreamableListViewState<T>();
}

class StreamableListViewState<T> extends State<StreamableListView<T>> {

    List<T> _items = List<T>();

    Observable<T> _stream;

    StreamSubscription<T> _subscription;

    StreamableListViewConnectionState _connectionState = StreamableListViewConnectionState.Idle;

    @override
    void initState() {
        super.initState();

        _stream = widget.observable;

        _subscribe();
    }

    @override
    void dispose()
    {
        _unsubscribe();
        super.dispose();
    }

    @override
    void didUpdateWidget(StreamableListView oldWidget) {
        super.didUpdateWidget(oldWidget);
    }

    @override
    void didChangeDependencies()
    {
        super.didChangeDependencies();
    }

    @override build(BuildContext context)
    {
        return NotificationListener<ScrollUpdateNotification>(
            child: RefreshIndicator(
                child: ListView.builder(
                    padding: EdgeInsets.all(0),
                    itemBuilder: _buildItems
                ),
                onRefresh: _onRefresh
            ),
            onNotification: _onScrollUpdate,
        );
    }

    void _subscribe()
    {
        _unsubscribe();

        _connectionState = StreamableListViewConnectionState.Wait;

        _subscription = _stream.listen(
            (T item) {
                if(item == null) {
                    setState(() {
                        _connectionState = StreamableListViewConnectionState.Done;
                    });
                    return ;
                }

                if(_connectionState != StreamableListViewConnectionState.Done) {
                    _connectionState = StreamableListViewConnectionState.Idle;
                }

                _insertNewItem(item);
            },
            onError: (error) {
                setState(() {
                    _connectionState = StreamableListViewConnectionState.Error;
                });
            },
            onDone: () {
                setState(() {
                    _connectionState = StreamableListViewConnectionState.Done;
                });
            }
        );
    }

    void _unsubscribe()
    {
        if(_subscription != null) {
            _subscription.cancel();
            _subscription = null;
        }
    }

    void _insertNewItem(T newItem)
    {
        if(_items.contains(newItem)) {
            setState(() {

            });
        } else {
            setState(() {
                _items.add(newItem);

                if (widget.sortCompare == null) {
                    _items.sort(widget.sortCompare);
                }

                _connectionState = StreamableListViewConnectionState.Idle;
            });
        }
    }

    Widget _buildItems(BuildContext context, int index)
    {
        if(index == _items.length) {
            return _buildFooter(context);
        } else if(index > _items.length) {
            return null;
        } else {
            return widget?.itemBuilder(context, _items[index]);
        }
    }

    Widget _buildFooter(BuildContext context)
    {
        if(_connectionState == StreamableListViewConnectionState.Wait) {
            return _buildLoadingIndicatorWidget(context);
        }

        if(_connectionState == StreamableListViewConnectionState.Error) {
            return _buildErrorWidget(context);
        }

        return null;
    }

    Widget _buildLoadingIndicatorWidget(BuildContext context)
    {
        return Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: Center(
                child: CircularProgressIndicator(),
            ),
        );
    }

    Widget _buildErrorWidget(BuildContext context)
    {
        return Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: Center(
                child: Text("Ошибка загрузки данных")
            ),
        );
    }

    Future<void> _onRefresh() async
    {
        _items.clear();
        _unsubscribe();

        _stream = await widget.delegate?.didRefresh();
        _subscribe();
    }

    bool _onScrollUpdate(ScrollUpdateNotification event)
    {
        if(event.metrics.pixels >= event.metrics.maxScrollExtent) {
            if(_connectionState == StreamableListViewConnectionState.Idle) {
                widget.delegate?.didScrollToEnd();

                setState(() {
                    _connectionState = StreamableListViewConnectionState.Wait;
                });
            }
        }

        return true;
    }
}