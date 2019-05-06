import 'package:flutter/material.dart';
import 'view_contract.dart';
import 'package:oppo_gdu/src/presenters/form_presenter.dart';
import '../components/navigation/drawer/widget.dart';
import '../components/navigation/bottom/widget.dart';
import '../components/forms/form_helper.dart';
import '../components/widgets/scaffold.dart';

class OrderView extends StatefulWidget implements ViewContract
{
    final FormPresenter presenter;

    final String defaultPhoneOrEmail;

    OrderView({Key key, @required this.presenter, this.defaultPhoneOrEmail}): super(key: key);

    @override
    _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView>
                      with FormHelperMixin
                      implements FormPresenterDelegate
{
    String get loadingIndicatorMessage => 'Пожалуйста, подождите';

    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    @override
    void initState()
    {
        super.initState();

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
        closeLoadingIndicator();

        showToast(error);
    }

    void onFormSendSuccess([dynamic data]) async
    {
        closeLoadingIndicator();

        showToast('Ваша заявка успешно отправлена');

        _formKey.currentState.reset();
    }

    @override
    Widget build(BuildContext context)
    {
        return ScaffoldWithBottomNavigation(
            drawerDelegate: widget.presenter,
            drawerCurrentIndex: DrawerNavigationWidget.callbackItem,
            bottomNavigationDelegate: widget.presenter,
            bottomNavigationCurrentIndex: BottomNavigationWidget.callbackItem,
            floatingBottomNavigationBar: false,
            backgroundColor: Colors.white,
            appBar: AppBar(
                title: Text("Напишите нам"),
            ),
            body: Form(
                key: _formKey,
                child: ListView(
                    children: [
                        buildMessage(context, 'Все поля обязательны для заполнения'),
                        buildTextField(
                            context,
                            label: 'Тема письма',
                            name: 'subject',
                            icon: Icons.subject,
                            delegate: widget.presenter
                        ),
                        buildTextField(
                            context,
                            label: 'Ваш e-mail / телефон',
                            name: 'phone_or_email',
                            icon: Icons.contacts,
                            initialValue: widget.defaultPhoneOrEmail,
                            delegate: widget.presenter
                        ),
                        buildTextField(
                            context,
                            label: 'Текст сообщения',
                            name: 'message',
                            inputType: TextInputType.multiline,
                            delegate: widget.presenter
                        ),
                        buildSubmitButton(
                            context,
                            label: 'Отправить',
                            delegate: widget.presenter
                        ),
                    ],
                ),
            ),
        );
    }
}