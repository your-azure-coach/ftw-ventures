namespace Ftw.RealEstate.Sales.Api.Schemas
{
    public record ApartmentDto(
        string City,
        string Description,
        double Price,
        bool HasBalcony
    );
}
