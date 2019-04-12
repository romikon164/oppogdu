///

abstract class CriteriaContract
{
    CriteriaContract skip(int offset);

    CriteriaContract take(int limit);

    CriteriaContract sortBy(String field, CriteriaSortDirection direction);

    CriteriaContract sortByAsc(String field) {
        return sortBy(field, CriteriaSortDirection.asc);
    }

    CriteriaContract sortByDesc(String field) {
        return sortBy(field, CriteriaSortDirection.desc);
    }

    CriteriaContract where(String field, CriteriaOperator operator, [dynamic value]);
}

enum CriteriaSortDirection { asc, desc }

enum CriteriaOperator {
    equal,
    notEqual,
    larger,
    less,
    largerOrEqual,
    lessOrEqual,
    isNull,
    isNotNull,
    inSet,
    notInSet
}