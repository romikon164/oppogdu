part of '../service.dart';

class RequestException implements Exception
{
    final int code;

    final String message;

    RequestException(this.code, this.message);

    String toString()
    {
        return message;
    }
}