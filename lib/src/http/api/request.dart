part of 'service.dart';

class ApiRequest
{
    ApiRequestMethod requestMethod;

    String method;

    ApiRequest(this.method, [this.requestMethod = ApiRequestMethod.GET]);

    Map<String, String> _headers = Map<String, String>();

    Map<String, dynamic> _data = Map<String, dynamic>();

    ApiRequest addHeader(String name, String value) {
        _headers[name] = value;

        return this;
    }

    ApiRequest addHeaders(Map<String, String> headers) {
        _headers.addAll(headers);

        return this;
    }

    ApiRequest add(String name, dynamic value) {
        if(value != null) {
            _data[name] = value;
        }

        return this;
    }

    ApiRequest addAll(Map<String, dynamic> values) {
        _data.addAll(values);

        return this;
    }

    bool hasMultiPart()
    {
        for(dynamic data in _data.values) {
            if(data is ApiMultiPartData) {
                return true;
            }
        }

        return false;
    }

    Future<ApiResponse> execute() async
    {
        return await ApiService.instance.request(this);
    }

    List<String> _dataToQueryStringList(dynamic data, [String suffix])
    {
        List<String> query = [];

        if(data is Map) {
            if(suffix == null)
            for(String key in data.keys) {
                query.addAll(_dataToQueryStringList(data[key], suffix + "[$key]"));
            }
        } else if(data is List) {
            for(dynamic value in data) {
                query.addAll(_dataToQueryStringList(value, suffix + "[]"));
            }
        } else if(data is String || data is int || data is double) {
            query.add("$suffix=$data");
        } else if(data is bool) {
            query.add("$suffix=" + (data ? 'true' : 'false'));
        } else {
            throw ApiRequestInvalidBody("$data is invalid type for inline query string");
        }

        return query;
    }

    String bodyToQueryString()
    {
        List<String> query = [];

        for(String key in _data.keys) {
            query.addAll(_dataToQueryStringList(_data[key], key));
        }

        return query.join("&");
    }
}

enum ApiRequestMethod { GET, POST, PUT, DELETE, PATCH }

class ApiMultiPartData
{
    final String name;

    final dynamic data;

    final String filename;

    final String contentType;

    ApiMultiPartData(this.name, this.data, this.filename, this.contentType);
}

class ApiRequestException implements Exception
{
    final ApiResponseErrors apiResponseErrors;

    ApiRequestException(this.apiResponseErrors);

    String toString()
    {
        return this.apiResponseErrors.message;
    }
}