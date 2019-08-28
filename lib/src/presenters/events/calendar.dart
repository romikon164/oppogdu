import '../future_contract.dart';
import 'package:oppo_gdu/src/data/models/events/event.dart';
import 'package:oppo_gdu/src/support/routing/router_contract.dart';
import 'package:oppo_gdu/src/ui/views/events/calendar.dart';
import 'package:oppo_gdu/src/ui/views/view_contract.dart';
import 'package:oppo_gdu/src/ui/views/future_contract.dart';
import 'package:oppo_gdu/src/data/repositories/events/api_repository.dart';
import 'package:oppo_gdu/src/data/repositories/exceptions/not_found.dart';
import 'package:oppo_gdu/src/data/models/users/worker.dart';
import 'package:oppo_gdu/src/data/repositories/workers/api_repository.dart';
import 'package:oppo_gdu/src/ui/views/events/calendar.dart';

class EventsCalendarPresenter extends FuturePresenterContract<List<Event>>
{
    EventsCalendarView _view;

    ViewFutureContract<List<Event>> _delegate;

    EventApiRepository _apiRepository = EventApiRepository();

    WorkerApiRepository _workerApiRepository = WorkerApiRepository();

    EventsCalendarPresenter(RouterContract router): super(router) {
        _view = EventsCalendarView(presenter: this);
    }

    ViewContract get view => _view;

    void onInitState(ViewFutureContract<List<Event>> delegate)
    {
        if(_delegate != delegate) {
            _delegate = delegate;
            _loadDescription();
            _loadEvents();
            _loadTrainers();
        }
    }

    Future<void> didRefresh() async
    {
        await _loadEvents();
        await _loadTrainers();
        await _loadDescription();
    }

    void didTapTrainerItem(Worker trainer)
    {
        router.presentWorkerDetail(trainer.id);
    }

    void onDisposeState()
    {
        _delegate = null;
    }

    Future<void> _loadEvents() async
    {
        try {
            List<Event> _events = await _apiRepository.get();

            _delegate.onLoad(_events);
        } on RepositoryNotFoundException {
            router.presentNewsList();
        }
    }

    Future<void> _loadDescription() async
    {
        try {
            String _description = await _apiRepository.getDescription();

            (_delegate as TrainersViewerContract).onLoadDescription(_description);
        } on RepositoryNotFoundException {
            router.presentNewsList();
        }
    }

    Future<void> _loadTrainers() async
    {
        try {
            List<Worker> _trainers = await _workerApiRepository.getTrainers();

            (_delegate as TrainersViewerContract).onLoadTrainers(_trainers);
        } on RepositoryNotFoundException {
            router.presentNewsList();
        }
    }
}