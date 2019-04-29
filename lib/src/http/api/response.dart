part of 'service.dart';

class ApiResponse
{
    final int status;

    final String body;

    ApiResponse(this.status, this.body);

    bool get isUnauthorized => status == ApiResponseStatusCode.ACCESS_DENIED
        || status == ApiResponseStatusCode.UNAUTHORIZED;

    bool get isNotFound => status == ApiResponseStatusCode.NOT_FOUND;

    bool get isOk => status == ApiResponseStatusCode.OK || status == ApiResponseStatusCode.CREATED;

    bool get isUnProcessableEntity => status == ApiResponseStatusCode.UN_PROCESSABLE_ENTITY;

    dynamic toJson()
    {
        return convert.jsonDecode(body);
    }

    Map<String, dynamic> json() => toJson();

    ApiResponseErrors errors() => ApiResponseErrors(json());
}

class ApiResponseStatusCode
{
    static const int OK = 200;

    static const int CREATED = 201;

    static const int UNAUTHORIZED = 401;

    static const int ACCESS_DENIED = 403;

    static const int NOT_FOUND = 404;

    static const int UN_PROCESSABLE_ENTITY = 422;
}

class ApiResponseErrors
{
    Map<String, List<String>> _errors;

    String _message;

    ApiResponseErrors(Map<String, dynamic> response) {
        _message = response.containsKey("messsage")
            ? response["message"] as String
            : null;

        _errors = response.containsKey("errors")
            ? _parseErrors(response["errors"])
            : Map<String, List<String>>();
    }

    Map<String, List<String>> _parseErrors(dynamic rawErrors)
    {
        Map<String, List<String>> parsedErrors = Map<String, List<String>>();

        if(rawErrors is Map<String, dynamic>) {
            for(String field in rawErrors.keys) {
                dynamic fieldErrors = rawErrors[field];

                if(fieldErrors is List<String>) {
                    parsedErrors[field] = fieldErrors;
                }
            }
        }

        return parsedErrors;
    }

    String get message => _message;

    Map<String, List<String>> get errors => _errors;
}