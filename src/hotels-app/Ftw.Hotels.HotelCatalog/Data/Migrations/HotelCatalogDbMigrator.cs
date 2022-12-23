using Microsoft.EntityFrameworkCore;
using Ftw.Hotels.HotelCatalog.Data.DbContexts;

namespace Ftw.Hotels.HotelCatalog.Data.Migrations
{
    public static class HotelCatalogDbMigrator
    {
        public static void MigrateDatabase(this WebApplication app)
        {
            using var scope = app.Services.CreateScope();
            var factory = scope.ServiceProvider.GetRequiredService<IDbContextFactory<HotelCatalogDbContext>>();
            using var context = factory.CreateDbContext();
            if (context.Database.IsSqlServer())
                context.Database.Migrate();
            else
                context.Database.EnsureCreated();
        }
    }
}
