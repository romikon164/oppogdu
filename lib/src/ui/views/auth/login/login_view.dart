import 'package:flutter/material.dart';
import 'package:oppo_gdu/src/presenters/auth/login/login_presenter.dart';
import '../../view_contract.dart';
import 'package:oppo_gdu/src/presenters/form_presenter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginView extends StatefulWidget implements ViewContract
{
    final FormPresenter presenter;

    LoginView({Key key, @required this.presenter}): super(key: key);

    @override
    _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> implements FormPresenterDelegate
{
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    bool _loading = false;

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
        print("login send failure");

        _closeLoadingIndicator();

        await Fluttertoast.cancel();

        Fluttertoast.showToast(
            msg: error,
            fontSize: 12,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 3,
        );
    }

    void onFormSendSuccess() async
    {
        print("login send success");

        _closeLoadingIndicator();

        await Fluttertoast.cancel();

        Fluttertoast.showToast(
            msg: "Вы успешно авторизовались",
            fontSize: 12,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 3,
        );
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
                    onTap: widget.presenter.didClosePressed,
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
                                validator: (String phone) {
                                    return widget.presenter.onFormValidateField("phone", phone);
                                },
                                onSaved: (String phone) {
                                    widget.presenter.onFormSaveField("phone", "7$phone");
                                },
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
                                validator: (String password) {
                                    return widget.presenter.onFormValidateField("password", password);
                                },
                                onSaved: (String password) {
                                    widget.presenter.onFormSaveField("password", password);
                                },
                            ),
                        ),
                        new Padding(
                            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
                            child: RaisedButton(
                                onPressed: () {
                                    FocusScope.of(context).requestFocus(FocusNode());

                                    if(_formKey.currentState.validate()) {

                                        _showLoadingIndicator(context);

                                        _formKey.currentState.save();

                                        widget.presenter?.onFormSubmit();
                                    }
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

    void _showLoadingIndicator(BuildContext context)
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
                                    Text("Выполняется вход"),
                                ],
                            ),
                        ),
                    );
                }
            );
        }
    }

    void _closeLoadingIndicator()
    {
        if(_loading) {
            widget.presenter?.router?.pop();

            _loading = false;
        }
    }
}