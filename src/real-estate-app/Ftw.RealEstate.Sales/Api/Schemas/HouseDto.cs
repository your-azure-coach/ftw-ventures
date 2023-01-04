namespace Ftw.RealEstate.Sales.Api.Schemas
{
    public record HouseDto(
        string City, 
        string Description, 
        double Price,
        string Type
    );
}
