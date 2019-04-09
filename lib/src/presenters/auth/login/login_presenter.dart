import 'package:flutter/material.dart';
import 'package:oppo_gdu/src/support/routing/router.dart';
import 'package:oppo_gdu/src/ui/views/auth/login/login_view.dart';
import 'package:validators/validators.dart' as Validator;
import 'package:oppo_gdu/src/http/api/service.dart';
import 'package:oppo_gdu/src/http/api/auth.dart';

class LoginPresenter
{
    final Router router;

    LoginView view;

    LoginPresenterDelegate delegate;

    Api _api = Api.getInstance();

    AuthRequestTokenData _authData = AuthRequestTokenData();

    LoginPresenter({@required this.router});

    void onAppBarClose()
    {
        router.pop();
    }

    void onLoginPressed(BuildContext context, GlobalKey<FormState> formState) async
    {
        if(formState.currentState.validate()) {

            formState.currentState.save();

            delegate?.onLoginBefore(context);

            AuthToken token = await _api.auth.requestToken(_authData);

            if(token != null) {
                if(await _api.auth.authByToken(token)) {
                    delegate?.onLoginComplete(context);

                    return ;
                }
            }

            delegate?.onLoginFail(context, "Неверный логин / пароль");
        }
    }

    String didPhoneFieldValidate(String phone)
    {
//        if(phone.isEmpty || !Validator.isNumeric(phone)) {
//            return "Номер телефона может состоять только из цифр";
//        }

        return null;
    }

    String didPasswordFieldValidate(String password)
    {
//        if(!Validator.isLength(password, 8)) {
//            return "Пароль должен быть больше 8 символов длиной";
//        }

        return null;
    }

    void onPhoneFieldSaved(String phone)
    {
        _authData.username = "7$phone";
    }

    void onPasswordFieldSaved(String password)
    {
        _authData.password = password;
    }
}

abstract class LoginPresenterDelegate
{
    void onLoginBefore(BuildContext context);

    void onLoginFail(BuildContext context, String message);

    void onLoginComplete(BuildContext context);
}