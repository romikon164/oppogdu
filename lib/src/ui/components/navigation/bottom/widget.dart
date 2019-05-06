import "package:flutter/material.dart";
import 'delegate.dart';

part 'controller.dart';

class BottomNavigationWidget extends StatefulWidget
{
    final BottomNavigationDelegate delegate;

    static const newsItem = 0;

    static const sportComplexItem = 1;

    static const callbackItem = 2;

    final int currentIndex;

    BottomNavigationWidget({Key key, this.delegate, this.currentIndex}): super(key: key);

    @override
    BottomNavigationWidgetState createState() => BottomNavigationWidgetState(currentIndex: currentIndex);

    BottomNavigationWidgetState of(BuildContext context)
    {
        return context.ancestorStateOfType(TypeMatcher<BottomNavigationWidgetState>());
    }
}

class BottomNavigationWidgetState extends State<BottomNavigationWidget>
    with TickerProviderStateMixin
{
    bool _bottomNavigationVisible = true;

    int currentIndex;

    BottomNavigationWidgetState({this.currentIndex}): super();

    @override
    Widget build(BuildContext context)
    {
        return AnimatedSize(
            alignment: Alignment.topCenter,
            duration: Duration(milliseconds: 500),
            vsync: this,
            curve: Curves.fastOutSlowIn,
            child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                        BoxShadow(
                            color: Color(0x807E7E7E),
                            offset: Offset(0.0, 0.0),
                            blurRadius: 2.0,
                            spreadRadius: 0.0
                        )
                    ]
                ),
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
                onTap: widget.delegate?.didBottomNavigationNewsPressed,
                active: currentIndex == BottomNavigationWidget.newsItem
            ),
            _buildChild(
                context,
                title: "Спорт-комплекс",
                icon: Icons.domain,
                onTap: widget.delegate?.didBottomNavigationSportComplex,
                active: currentIndex == BottomNavigationWidget.sportComplexItem
            ),
            _buildChild(
                context,
                title: "Напишите нам",
                icon: Icons.chat,
                onTap: widget.delegate?.didBottomNavigationWriteToUs,
                active: currentIndex == BottomNavigationWidget.callbackItem
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
                                    ? Theme.of(context).accentTextTheme.button
                                    : Theme.of(context).textTheme.button
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