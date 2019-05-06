import '../repository_contract.dart';
import '../../models/model_collection.dart';
import 'package:oppo_gdu/src/http/api/service.dart';
import '../exceptions/not_found.dart';
import '../../models/users/worker.dart';
import '../api_criteria.dart';


class WorkerApiRepository extends RepositoryContract<Worker, ApiCriteria>
{
    ApiService _apiService = ApiService.instance;

    Future<ModelCollection<Worker>> get([ApiCriteria criteria]) async
    {
        ApiResponse apiResponse = await _apiService.workers.getList();

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawWorkersWithMeta = apiResponse.json();
        List<dynamic> rawWorkers = rawWorkersWithMeta["data"] as List<dynamic>;

        return ModelCollection(Worker.fromList(rawWorkers));
    }

    Future<ModelCollection<Worker>> getLeaderships([ApiCriteria criteria]) async
    {
        return ModelCollection(List.generate(24, (int index) {
            return Worker(
                id: index,
                name: "Фамилия Имя Отчество",
                email: 'mail@mail.ru',
                phone: '+7 (999) 999-99-99',
                photo: 'http://api.oppo-gdu.ru/storage/uploads/albums/a6dc89733ddf2a47371254657ee64d6c.jpg',
                thumb: 'http://api.oppo-gdu.ru/storage/uploads/albums/a6dc89733ddf2a47371254657ee64d6c.jpg',
                position: 'Руководитель',
            );
        }));
        ApiResponse apiResponse = await _apiService.workers.getLeadershipsList();

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawWorkersWithMeta = apiResponse.json();
        List<dynamic> rawWorkers = rawWorkersWithMeta["data"] as List<dynamic>;

        return ModelCollection(Worker.fromList(rawWorkers));
    }

    Future<Worker> getFirst(ApiCriteria criteria) async
    {
        criteria.take(1);

        ModelCollection<Worker> workers = await get(criteria);

        if(workers.isEmpty) {
            throw RepositoryNotFoundException();
        } else {
            return workers.first;
        }
    }

    Future<Worker> getById(int id) async
    {
        return Worker(
            id: id,
            name: "Фамилия Имя Отчество",
            email: 'mail@mail.ru',
            phone: '+7 (999) 999-99-99',
            photo: 'http://api.oppo-gdu.ru/storage/uploads/albums/a6dc89733ddf2a47371254657ee64d6c.jpg',
            thumb: 'http://api.oppo-gdu.ru/storage/uploads/albums/a6dc89733ddf2a47371254657ee64d6c.jpg',
            position: 'Руководитель',
            description: """
В Новом Уренгое, во Дворце спорта «Звездный», на заключительном матче регулярного чемпионата России по волейболу между командами «Факел» (Новый Уренгой) и «Локомотив» (Новосибирск), прошла благотворительная акция в рамках программы «Будущее вместе – ДОБРО ДЕТЯМ», реализуемой ООО «Газпром добыча Уренгой».

Все болельщики, пришедшие поддержать свою любимую команду, с большим энтузиазмом отнеслись к возможности принять участие в сборе пожертвований для ямальских детей, которым требуется реабилитационно-восстановительное лечение или помощь в получении медицинских услуг. После каждого взноса, сделанного новоуренгойцами в адрес фонда, на специальный стенд крепились наклейки в виде сердечек. К окончанию волейбольной игры «сердечные стенды» были полностью заклеены символами добра.

![](http://oppo-gdu.ru/newsimg/5/IMG_0619.JPG)

 Юные участники программы «Будущее вместе – ДОБРО ДЕТЯМ» присутствовали на спортивном мероприятии и активно болели за ямальских волейболистов вместе со зрителями. Матч выдался насыщенным и интересным, на протяжении всех трех партий отрыв в счете команд был небольшим, но в финале каждого сета преимущество было в пользу «Факела». В итоге новоуренгойцы не оставили шанса соперникам из Новосибирска и обыграли их со счетом – 3:0.

![](http://oppo-gdu.ru/newsimg/5/IMG_0622.JPG)

![](http://oppo-gdu.ru/newsimg/5/IMG_0623.JPG)

*Справка:*

 *Соглашение между Обществом «Газпром добыча Уренгой» и благотворительным фондом поддержки детей Ямало-Ненецкого автономного округа «Ямине» по реализации программы «Будущее вместе – ДОБРО ДЕТЯМ» было подписано 30 ноября 2018 года. В рамках данного проекта оказывается адресная помощь детям с ограниченными возможностями здоровья, проживающим в городе Новый Уренгой и на территории ЯНАО.*

 *С момента начала реализации благотворительной программы, в Обществе «Газпром добыча Уренгой» было проведено несколько акций и марафонов по сбору средств на лечение юных ямальцев. Во всех филиалах предприятия организованы места для сбора пожертвований. Каждый сотрудник имеет возможность оформить через бухгалтерию компании перевод на счет фонда «Ямине». По состоянию на конец марта 2019 года от Общества передано в фонд более 3-х миллионов рублей.*
 """
        );
        ApiResponse apiResponse = await _apiService
          .workers
          .getDetail(id);

        if(apiResponse.isNotFound) {
            throw RepositoryNotFoundException();
        }

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawWorkersWithMeta = apiResponse.json();

        if(!rawWorkersWithMeta.containsKey("data")) {
            throw RepositoryNotFoundException();
        }

        Map<String, dynamic> rawWorkers = rawWorkersWithMeta["data"] as Map<String, dynamic>;

        return Worker.fromMap(rawWorkers);
    }

    Future<bool> add(Worker model) async
    {
        return false;
    }

    Future<bool> delete(Worker model) async
    {
        return false;
    }

    Future<bool> deleteAll() async
    {
        return false;
    }

    Future<bool> update(Worker model) async
    {
        return false;
    }
}