import 'package:flutter/material.dart';
import 'package:oppo_gdu/src/presenters/auth/login/login_presenter.dart';

class LoginView extends StatefulWidget
{
    final LoginPresenter presenter;

    LoginView({Key key, @required this.presenter}): super(key: key)
    {
        presenter.view = this;
    }

    @override
    _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> implements LoginPresenterDelegate
{
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    bool _loading = false;

    @override
    void initState()
    {
        super.initState();

        widget.presenter?.delegate = this;
    }

    @override
    void didUpdateWidget(LoginView oldWidget)
    {
        super.didUpdateWidget(oldWidget);

        widget.presenter?.delegate = this;
    }

    @override
    void dispose()
    {
        widget.presenter?.delegate = null;

        super.dispose();
    }

    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
                title: Text("Вход"),
                leading: GestureDetector(
                    child: Icon(
                        Icons.close,
                        size: Theme.of(context).appBarTheme.iconTheme.size,
                        color: Theme.of(context).appBarTheme.iconTheme.color
                    ),
                    onTap: widget.presenter.onAppBarClose,
                ),
            ),
            body: Form(
                key: _formKey,
                child: ListView(
                    children: [
                        new Padding(
                            padding: EdgeInsets.fromLTRB(40, 16, 40, 12),
                            child: new Text(
                                'Для входа под вашей учетной записью введите ваш номер телефона и пароль',
                                style: Theme.of(context).textTheme.body2,
                                textAlign: TextAlign.center,
                            ),
                        ),
                        new Padding(
                            padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                            child: TextFormField(
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    labelText: "Номер телефона",
                                    prefixIcon: Icon(Icons.phone),
                                    prefixText: "+7",
                                ),
                                validator: widget.presenter.didPhoneFieldValidate,
                                onSaved: widget.presenter.onPhoneFieldSaved,
                            ),
                        ),
                        new Padding(
                            padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                            child: TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.vpn_key),
                                    labelText: "Пароль",
                                ),
                                validator: widget.presenter.didPasswordFieldValidate,
                                onSaved: widget.presenter.onPasswordFieldSaved,
                            ),
                        ),
                        new Padding(
                            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
                            child: RaisedButton(
                                onPressed: () {
                                    FocusScope.of(context).requestFocus(FocusNode());

                                    widget.presenter.onLoginPressed(context, _formKey);
                                },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        Text("Войти", style: TextStyle(color: Colors.white)),
                                        Container(width: 8),
                                        Icon(Icons.exit_to_app, color: Colors.white)
                                    ],
                                ),
                            ),
                        ),
                        new Padding(
                            padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                            child: Container(
                                height: 24,
                                child: FlatButton(
                                    onPressed: () {},
                                    child: Text(
                                        "Забыли пароль?",
                                        style: TextStyle(
                                            fontSize: 12
                                        ),
                                        textAlign: TextAlign.center
                                    )
                                ),
                            ),
                        ),
                        new Padding(
                            padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                            child: RaisedButton(
                                onPressed: () {

                                },
                                child: Text("Создать аккаунт", style: TextStyle(color: Colors.white)),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }

    void showLoadingIndicator(BuildContext context)
    {
        if(!_loading) {
            _loading = true;

            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                    return Dialog(
                        child: Container(
                            height: 80,
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Padding(
                                        padding: EdgeInsets.all(16),
                                        child: CircularProgressIndicator(),
                                    ),
                                    Text("Пожалуйста, подождите"),
                                ],
                            ),
                        ),
                    );
                }
            );
        }
    }

    void closeLoadingIndicator(BuildContext context)
    {
        if(_loading) {
            _loading = false;

            Navigator.of(context).pop();
        }
    }

    void onLoginBefore(BuildContext context)
    {
        showLoadingIndicator(context);
    }

    void onLoginComplete(BuildContext context)
    {
        closeLoadingIndicator(context);

        widget.presenter?.onAppBarClose();
    }

    void onLoginFail(BuildContext context, String message)
    {
        closeLoadingIndicator(context);

        _scaffoldKey.currentState.showSnackBar(
            SnackBar(
                action: SnackBarAction(
                    label: "закрыть",
                    onPressed: () {},
                ),
                content: Text(message),
                duration: Duration(seconds: 5),
            )
        );
    }
}