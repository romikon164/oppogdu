part of '../service.dart';

class AuthInvalidCredentialsException implements Exception
{
    AuthInvalidCredentialsException();

    String toString() => "The user credentials were incorrect.";
}