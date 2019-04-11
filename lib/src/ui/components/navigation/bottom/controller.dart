part of 'widget.dart';

class BottomNavigationController
{
    BottomNavigationWidgetState _state;

    BottomNavigationDelegate delegate;

    void show()
    {
        _state?.show();
    }

    void hide()
    {
        _state?.hide();
    }
}