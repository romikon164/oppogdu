import 'criteria.dart';

class ApiCriteria extends CriteriaContract
{
    int _offset;

    int _limit;

    String _sortBy;

    CriteriaSortDirection _sortDirection;

    Map<String, dynamic> _filters = Map<String, dynamic>();

    CriteriaContract skip(int offset)
    {
        _offset = offset;

        return this;
    }

    CriteriaContract take(int limit)
    {
        _limit = limit;

        return this;
    }

    CriteriaContract sortBy(String field, CriteriaSortDirection direction)
    {
        _sortBy = field;
        _sortDirection = direction;

        return this;
    }

    CriteriaContract where(String field, CriteriaOperator operator, [dynamic value])
    {
        if(operator == CriteriaOperator.equal) {
            _filters[field] = value;
        }

        return this;
    }

    int getOffset() => _offset;

    int getLimit() => _limit;

    String getSortBy() => _sortBy;

    String getSortDirection() {
        if(_sortDirection == CriteriaSortDirection.asc) {
            return "asc";
        } else if(_sortDirection == CriteriaSortDirection.desc) {
            return "desc";
        } else {
            return null;
        }
    }

    String getSort() {
        if(_sortBy != null && _sortBy.isNotEmpty) {
            return "$_sortBy=${getSortDirection().toLowerCase()}";
        } else {
            return null;
        }
    }

    dynamic getFilterValueByName(String name, [dynamic defaultValue])
    {
        return _filters.containsKey(name) ? _filters[name] : defaultValue;
    }
}