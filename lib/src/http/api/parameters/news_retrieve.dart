part of '../service.dart';

class NewsRetrieveApiParameters extends RetrieveApiParameters
{
    final leftBound;

    final rightBound;

    NewsRetrieveApiParameters({
        int offset,
        int limit,
        String sortBy,
        String sortDir = "asc",
        this.leftBound,
        this.rightBound
    }) : super(
        offset: offset,
        limit: limit,
        sortBy: sortBy,
        sortDir: sortDir
    );

    @override
    String toQueryString()
    {
        String queryString = super.toQueryString();

        if(leftBound != null) {
            if(queryString.isEmpty) {
                queryString += "left_bound=$leftBound";
            } else {
                queryString += "&left_bound=$leftBound";
            }
        }

        if(rightBound != null) {
            if(queryString.isEmpty) {
                queryString += "right_bound=$rightBound";
            } else {
                queryString += "&right_bound=$rightBound";
            }
        }

        return queryString;
    }
}