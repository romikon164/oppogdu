import 'package:oppo_gdu/src/presenters/contract.dart';

abstract class RouterContract
{
    void pop();
    void push(PresenterContract presenter);
    void presentHomeScreen();
    void presentLogin();
    void presentRegister();
    void presentNewsList();
    void presentNewsDetail(int newsId);
}