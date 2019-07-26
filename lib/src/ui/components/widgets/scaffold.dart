import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/gestures.dart';
import '../navigation/drawer/widget.dart';
import '../navigation/drawer/delegate.dart';
import '../navigation/bottom/widget.dart';
import '../navigation/bottom/delegate.dart';

class ScaffoldWithBottomNavigation extends StatefulWidget
{
    final bool includeDrawer;

    final bool includeBottomNavigationBar;

    final DrawerNavigationDelegate drawerDelegate;

    final BottomNavigationDelegate bottomNavigationDelegate;

    final int drawerCurrentIndex;

    final int bottomNavigationCurrentIndex;

    final bool floatingBottomNavigationBar;

    final AppBar appBar;

    final Widget body;

    final Widget floatingActionButton;

    final FloatingActionButtonLocation floatingActionButtonLocation;

    final FloatingActionButtonAnimator floatingActionButtonAnimator;

    final List<Widget> persistentFooterButtons;

    final Widget bottomSheet;

    final Color backgroundColor;

    final bool resizeToAvoidBottomInset;

    final bool resizeToAvoidBottomPadding;

    final bool primary;

    final DragStartBehavior drawerDragStartBehavior;

    final bool extendBody;

    ScaffoldWithBottomNavigation({
        Key key,
        this.includeDrawer = true,
        this.includeBottomNavigationBar = true,
        this.drawerDelegate,
        this.drawerCurrentIndex,
        this.bottomNavigationDelegate,
        this.bottomNavigationCurrentIndex,
        this.floatingBottomNavigationBar = true,
        this.appBar,
        this.body,
        this.floatingActionButton,
        this.floatingActionButtonLocation,
        this.floatingActionButtonAnimator,
        this.persistentFooterButtons,
        this.bottomSheet,
        this.backgroundColor,
        this.resizeToAvoidBottomInset,
        this.resizeToAvoidBottomPadding,
        this.primary = true,
        this.drawerDragStartBehavior = DragStartBehavior.start,
        this.extendBody = false,
    }): super(key: key);

    @override
    _ScaffoldWithBottomNavigationState createState() => _ScaffoldWithBottomNavigationState();
}

class _ScaffoldWithBottomNavigationState extends State<ScaffoldWithBottomNavigation>
{
    GlobalKey<BottomNavigationWidgetState> _bottomNavigationKey = GlobalKey<BottomNavigationWidgetState>();
    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            appBar: widget.appBar,
            body: NotificationListener<UserScrollNotification>(
                child: widget.body,
                onNotification: _onUserScrollNotification,
            ),
            floatingActionButton: widget.floatingActionButton,
            floatingActionButtonLocation: widget.floatingActionButtonLocation,
            floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
            persistentFooterButtons: widget.persistentFooterButtons,
            drawer: _buildDrawer(context),
            bottomNavigationBar: _buildBottomNavigationBar(context),
            bottomSheet: widget.bottomSheet,
            backgroundColor: widget.backgroundColor,
            resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
            resizeToAvoidBottomPadding: widget.resizeToAvoidBottomPadding,
            primary: widget.primary,
            drawerDragStartBehavior: widget.drawerDragStartBehavior,
            extendBody: widget.extendBody,
        );
    }

    bool _onUserScrollNotification(UserScrollNotification notification)
    {
        bool upDirection = notification.metrics.axisDirection == AxisDirection.up;
        bool downDirection = notification.metrics.axisDirection == AxisDirection.down;

        if(upDirection || downDirection) {

            if(widget.floatingBottomNavigationBar && _bottomNavigationKey?.currentState != null) {
                if(notification.direction == ScrollDirection.forward) {
                    _bottomNavigationKey.currentState.show();
                } else if(notification.direction == ScrollDirection.reverse) {
                    _bottomNavigationKey.currentState.hide();
                }
            }

        }

        return true;
    }

    Widget _buildDrawer(BuildContext context)
    {
        if(widget.includeDrawer) {
            return DrawerNavigationWidget(
                delegate: widget.drawerDelegate,
                currentIndex: widget.drawerCurrentIndex,
            );
        }

        return null;
    }

    Widget _buildBottomNavigationBar(BuildContext context)
    {
        if(widget.includeBottomNavigationBar) {
            return BottomNavigationWidget(
                key: _bottomNavigationKey,
                delegate: widget.bottomNavigationDelegate,
                currentIndex: widget.bottomNavigationCurrentIndex
            );
        }

        return null;
    }
}