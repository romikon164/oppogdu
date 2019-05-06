import 'package:flutter/material.dart';
import '../view_contract.dart';
import 'package:oppo_gdu/src/presenters/form_presenter.dart';
import '../../components/forms/form_helper.dart';
import 'package:oppo_gdu/src/data/models/news/comment.dart';

class SendCommentWidget extends StatefulWidget implements ViewContract
{
    final FormPresenterContract presenter;

    SendCommentWidget({Key key, this.presenter}): super(key: key);

    SendCommentWidgetState createState() => SendCommentWidgetState();
}

class SendCommentWidgetState extends State<SendCommentWidget>
                              with FormHelperMixin
                              implements FormPresenterDelegate
{
    String get loadingIndicatorMessage => "Пожалуйста, подождите";

    @override
    void initState()
    {
        super.initState();

        widget.presenter?.onFormInitState(this);
    }

    @override
    void didUpdateWidget(SendCommentWidget oldWidget)
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

    void onFormSendFailure(String error)
    {
        closeLoadingIndicator();

        showToast(error);
    }

    void onFormSendSuccess([dynamic data])
    {
        closeLoadingIndicator();

        if(data is Comment) {
            showToast('Ваш комментарий успешно отправлен');
            Navigator.of(context).pop(data);
        } else {
            showToast('Неизвестная ошибка');
        }
    }

    @override
    Widget build(BuildContext context)
    {
        return Form(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    buildTextField(
                        context,
                        label: 'Текст комментария',
                        name: 'message',
                        icon: Icons.subject,
                        inputType: TextInputType.multiline,
                        delegate: widget.presenter,
                    ),
                    buildSubmitButton(
                        context,
                        label: 'Отправить',
                        delegate: widget.presenter,
                    ),
                ],
            ),
        );
    }
}