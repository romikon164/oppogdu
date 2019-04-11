import 'criteria.dart';

class DatabaseCriteria extends CriteriaContract
{
    int _offset;

    int _limit;

    String _sortBy;

    CriteriaSortDirection _sortDirection;

    List<String> _wheres = List<String>();

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
            _wheres.add("$field = \"$value\"");
        } else if(operator == CriteriaOperator.larger) {
            _wheres.add("$field > \"$value\"");
        } else if(operator == CriteriaOperator.less) {
            _wheres.add("$field < \"$value\"");
        } else if(operator == CriteriaOperator.largerOrEqual) {
            _wheres.add("$field >= \"$value\"");
        } else if(operator == CriteriaOperator.lessOrEqual) {
            _wheres.add("$field <= \"$value\"");
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
            return "$_sortBy ${getSortDirection().toUpperCase()}";
        } else {
            return null;
        }
    }

    String getWhere() {
        return _wheres.join(" AND ");
    }
}