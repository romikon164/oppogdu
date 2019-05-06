import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oppo_gdu/src/presenters/form_presenter.dart';

mixin FormHelperMixin<T extends StatefulWidget> on State<T>
{
    static const kTextMessageEdgeInsets = EdgeInsets.fromLTRB(40, 16, 40, 12);

    static const kFieldEdgeInsets = EdgeInsets.fromLTRB(16, 4, 16, 4);

    static const kButtonEdgeInsets = EdgeInsets.fromLTRB(16, 8, 16, 16);

    static const kFlatButtonHeight = 24.0;

    static double kLoadingIndicatorHeight = 80.0;

    static double kLoadingIndicatorPadding = 16.0;

    bool _loadingIndicatorShowed = false;

    bool get loadingIndicatorShowed => _loadingIndicatorShowed;

    String get loadingIndicatorMessage;

    void showToast(String message) async
    {
        await Fluttertoast.cancel();

        Fluttertoast.showToast(
            msg: message,
            fontSize: 12,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 3,
        );
    }

    showLoadingIndicator(BuildContext context)
    {
        if(!_loadingIndicatorShowed) {
            _loadingIndicatorShowed = true;

            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                    return Dialog(
                        child: Container(
                            height: kLoadingIndicatorHeight,
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Padding(
                                        padding: EdgeInsets.all(kLoadingIndicatorPadding),
                                        child: CircularProgressIndicator(),
                                    ),
                                    Text(loadingIndicatorMessage),
                                ],
                            ),
                        ),
                    );
                }
            );
        }
    }

    closeLoadingIndicator()
    {
        if(_loadingIndicatorShowed) {
            Navigator.of(context).pop();

            _loadingIndicatorShowed = false;
        }
    }

    Widget buildMessage(BuildContext context, String message)
    {
        return Padding(
            padding: kTextMessageEdgeInsets,
            child: new Text(
                message,
                style: Theme.of(context).textTheme.body2,
                textAlign: TextAlign.center,
            ),
        );
    }

    Widget buildTextField(BuildContext context, {
        @required String label,
        @required String name,
        IconData icon,
        String initialValue,
        TextInputType inputType = TextInputType.text,
        bool obscureText = false,
        FormPresenterContract delegate
    }) {
        return Padding(
            padding: kFieldEdgeInsets,
            child: TextFormField(
                initialValue: initialValue,
                obscureText: obscureText,
                decoration: InputDecoration(
                    prefixIcon: icon == null ? null : Icon(icon),
                    labelText: label,
                ),
                style: Theme.of(context).textTheme.button,
                validator: (String value) {
                    return delegate?.onFormValidateField(name, value);
                },
                onSaved: (String value) {
                    delegate?.onFormSaveField(name, value);
                },
            ),
        );
    }

    Widget buildObscureTextField(BuildContext context, {
        @required String label,
        @required String name,
        @required IconData icon,
        FormPresenterContract delegate
    }) {
        return buildTextField(
            context,
            label: label,
            name: name,
            icon: icon,
            delegate: delegate,
            obscureText: true
        );
    }

    Widget buildPhoneField(BuildContext context, {
        String label = 'Номер телефона',
        String prefix = '+7',
        String name = 'phone',
        FormPresenterContract delegate
    }) {
        return Padding(
            padding: kFieldEdgeInsets,
            child: TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    labelText: label,
                    prefixIcon: Icon(Icons.phone),
                    prefixText: prefix,
                ),
                style: Theme.of(context).textTheme.button,
                validator: (String phone) {
                    return delegate?.onFormValidateField(name, phone);
                },
                onSaved: (String phone) {
                    delegate?.onFormSaveField(name, "$prefix$phone");
                },
            ),
        );
    }

    Widget buildButton(BuildContext context, {String label, VoidCallback onTap})
    {
        return Padding(
            padding: kButtonEdgeInsets,
            child: RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: onTap,
                child: Text(label, style: TextStyle(color: Colors.white)),
            ),
        );
    }

    Widget buildFlatButton(BuildContext context, {String label, VoidCallback onTap})
    {
        return Padding(
            padding: kButtonEdgeInsets,
            child: Container(
                height: kFlatButtonHeight,
                child: FlatButton(
                    onPressed: onTap,
                    child: Text(
                        label,
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center
                     )
                ),
            ),
        );
    }

    Widget buildSubmitButton(BuildContext context, {String label, FormPresenterContract delegate})
    {
        return Padding(
            padding: kButtonEdgeInsets,
            child: Builder(
                builder: (BuildContext context) {
                    return RaisedButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());

                            FormState formState = Form.of(context);

                            if(formState.validate()) {
                                showLoadingIndicator(context);

                                formState.save();
                                delegate?.onFormSubmit();
                            }
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Text(label, style: TextStyle(color: Colors.white)),
                                Container(width: 8),
                                Icon(Icons.exit_to_app, color: Colors.white)
                            ],
                        ),
                    );
                }
            ),
        );
    }
}