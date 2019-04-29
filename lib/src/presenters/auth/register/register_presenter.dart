import 'package:oppo_gdu/src/ui/views/auth/register/register_view.dart';
import 'package:oppo_gdu/src/http/api/service.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';
import '../../form_presenter.dart';
import 'package:oppo_gdu/src/support/auth/service.dart';
import 'package:validators/validators.dart' as Validator;

class RegisterPresenter extends FormPresenter
{
    RegisterView _view;

    FormPresenterDelegate _delegate;

    String _phone;

    String _password;

    String _fullname;

    String _email;

    RegisterPresenter(RouterContract router): super(router)
    {
        _view = RegisterView(presenter: this);
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
        if(field == "phone") {
            if(value.isEmpty) {
                return "Поле обязательно";
            } else if(!Validator.isNumeric(value)) {
                return "Поле заполнено не корректно";
            }
        } else if(field == "email") {
            if(value.isEmpty) {
                return "Поле обязательно";
            } else if(!Validator.isEmail(value)) {
                return "Поле заполнено не корректно";
            }
        } else if(field == "fullname") {
            if(value.isEmpty) {
                return "Поле обязательно";
            }
        } else if(field == "password") {
            if(value.isEmpty) {
                return "Поле обязательно";
            } else if(value.length < 8) {
                return "Длина пароля не может быть меньше 8 символов";
            }
        }

        return null;
    }

    void onFormSaveField(String field, String value)
    {
        if(field == "phone") {
            _phone = value;
        } else if(field == "password") {
            _password = value;
        } else if(field == "fullname") {
            _fullname = value;
        } else if(field == "email") {
            _email = value;
        }
    }

    Future<void> onFormSubmit() async
    {
        try {
            AuthToken authToken = await ApiService.instance.createAccount(
                email: _email,
                phone: _phone,
                password: _password,
                fullname: _fullname
            );

            if(authToken != null) {
                ApiService.instance.authToken = authToken;

                await AuthService.instance.updateAuthToken(authToken);
                await AuthService.instance.attemptUpdateUserData();
            }

            _delegate.onFormSendSuccess();
        } on RequestUnprocessableEntityException catch(e) {
            if(e.errors.isNotEmpty) {
                _handleErrors(e.errors);
            } else {
                _delegate.onFormSendFailure(e.message);
            }
        } on RequestException catch(_) {
            _delegate.onFormSendFailure("Возникла ошибка при отправке данных");
        }
    }

    void _handleErrors(Map<String, List<String>> errors)
    {
        if(errors.containsKey("phone") && errors["phone"].isNotEmpty) {
            _delegate.onFormSendFailure(errors["phone"].first);
        } else if(errors.containsKey("email") && errors["email"].isNotEmpty) {
            _delegate.onFormSendFailure(errors["email"].first);
        } else if(errors.containsKey("password") && errors["password"].isNotEmpty) {
            _delegate.onFormSendFailure(errors["password"].first);
        } else if(errors.containsKey("full_name") && errors["full_name"].isNotEmpty) {
            _delegate.onFormSendFailure(errors["full_name"].first);
        } else {
            _delegate.onFormSendFailure("Возникла ошибка при отправке данных");
        }
    }
}