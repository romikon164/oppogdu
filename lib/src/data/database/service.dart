import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

part 'provider_contract.dart';

class DatabaseService
{
    static const String DATABASE_FILENAME = "oppo_gdu_database.sql";

    DatabaseService._();

    static DatabaseService get instance => DatabaseService._();

    Database _database;

    Map<String, DatabaseProviderContract> providers = Map<String, DatabaseProviderContract>();

    Future<Database> get database async {
        if(_database == null) {
            await _initService();
        }

        return _database;
    }

    Future<void> _initService() async
    {
        try {
            Directory documentsDirectory = await getApplicationDocumentsDirectory();
            String databasePath = join(documentsDirectory.path, DatabaseService.DATABASE_FILENAME);

            OpenDatabaseOptions databaseOptions = OpenDatabaseOptions(
                onCreate: _createDatabaseWithProviders()
            );

            _database = await databaseFactory.openDatabase(databasePath, options: databaseOptions);
        } catch (e) {
            print(e.toString());
        }
    }

    FutureOr<void> _createDatabaseWithProviders() async
    {
        for(DatabaseProviderContract provider in providers.values) {
            await provider.createTable();
        }
    }

    void addDatabaseProvider(String name, DatabaseProviderContract provider)
    {
        if(_database != null || _database.isOpen) {
            throw Exception("Database is opened");
        }

        providers[name] = provider;
    }

    DatabaseProviderContract getDatabaseProvider(String name)
    {
        if(providers.containsKey(name)) {
            return providers[name];
        }

        throw ArgumentError.value(name, "name");
    }

    Future<void> _deInitService() async
    {
        await _database?.close();
        _database = null;
    }

    void dispose()
    {
        _deInitService();
    }
}