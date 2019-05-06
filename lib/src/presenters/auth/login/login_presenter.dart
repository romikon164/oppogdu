import 'package:oppo_gdu/src/ui/views/auth/login/login_view.dart';
import 'package:oppo_gdu/src/http/api/service.dart';
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
        router.presentHomeScreen();
    }

    void onFormInitState(FormPresenterDelegate newDelegate)
    {
        _delegate = newDelegate;
    }

    String onFormValidateField(String field, String value)
    {
        return value.isEmpty
            ? "Поле обязательно"
            : null;
    }

    void onFormSaveField(String field, String value)
    {
        if(field == "phone") {
            _phone = value.replaceAll('+', '');
        } else if(field == "password") {
            _password = value;
        }
    }
    
    Future<void> onFormSubmit() async
    {
        try {
            await AuthService.instance.authenticate(_phone, _password);
            _delegate.onFormSendSuccess();
        } on AuthInvalidCredentialsException {
            _delegate.onFormSendFailure("Неверный телефон/пароль");
        } catch(e) {
            _delegate.onFormSendFailure("Возникла ошибка при отправке данных");
        }
    }
}