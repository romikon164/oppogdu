part of '../service.dart';

abstract class RetrieveApiParameters
{
    final int offset;

    final int limit;

    final String sortBy;

    final String sortDir;

    RetrieveApiParameters({this.offset, this.limit, this.sortBy, this.sortDir = "asc"});

    String toQueryString()
    {
        List<String> queryStringParts = List<String>();

        if(offset != null) queryStringParts.add("offset=$offset");
        if(limit != null) queryStringParts.add("limit=$limit");
        if(sortBy != null) {
            queryStringParts.add("sortby=$sortBy");
            queryStringParts.add("sortdir=$sortDir");
        }

        return queryStringParts.join("&");
    }

    String toString()
    {
        return toQueryString();
    }
}