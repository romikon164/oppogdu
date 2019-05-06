import 'package:flutter/material.dart';
import '../../view_contract.dart';
import 'package:oppo_gdu/src/presenters/form_presenter.dart';
import '../../../components/forms/form_helper.dart';

class RegisterView extends StatefulWidget implements ViewContract
{
    final FormPresenter presenter;

    RegisterView({Key key, @required this.presenter}): super(key: key);

    @override
    _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
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
    void didUpdateWidget(RegisterView oldWidget)
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

        showToast("Вы успешно зарегистрировались");

        widget.presenter?.didClosePressed();
    }

    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                title: Text("Регистрация"),
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
                        buildMessage(context, 'Все поля обязательны для заполнения'),
                        buildPhoneField(context, delegate: widget.presenter),
                        buildObscureTextField(
                          context,
                          label: 'Пароль',
                          name: 'password',
                          icon: Icons.vpn_key,
                          delegate: widget.presenter
                        ),
                        buildTextField(
                            context,
                            label: "Эл. почта",
                            name: "email",
                            icon: Icons.alternate_email,
                            delegate: widget.presenter,
                            inputType: TextInputType.emailAddress
                        ),
                        buildTextField(
                            context,
                            label: "ФИО",
                            name: "fullname",
                            icon: Icons.person,
                            delegate: widget.presenter
                        ),
                        buildSubmitButton(
                            context,
                            label: 'Создать аккаунт',
                            delegate: widget.presenter
                        ),
                    ],
                ),
            ),
        );
    }
}