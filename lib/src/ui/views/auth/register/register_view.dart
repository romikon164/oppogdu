import 'package:flutter/material.dart';
import '../../view_contract.dart';
import 'package:oppo_gdu/src/presenters/form_presenter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterView extends StatefulWidget implements ViewContract
{
    final FormPresenter presenter;

    RegisterView({Key key, @required this.presenter}): super(key: key);

    @override
    _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> implements FormPresenterDelegate
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
        _closeLoadingIndicator();

        await Fluttertoast.cancel();

        Fluttertoast.showToast(
            msg: "Вы успешно зарегистрировались",
            fontSize: 12,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 3,
        );

        widget.presenter?.didClosePressed();
    }

    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            backgroundColor: Colors.white,
            key: _scaffoldKey,
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
                key: _formKey,
                child: ListView(
                    children: [
                        new Padding(
                            padding: EdgeInsets.fromLTRB(40, 16, 40, 12),
                            child: new Text(
                                'Поля отмеченные звездочкой (*) обязательны для заполнения',
                                style: Theme.of(context).textTheme.body2,
                                textAlign: TextAlign.center,
                            ),
                        ),
                        new Padding(
                            padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                            child: TextFormField(
                                initialValue: "9397126315",
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    labelText: "Номер телефона *",
                                    prefixIcon: Icon(Icons.phone),
                                    prefixText: "+7",
                                ),
                                style: Theme.of(context).textTheme.button,
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
                                initialValue: "09021970",
                                obscureText: true,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.vpn_key),
                                    labelText: "Пароль *",
                                ),
                                style: Theme.of(context).textTheme.button,
                                validator: (String password) {
                                    return widget.presenter.onFormValidateField("password", password);
                                },
                                onSaved: (String password) {
                                    widget.presenter.onFormSaveField("password", password);
                                },
                            ),
                        ),
                        new Padding(
                            padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                            child: TextFormField(
                                initialValue: "romikon164@gmail.com",
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    labelText: "Эл. почта *",
                                    prefixIcon: Icon(Icons.alternate_email),
                                ),
                                style: Theme.of(context).textTheme.button,
                                validator: (String email) {
                                    return widget.presenter.onFormValidateField("email", email);
                                },
                                onSaved: (String email) {
                                    widget.presenter.onFormSaveField("email", email);
                                },
                            ),
                        ),
                        new Padding(
                            padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                            child: TextFormField(
                                initialValue: "Роман Бызов",
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: "ФИО *",
                                    prefixIcon: Icon(Icons.person),
                                ),
                                style: Theme.of(context).textTheme.button,
                                validator: (String fullname) {
                                    return widget.presenter.onFormValidateField("fullname", fullname);
                                },
                                onSaved: (String fullname) {
                                    widget.presenter.onFormSaveField("fullname", fullname);
                                },
                            ),
                        ),
                        new Padding(
                            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
                            child: RaisedButton(
                                color: Theme.of(context).primaryColor,
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
                                        Text("Создать аккаунт", style: TextStyle(color: Colors.white)),
                                        Container(width: 8),
                                        Icon(Icons.exit_to_app, color: Colors.white)
                                    ],
                                ),
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
                                  Text("Пожалуйста, подождите"),
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