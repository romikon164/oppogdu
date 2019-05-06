import 'package:flutter/material.dart';

mixin HasLoadingIndicator<T extends StatefulWidget> on State<T>
{
    static double kLoadingIndicatorHeight = 80.0;

    static double kLoadingIndicatorPadding = 16.0;

    bool _loadingIndicatorShowed = false;

    bool get loadingIndicatorShowed => _loadingIndicatorShowed;

    String get loadingIndicatorMessage;

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
}