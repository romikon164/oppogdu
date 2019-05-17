import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AppBarFloatingTitle extends StatefulWidget
{
    final String title;

    final bool visibled;

    final double margin;

    AppBarFloatingTitle({
        Key key,
        this.title,
        this.visibled,
        this.margin,
    }): super(key: key);

    @override
    _AppBarFloatingTitleState createState() => _AppBarFloatingTitleState();
}

class _AppBarFloatingTitleState extends State<AppBarFloatingTitle>
{
    bool _visibled;

    double _margin;

    @override
    void initState()
    {
        super.initState();

        _visibled = widget.visibled;
        _margin = widget.margin;
    }

    @override
    Widget build(BuildContext context)
    {
        if(_visibled) {
            return ClipRect(
                child: Padding(
                    padding: EdgeInsets.only(top: _margin),
                    child: Text(widget.title, textScaleFactor: 0.6),
                ),
            );
        }

        return Container();
    }

    void setMargin(double newMargin)
    {
        if(mounted) {
            setState(() {
                _visibled = true;
                _margin = newMargin > 0 ? newMargin : 0;
            });
        }
    }

    void setVisibled([bool newVisibled = true])
    {
        if(mounted) {
            if(newVisibled != _visibled) {
                setState(() {
                    _visibled = newVisibled;
                });
            }
        }
    }
}

class CustomScrollViewWithScrolledTitle extends StatefulWidget
{
    final String title;

    final double flexibleSpaceHeight;

    final double bodyTitleMarginTop;

    final Widget subTitle;

    final List<Widget> actions;

    final List<Widget> children;

    final String image;

    final RefreshCallback onRefresh;

    CustomScrollViewWithScrolledTitle({
        Key key,
        @required this.title,
        this.flexibleSpaceHeight = 200,
        this.bodyTitleMarginTop = 16,
        this.subTitle,
        this.actions,
        this.children,
        this.onRefresh,
        this.image

    }): super(key: key);

    @override
    _CustomScrollViewWithScrolledTitleState createState() => _CustomScrollViewWithScrolledTitleState();
}

class _CustomScrollViewWithScrolledTitleState extends State<CustomScrollViewWithScrolledTitle>
{
    double _flexibleSpaceHeight;

    GlobalKey<_AppBarFloatingTitleState> _appBarTitleKey = GlobalKey<_AppBarFloatingTitleState>();

    @override
    void initState()
    {
        super.initState();
    }

    @override
    Widget build(BuildContext context)
    {
        List<Widget> topWidgets = List<Widget>();

        topWidgets.add(
            Text(
                widget.title,
                style: Theme.of(context).textTheme.headline,
            )
        );

        if(widget.subTitle != null) {
            topWidgets.add(
                Container(height: 8)
            );

            topWidgets.add(widget.subTitle);
        }

        List<Widget> slivers = List<Widget>();

        slivers.add(
            _buildAppBar(context)
        );

        slivers.add(
            SliverToBoxAdapter(
                child: Card(
                    child: Padding(
                        padding: EdgeInsets.all(widget.bodyTitleMarginTop),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: topWidgets,
                        ),
                    ),
                ),
             )
        );

        slivers.addAll(
            widget.children.map((child) {
                if(child is SliverWithKeepAliveWidget) {
                    return child;
                } else {
                    return SliverToBoxAdapter(child: Card(child: child));
                }
            })
        );

        return NotificationListener<ScrollNotification>(
            child: RefreshIndicator(
                child: CustomScrollView(
                    slivers: slivers,
                ),
                onRefresh: _onRefresh
            ),
            onNotification: _onScrollNotification,
        );
    }

    Widget _buildAppBar(BuildContext context)
    {
        if(widget.image == null) {
            return SliverAppBar(
                centerTitle: false,
                floating: false,
                pinned: true,
                title: AppBarFloatingTitle(
                    key: _appBarTitleKey,
                    title: widget.title,
                    margin: 0,
                    visibled: false,
                ),
                actions: widget.actions,
            );
        } else {
            return SliverAppBar(
                centerTitle: false,
                expandedHeight: widget.flexibleSpaceHeight,
                floating: false,
                pinned: true,
                title: AppBarFloatingTitle(
                    key: _appBarTitleKey,
                    title: widget.title,
                    margin: 0,
                    visibled: false,
                ),
                actions: widget.actions,
                flexibleSpace: FlexibleSpaceBar(
                    background: Image(
                        image: CachedNetworkImageProvider(widget.image),
                        fit: BoxFit.cover,
                    ),
                ),
            );
        }
    }

    Future<void> _onRefresh() async
    {
        if(widget.onRefresh != null) {
            await widget.onRefresh();
        }
    }

    bool _onScrollNotification(ScrollNotification notification)
    {
        double scrollTop = notification.metrics.pixels;

        _flexibleSpaceHeight = widget.image != null ? widget.flexibleSpaceHeight : 0;

        if(scrollTop > _flexibleSpaceHeight - kToolbarHeight + widget.bodyTitleMarginTop) {
            _appBarTitleKey.currentState?.setMargin(
                _flexibleSpaceHeight - scrollTop + widget.bodyTitleMarginTop
            );
        } else {
            _appBarTitleKey.currentState?.setVisibled(false);
        }

        return false;
    }
}