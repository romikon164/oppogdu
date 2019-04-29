import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

part 'provider_contract.dart';

class DatabaseService
{
    static const String DATABASE_FILENAME = "oppo_gdu_database.sql";

    static DatabaseService _instance;

    DatabaseService._();

    static DatabaseService get instance {
        if(_instance == null) {
            _instance = DatabaseService._();
        }

        return _instance;
    }

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
                version: 1,
                onCreate: _createDatabaseWithProviders
            );

            _database = await databaseFactory.openDatabase(databasePath, options: databaseOptions);
        } catch (_) {
            // TODO
        }
    }

    FutureOr<void> _createDatabaseWithProviders(Database db, int version) async
    {
        for(DatabaseProviderContract provider in providers.values) {
            provider.database = db;
            await provider.createTable();
        }
    }

    void addDatabaseProvider(String name, DatabaseProviderContract provider)
    {
        if(_database != null && _database.isOpen) {
            throw Exception("Database is opened");
        }

        providers[name] = provider;
    }

    Future<DatabaseProviderContract> getDatabaseProvider(String name) async
    {
        if(providers.containsKey(name)) {
            DatabaseProviderContract provider = providers[name];

            if(_database != null) {
                provider.database = _database;
                return provider;
            }

            int attempts = 0;
            int maxAttempts = 200;

            while(_database == null) {
                await Future.delayed(Duration(milliseconds: 100));
                attempts++;

                if(attempts > maxAttempts) {
                    throw Exception("Database connection timeout");
                }
            }

            provider.database = _database;

            return provider;
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