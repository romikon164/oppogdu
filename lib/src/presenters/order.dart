import 'package:oppo_gdu/src/ui/views/order.dart';
import 'package:oppo_gdu/src/http/api/service.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';
import 'form_presenter.dart';
import 'package:oppo_gdu/src/support/auth/service.dart';
import 'package:validators/validators.dart' as Validators;

class OrderPresenter extends FormPresenter
{
    OrderView _view;

    FormPresenterDelegate _delegate;

    String _subject;

    String _message;

    String _email;

    String _phone;

    OrderPresenter(RouterContract router): super(router)
    {
        _view = OrderView(
            presenter: this,
            defaultPhoneOrEmail: AuthService.instance.isAuthenticated()
                ? AuthService.instance.user.email
                : ""
        );
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
        if(value.isEmpty) {
            return "Поле обязательно";
        }

        return null;
    }

    void onFormSaveField(String field, String value)
    {
        if(field == "subject") {
            _subject = value;
        } else if(field == "message") {
            _message = value;
        } else if(field == "phone_or_email") {
            if(Validators.isEmail(value)) {
                _email = value;
                _phone = null;
            } else {
                _phone = value;
                _email = null;
            }
        }
    }

    Future<void> onFormSubmit() async
    {
        try {
            await ApiService.instance.orders.send(
                subject: _subject,
                message: _message,
                phone: _phone,
                email: _email
            );

            _delegate.onFormSendSuccess();
        } catch(e) {
            print(e);
            _delegate.onFormSendFailure("Возникла ошибка при отправке данных");
        }
    }
}