import "package:flutter/material.dart";

class AnimatedBottomNavigationBar extends StatefulWidget
{
    final AnimatedBottomNavigationBarController controller;

    static const newsItem = 0;

    static const sportComplexItem = 1;

    static const callbackItem = 2;

    final int currentIndex;

    AnimatedBottomNavigationBar({Key key, this.controller, this.currentIndex}): super(key: key);

    @override
    _AnimatedBottomNavigationBarState createState() => _AnimatedBottomNavigationBarState(currentIndex: currentIndex);
}

class _AnimatedBottomNavigationBarState extends State<AnimatedBottomNavigationBar>
    with TickerProviderStateMixin
{
    bool _bottomNavigationVisible = true;

    int currentIndex;

    _AnimatedBottomNavigationBarState({this.currentIndex}): super();

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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _buildChildren(context),
                ),
            ),
        );
    }

    List<Widget> _buildChildren(BuildContext context)
    {
        return [
            _buildChild(
                context,
                title: "Новости",
                icon: Icons.assignment,
                onTap: widget.controller?.delegate?.onNewsTap,
                active: currentIndex == AnimatedBottomNavigationBar.newsItem
            ),
            _buildChild(
              context,
              title: "Спорт-комплекс",
              icon: Icons.domain,
              onTap: widget.controller?.delegate?.onNewsTap,
              active: currentIndex == AnimatedBottomNavigationBar.sportComplexItem
            ),
            _buildChild(
              context,
              title: "Напишите нам",
              icon: Icons.chat,
              onTap: widget.controller?.delegate?.onNewsTap,
              active: currentIndex == AnimatedBottomNavigationBar.callbackItem
            ),
        ];
    }

    Widget _buildChild(BuildContext context, {String title, IconData icon, onTap: GestureTapCallback, bool active = false})
    {
        return Expanded(
            child: InkWell(
                radius: 100,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                            Icon(
                                icon,
                                size: active
                                    ? Theme.of(context).accentIconTheme.size
                                    : Theme.of(context).iconTheme.size,
                                color: active
                                    ? Theme.of(context).accentIconTheme.color
                                    : Theme.of(context).iconTheme.color
                            ),
                            Text(
                                title,
                                overflow: TextOverflow.ellipsis,
                                style: active
                                    ? Theme.of(context).accentTextTheme.display1
                                    : Theme.of(context).textTheme.display1
                            )
                        ],
                    ),
                ),
                onTap: onTap,
            ),
        );
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

    void setCurrentItem(int index)
    {
        setState(() {
            currentIndex = index;
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