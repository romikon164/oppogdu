import 'presenter.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';

abstract class FormPresenterContract
{
    void onFormInitState(FormPresenterDelegate newDelegate);

    String onFormValidateField(String field, String value);

    void onFormSaveField(String field, String value);

    Future<void> onFormSubmit();
}

abstract class FormPresenter extends Presenter implements FormPresenterContract
{
    FormPresenter(RouterContract router): super(router);
}

abstract class FormPresenterDelegate
{
    void onFormSendFailure(String error);

    void onFormSendSuccess([dynamic data]);
}