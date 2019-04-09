part of '../service.dart';

class RequestUnprocessableEntityException implements Exception
{
    final String message;

    final Map<String, List<String>> errors;

    RequestUnprocessableEntityException(this.message, this.errors);
}