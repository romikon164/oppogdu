import '../service.dart';

class PhotoAlbumDatabaseProvider extends DatabaseProviderContract
{
    PhotoAlbumDatabaseProvider() : super();

    String get table => "photoalbums";

    @override
    Future<void> createTable() async
    {
        database.execute("""
            CREATE TABLE IF NOT EXISTS $table (
                id UNSIGNED INTEGER NOT NULL,
                name VARCHAR(255) NOT NULL,
                description TEXT,
                image VARCHAR(255),
                thumb VARCHAR(255),
                photos LONGTEXT,
                created_at integer
            )
        """);
    }
}