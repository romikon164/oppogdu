import 'package:oppo_gdu/src/presenters/presenter.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';
import 'package:oppo_gdu/src/ui/views/sportcomplex/sportcomplex.dart';

class SportComplexPresenter extends Presenter
{
    ViewContract _view;

    SportComplexPresenter(RouterContract router): super(router) {
        _view = SportComplexView(presenter: this);
    }

    @override
    ViewContract get view => _view;
}