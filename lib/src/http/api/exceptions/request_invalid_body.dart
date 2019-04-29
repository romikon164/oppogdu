part of '../service.dart';

class ApiRequestInvalidBody implements Exception
{
    final String message;

    ApiRequestInvalidBody(this.message);

    String toString()
    {
        return message;
    }
}