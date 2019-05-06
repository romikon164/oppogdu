import 'package:flutter/material.dart';
import 'scaffold.dart';
import '../navigation/bottom/delegate.dart';
import '../navigation/drawer/delegate.dart';

class LoadingWidget extends StatefulWidget
{
    final bool includeDrawer;

    final DrawerNavigationDelegate drawerDelegate;

    final BottomNavigationDelegate bottomNavigationDelegate;

    final int drawerCurrentIndex;

    final int bottomNavigationCurrentIndex;

    final String appBarTitle;

    LoadingWidget({
        Key key,
        this.includeDrawer = true,
        this.drawerDelegate,
        this.drawerCurrentIndex,
        this.bottomNavigationDelegate,
        this.bottomNavigationCurrentIndex,
        this.appBarTitle = 'Загрузка'
    }): super(key: key);

    @override
    _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
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
                child: CircularProgressIndicator(),
            ),
        );
    }
}