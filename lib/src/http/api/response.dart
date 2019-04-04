

class Response
{
    final int code;

    final Map<String, dynamic> body;

    bool get success {
        return code == 200;
    }

    Response({this.code, this.body});
}

class ResponseError extends Response
{
    final String message;

    ResponseError(this.message): super(code: ResponseCode.error);
}

class ResponseCode
{
    static final error = 500;

    static final ok = 200;

    static final accessDenied = 403;

    static final notFound = 404;
}