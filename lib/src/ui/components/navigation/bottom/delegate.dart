/// Методы обратного вызова для меню быстрого доступа

abstract class BottomNavigationDelegate
{
    /// нажатие на "новости"
    void didBottomNavigationNewsPressed();
    /// нажатие на "спортивный комплекс"
    void didBottomNavigationSportComplex();
    /// нажатие на "напишите нам"
    void didBottomNavigationWriteToUs();
}