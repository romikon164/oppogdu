import 'package:oppo_gdu/src/support/routing/router_contract.dart';
import 'package:oppo_gdu/src/data/repositories/repository_contract.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';

abstract class PresenterContract
{
    set router(RouterContract router);

    set view(ViewContract view);

    set repository(RepositoryContract repository);
}