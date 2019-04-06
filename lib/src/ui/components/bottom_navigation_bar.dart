import "package:flutter/material.dart";

class AnimatedBottomNavigationBar extends StatefulWidget
{
    final AnimatedBottomNavigationBarController controller;

    AnimatedBottomNavigationBar({Key key, this.controller}): super(key: key);

    @override
    _AnimatedBottomNavigationBarState createState() => _AnimatedBottomNavigationBarState();
}

class _AnimatedBottomNavigationBarState extends State<AnimatedBottomNavigationBar>
    with TickerProviderStateMixin
{
    bool _bottomNavigationVisible = true;

    @override
    void initState()
    {
        super.initState();

        widget.controller?._state = this;
    }

    @override
    Widget build(BuildContext context)
    {
        return AnimatedSize(
            duration: Duration(milliseconds: 500),
            vsync: this,
            curve: Curves.fastOutSlowIn,
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: _bottomNavigationVisible ? 60 : 0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _buildChildren(context),
                ),
            ),
        );
    }

    List<Widget> _buildChildren(BuildContext context)
    {
        return [

        ];
    }

    void show()
    {
        setState(() {
            _bottomNavigationVisible = true;
        });
    }

    void hide()
    {
        setState(() {
            _bottomNavigationVisible = false;
        });
    }
}

abstract class AnimatedBottomNavigationBarDelegate
{
    void onNewsTap();
    void onSportComplexTap();
    void onCallbackTap();
}

class AnimatedBottomNavigationBarController
{
    _AnimatedBottomNavigationBarState _state;

    AnimatedBottomNavigationBarDelegate delegate;

    void show()
    {
        _state?.show();
    }

    void hide()
    {
        _state?.hide();
    }
}