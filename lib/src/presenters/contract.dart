import 'package:oppo_gdu/src/support/routing/router_contract.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';

abstract class PresenterContract
{
    RouterContract get router;

    set view(ViewContract view);

    ViewContract get view;
}