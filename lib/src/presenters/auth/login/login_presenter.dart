import 'package:flutter/material.dart';
import 'package:oppo_gdu/src/support/routing/router.dart';
import 'package:oppo_gdu/src/ui/views/auth/login/login_view.dart';
import 'package:validators/validators.dart' as Validator;
import 'package:oppo_gdu/src/http/api/service.dart';
import '../../presenter.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';
import '../../form_presenter.dart';
import 'package:oppo_gdu/src/support/auth/service.dart';

class LoginPresenter extends FormPresenter
{
    LoginView _view;

    FormPresenterDelegate _delegate;

    String _phone;

    String _password;

    LoginPresenter(RouterContract router): super(router)
    {
        _view = LoginView(presenter: this);
    }

    ViewContract get view => _view;

    @override
    void didClosePressed()
    {
        router.presentNewsList();
    }

    void onFormInitState(FormPresenterDelegate newDelegate)
    {
        _delegate = newDelegate;
    }

    String onFormValidateField(String field, String value)
    {
        print("validate $field with value $value");

        return value.isEmpty
            ? "Поле обязательно"
            : null;
    }

    void onFormSaveField(String field, String value)
    {
        if(field == "phone") {
            _phone = value;
        } else if(field == "password") {
            _password = value;
        }
    }
    
    Future<void> onFormSubmit() async
    {
        try {
            print("auth with phone $_phone and password $_password");

            await AuthService.instance.authenticate(_phone, _password);
            print("login success");
            _delegate.onFormSendSuccess();
        } on AuthInvalidCredentialsException {
            print("login error");
            _delegate.onFormSendFailure("Неверный телефон/пароль");
        } catch(e) {
            print("http error \"${e.toString()}\"");
            _delegate.onFormSendFailure("Возникла ошибка при отправке данных");
        }
    }
}