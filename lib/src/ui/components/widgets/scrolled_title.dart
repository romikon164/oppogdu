import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    bool _appBarTitleVisibled = false;

    double _appBarTitleMarginTop = 0;

    double _flexibleSpaceHeight;

    @override
    void initState()
    {
        super.initState();

        _flexibleSpaceHeight = widget.flexibleSpaceHeight;
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

        slivers.add(_buildAppBar(context));

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
            _flexibleSpaceHeight = kToolbarHeight;

            return SliverAppBar(
                centerTitle: false,
                floating: false,
                pinned: true,
                title: _buildAppBarTitle(context),
                actions: widget.actions,
            );
        } else {
            return SliverAppBar(
                centerTitle: false,
                expandedHeight: _flexibleSpaceHeight,
                floating: false,
                pinned: true,
                title: _buildAppBarTitle(context),
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

    Widget _buildAppBarTitle(BuildContext context)
    {
        if(_appBarTitleVisibled) {
            return ClipRect(
                child: Padding(
                    padding: EdgeInsets.only(top: _appBarTitleMarginTop),
                    child: Text(widget.title, textScaleFactor: 0.6),
                ),
            );
        }

        return null;
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

        if(scrollTop > _flexibleSpaceHeight - kToolbarHeight + widget.bodyTitleMarginTop) {
            if(!_appBarTitleVisibled) {
                setState(() {
                    _appBarTitleVisibled = true;
                    _appBarTitleMarginTop = kToolbarHeight;
                });
            } else {
                setState(() {
                    _appBarTitleMarginTop = _flexibleSpaceHeight - scrollTop + widget.bodyTitleMarginTop;

                    if(_appBarTitleMarginTop < 0) {
                        _appBarTitleMarginTop = 0;
                    }
                });
            }
        } else {
            if (_appBarTitleVisibled) {
                setState(() {
                    _appBarTitleVisibled = false;
                });
            }
        }

        return false;
    }
}