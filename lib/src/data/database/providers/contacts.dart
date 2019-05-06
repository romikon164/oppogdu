import '../service.dart';

class ContactsDatabaseProvider extends DatabaseProviderContract
{
    ContactsDatabaseProvider() : super();

    String get table => "contacts";

    @override
    Future<void> createTable() async
    {
        database.execute("""
            CREATE TABLE IF NOT EXISTS $table (
                id UNSIGNED INTEGER NOT NULL,
                name VARCHAR(255) NOT NULL,
                logo VARCHAR(255),
                email VARCHAR(255),
                phone VARCHAR(255),
                city VARCHAR(255) NOT NULL,
                address VARCHAR(255) NOT NULL,
                latitude real NOT NULL,
                longitude real NOT NULL,
                social_networks LONGTEXT
            )
        """);
    }
}