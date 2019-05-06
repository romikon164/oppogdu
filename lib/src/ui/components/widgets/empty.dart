import 'package:flutter/material.dart';
import 'scaffold.dart';
import '../navigation/bottom/delegate.dart';
import '../navigation/drawer/delegate.dart';

class EmptyWidget extends StatefulWidget
{
    final bool includeDrawer;

    final DrawerNavigationDelegate drawerDelegate;

    final BottomNavigationDelegate bottomNavigationDelegate;

    final int drawerCurrentIndex;

    final int bottomNavigationCurrentIndex;

    final String appBarTitle;

    final String emptyMessage;

    EmptyWidget({
        Key key,
        this.includeDrawer = true,
        this.drawerDelegate,
        this.drawerCurrentIndex,
        this.bottomNavigationDelegate,
        this.bottomNavigationCurrentIndex,
        this.appBarTitle = 'Пусто',
        this.emptyMessage = 'Пусто',
    }): super(key: key);

    @override
    _EmptyWidgetState createState() => _EmptyWidgetState();
}

class _EmptyWidgetState extends State<EmptyWidget>
{
    @override
    Widget build(BuildContext context)
    {
        return ScaffoldWithBottomNavigation(
            includeDrawer: widget.includeDrawer,
            drawerDelegate: widget.drawerDelegate,
            drawerCurrentIndex: widget.drawerCurrentIndex,
            bottomNavigationDelegate: widget.bottomNavigationDelegate,
            bottomNavigationCurrentIndex: widget.bottomNavigationCurrentIndex,
            appBar: AppBar(
                title: Text(widget.appBarTitle),
            ),
            body: Center(
                child: Text(
                    widget.emptyMessage
                ),
            ),
        );
    }
}