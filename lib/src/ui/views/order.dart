import 'package:flutter/material.dart';
import 'view_contract.dart';
import 'package:oppo_gdu/src/presenters/form_presenter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../components/navigation/drawer/widget.dart';
import '../components/navigation/bottom/widget.dart';

class OrderView extends StatefulWidget implements ViewContract
{
    final FormPresenter presenter;

    final String defaultPhoneOrEmail;

    OrderView({Key key, @required this.presenter, this.defaultPhoneOrEmail}): super(key: key);

    @override
    _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> implements FormPresenterDelegate
{
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    bool _loading = false;

    BottomNavigationController _bottomNavigationBarController;

    @override
    void initState()
    {
        super.initState();

        _bottomNavigationBarController = BottomNavigationController();
        _bottomNavigationBarController.delegate = widget.presenter;

        widget.presenter?.onFormInitState(this);
    }

    @override
    void didUpdateWidget(OrderView oldWidget)
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
            msg: "Ваша заявка успешно отправлена",
            fontSize: 12,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 3,
        );

        _formKey.currentState.reset();
    }

    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            backgroundColor: Colors.white,
            key: _scaffoldKey,
            appBar: AppBar(
                title: Text("Напишите нам"),
            ),
            body: Form(
                key: _formKey,
                child: ListView(
                    children: [
                        new Padding(
                            padding: EdgeInsets.fromLTRB(40, 16, 40, 12),
                            child: new Text(
                                'Поля отмеченные звездночкой (*) обязательны для заполнения',
                                style: Theme.of(context).textTheme.body2,
                                textAlign: TextAlign.center,
                            ),
                        ),
                        new Padding(
                            padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                            child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: "Тема письма",
                                    prefixIcon: Icon(Icons.subject),
                                ),
                                style: Theme.of(context).textTheme.button,
                                validator: (String subject) {
                                    return widget.presenter.onFormValidateField("subject", subject);
                                },
                                onSaved: (String subject) {
                                    widget.presenter.onFormSaveField("subject", subject);
                                },
                            ),
                        ),
                        new Padding(
                            padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                            child: TextFormField(
                                initialValue: widget.defaultPhoneOrEmail,
                                decoration: InputDecoration(
                                    labelText: "Ваш e-mail / телефон",
                                    prefixIcon: Icon(Icons.contacts),
                                ),
                                style: Theme.of(context).textTheme.button,
                                validator: (String phoneOrEmail) {
                                    return widget.presenter.onFormValidateField("phone_or_email", phoneOrEmail);
                                },
                                onSaved: (String phoneOrEmail) {
                                    widget.presenter.onFormSaveField("phone_or_email", phoneOrEmail);
                                },
                            ),
                        ),
                        new Padding(
                            padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                            child: TextFormField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                    labelText: "Текст сообщения",
                                ),
                                style: Theme.of(context).textTheme.button,
                                validator: (String message) {
                                    return widget.presenter.onFormValidateField("message", message);
                                },
                                onSaved: (String message) {
                                    widget.presenter.onFormSaveField("message", message);
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
                                        Text("Отправить", style: TextStyle(color: Colors.white)),
                                        Container(width: 8),
                                        Icon(Icons.exit_to_app, color: Colors.white)
                                    ],
                                ),
                            ),
                        ),
                    ],
                ),
            ),
            bottomNavigationBar: BottomNavigationWidget(
                currentIndex: BottomNavigationWidget.callbackItem,
                controller: _bottomNavigationBarController,
            ),
            drawer: DrawerNavigationWidget(
                delegate: widget.presenter,
                currentIndex: DrawerNavigationWidget.callbackItem
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