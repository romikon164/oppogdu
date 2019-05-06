import 'package:flutter/material.dart';
import '../../view_contract.dart';
import 'package:oppo_gdu/src/presenters/form_presenter.dart';
import '../../../components/forms/form_helper.dart';

class LoginView extends StatefulWidget implements ViewContract
{
    final FormPresenter presenter;

    LoginView({Key key, @required this.presenter}): super(key: key);

    @override
    _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
                      with FormHelperMixin
                      implements FormPresenterDelegate
{
    String get loadingIndicatorMessage => "Выполняется вход";

    @override
    void initState()
    {
        super.initState();

        widget.presenter?.onFormInitState(this);
    }

    @override
    void didUpdateWidget(LoginView oldWidget)
    {
        super.didUpdateWidget(oldWidget);

        widget.presenter?.onFormInitState(this);
    }

    @override
    void didChangeDependencies()
    {
        super.didChangeDependencies();

        widget.presenter?.onFormInitState(this);
    }

    @override
    void dispose()
    {
        super.dispose();
    }

    void onFormSendFailure(String error) async
    {
        closeLoadingIndicator();
        showToast(error);
    }

    void onFormSendSuccess([dynamic data]) async
    {
        closeLoadingIndicator();

        showToast("Вы успешно авторизовались");

        widget.presenter?.didClosePressed();
    }

    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                title: Text("Вход"),
                leading: GestureDetector(
                    child: Icon(
                        Icons.close,
                        size: Theme.of(context).appBarTheme.iconTheme.size,
                        color: Theme.of(context).appBarTheme.iconTheme.color
                    ),
                    onTap: widget.presenter.didClosePressed,
                ),
            ),
            body: Form(
                child: ListView(
                    children: [
                        buildMessage(context, 'Для входа под вашей учетной записью введите ваш номер телефона и пароль'),
                        buildPhoneField(context, delegate: widget.presenter),
                        buildObscureTextField(
                            context,
                            label: 'Пароль',
                            name: 'password',
                            icon: Icons.vpn_key,
                            delegate: widget.presenter
                        ),
                        buildSubmitButton(
                            context,
                            label: 'Войти',
                            delegate: widget.presenter
                        ),
                        buildFlatButton(
                            context,
                            label: "Забыли пароль?",
                            onTap: () {
                                // TODO
                            }
                        ),
                        buildButton(
                            context,
                            label: "Создать аккаунт",
                            onTap: () {
                                widget.presenter?.router?.presentRegister();
                            }
                        ),
                    ],
                ),
            ),
        );
    }
}