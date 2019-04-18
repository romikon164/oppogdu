import 'presenter.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';

abstract class FormPresenter extends Presenter
{
    FormPresenter(RouterContract router): super(router);

    void onFormInitState(FormPresenterDelegate newDelegate);

    String onFormValidateField(String field, String value);

    void onFormSaveField(String field, String value);

    Future<void> onFormSubmit();
}

abstract class FormPresenterDelegate
{
    onFormSendFailure(String error);

    onFormSendSuccess();
}