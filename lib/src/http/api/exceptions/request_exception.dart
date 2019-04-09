part of '../api.dart';

class RequestException implements Exception
{
    final int code;

    final String message;

    final Request request;

    final Response response;

    RequestException(this.code, this.message, {this.request, this.response});

    int errCode() => code;
    String errMsg() => message;
}