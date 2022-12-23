using Ftw.Hotels.HotelCatalog.Data.Models;
using Microsoft.EntityFrameworkCore;
using System;

namespace Ftw.Hotels.HotelCatalog.Data.DbContexts
{
    public class HotelCatalogDbContext : DbContext
    {
        public HotelCatalogDbContext(DbContextOptions<HotelCatalogDbContext> options)
            : base(options)
        {
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Country>().HasData(
                new Country { Id = Guid.Parse("4e206904-5ce5-45c2-97c0-5c9aff34bf74"), Code = "BE", Name = "Belgium" },
                new Country { Id = Guid.Parse("f42bec68-0475-4843-a16b-d4307acb80a3"), Code = "JP", Name = "Japan" },
                new Country { Id = Guid.Parse("337b4bfa-8906-4035-a0ef-260ec8034469"), Code = "US", Name = "United States of America" }
            );

            modelBuilder.Entity<Hotel>().HasData(
                new Hotel { Id = Guid.Parse("2eb0d367-1fe6-4968-9d99-13cdf192b984"), CountryId = Guid.Parse("4e206904-5ce5-45c2-97c0-5c9aff34bf74"), Name = "Crown Resort & Spa", Description = "", Stars = 4, City = "Brussels", Longitude = 4.351721, Latitude = 50.850346 },
                new Hotel { Id = Guid.Parse("1b43177a-c518-4b2a-909a-ee4fc84c6820"), CountryId = Guid.Parse("4e206904-5ce5-45c2-97c0-5c9aff34bf74"), Name = "Queen's Cosmos Motel", Description = "", Stars = 4, City = "Hasselt", Longitude = 5.332480, Latitude = 50.930691 },
                new Hotel { Id = Guid.Parse("e7432cfd-41df-4b37-b641-c8dbf94328e1"), CountryId = Guid.Parse("4e206904-5ce5-45c2-97c0-5c9aff34bf74"), Name = "Historic Dune Resort", Description = "", Stars = 5, City = "Kortrijk", Longitude = 3.264930, Latitude = 50.827969 },
                new Hotel { Id = Guid.Parse("23de6950-b9b6-426b-a892-503dc1942335"), CountryId = Guid.Parse("4e206904-5ce5-45c2-97c0-5c9aff34bf74"), Name = "Prism Hotel", Description = "", Stars = 3, City = "Bruges", Longitude = 3.224699, Latitude = 51.209347 },
                
                new Hotel { Id = Guid.Parse("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), CountryId = Guid.Parse("f42bec68-0475-4843-a16b-d4307acb80a3"), Name = "Paragon Motel", Description = "", Stars = 4, City = "Osaka", Longitude = 135.502167, Latitude = 34.693737 },
                new Hotel { Id = Guid.Parse("a98f77b5-4572-485f-b355-7f565238eca9"), CountryId = Guid.Parse("f42bec68-0475-4843-a16b-d4307acb80a3"), Name = "Ruby Shores Hotel", Description = "", Stars = 4, City = "Kyoto", Longitude = 135.7556075, Latitude = 35.021041 },
                new Hotel { Id = Guid.Parse("c26bc1bd-9264-4d53-9c04-9e9a7aca7d0f"), CountryId = Guid.Parse("f42bec68-0475-4843-a16b-d4307acb80a3"), Name = "Sunset Legacy Hotel", Description = "", Stars = 5, City = "Sakai", Longitude = 135.50156, Latitude = 34.529124 },
                
                new Hotel { Id = Guid.Parse("1ba6d3a7-beae-4745-b818-e62e150fbb0b"), CountryId = Guid.Parse("337b4bfa-8906-4035-a0ef-260ec8034469"), Name = "Farmhouse Resort", Description = "", Stars = 5, City = "New York", Longitude = -74.0060152, Latitude = 40.7127281 },
                new Hotel { Id = Guid.Parse("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), CountryId = Guid.Parse("337b4bfa-8906-4035-a0ef-260ec8034469"), Name = "Eastern Willow Hotel", Description = "", Stars = 4, City = "Washington", Longitude = -77.0365427, Latitude = 38.8950368 },
                new Hotel { Id = Guid.Parse("88e473f7-8048-465b-ad3b-9f711c6fba82"), CountryId = Guid.Parse("337b4bfa-8906-4035-a0ef-260ec8034469"), Name = "Paradise Resort", Description = "", Stars = 3, City = "Los Angeles", Longitude = -118.242766, Latitude = 34.0536909 },
                new Hotel { Id = Guid.Parse("b05df49e-1f60-4128-888f-4f5836cc043b"), CountryId = Guid.Parse("337b4bfa-8906-4035-a0ef-260ec8034469"), Name = "Antique Bay Spa", Description = "", Stars = 3, City = "Chicago", Longitude = -87.6244212, Latitude = 41.8755616 },
                new Hotel { Id = Guid.Parse("fbf4e4dc-c068-472c-8feb-d809384c3af8"), CountryId = Guid.Parse("337b4bfa-8906-4035-a0ef-260ec8034469"), Name = "Antique Cavern Hotel", Description = "", Stars = 4, City = "Dallas", Longitude = -96.7968559, Latitude = 32.7762719 }
            ) ;

            modelBuilder.Entity<Room>().HasData(
                new Room { Id = Guid.Parse("268ca2d2-2fd5-43a1-bf68-293f6ce33f31"), HotelId = Guid.Parse("2eb0d367-1fe6-4968-9d99-13cdf192b984"), Number = "101", Floor = 1, Capacity = 1 },
                new Room { Id = Guid.Parse("93000f05-3afa-4c37-b0e7-2700efcd0612"), HotelId = Guid.Parse("2eb0d367-1fe6-4968-9d99-13cdf192b984"), Number = "102", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("d1f4ddd1-bf73-4722-a5ec-ebe11d12d727"), HotelId = Guid.Parse("2eb0d367-1fe6-4968-9d99-13cdf192b984"), Number = "103", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("ddbd2d96-4478-41d8-9d78-af6f3e688124"), HotelId = Guid.Parse("2eb0d367-1fe6-4968-9d99-13cdf192b984"), Number = "201", Floor = 2, Capacity = 1 },
                new Room { Id = Guid.Parse("cd9f8074-fbe2-4902-b18d-abac2c15f864"), HotelId = Guid.Parse("2eb0d367-1fe6-4968-9d99-13cdf192b984"), Number = "202", Floor = 2, Capacity = 4 },
                new Room { Id = Guid.Parse("e233b2be-4d01-4783-a05d-176688c00d9c"), HotelId = Guid.Parse("2eb0d367-1fe6-4968-9d99-13cdf192b984"), Number = "203", Floor = 2, Capacity = 4 },
                new Room { Id = Guid.Parse("f8cc5d2c-be43-4870-badf-6c956fbdc4a0"), HotelId = Guid.Parse("2eb0d367-1fe6-4968-9d99-13cdf192b984"), Number = "301", Floor = 3, Capacity = 2 },
                new Room { Id = Guid.Parse("7d4ed052-bda2-4dfd-8b3e-13246bbafce0"), HotelId = Guid.Parse("2eb0d367-1fe6-4968-9d99-13cdf192b984"), Number = "302", Floor = 3, Capacity = 1 },

                new Room { Id = Guid.Parse("6303cba9-a76e-4d2b-82b7-057fcccb36c1"), HotelId = Guid.Parse("1b43177a-c518-4b2a-909a-ee4fc84c6820"), Number = "101", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("1cef858b-5c87-4fdb-b997-752aa5dce2a2"), HotelId = Guid.Parse("1b43177a-c518-4b2a-909a-ee4fc84c6820"), Number = "102", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("b67a9def-f00c-4fd5-a934-b659c5f8ee03"), HotelId = Guid.Parse("1b43177a-c518-4b2a-909a-ee4fc84c6820"), Number = "103", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("06d8c1fe-7006-4383-aeb9-51b5a67880a7"), HotelId = Guid.Parse("1b43177a-c518-4b2a-909a-ee4fc84c6820"), Number = "104", Floor = 1, Capacity = 5 },
                new Room { Id = Guid.Parse("f67b4346-02d3-4c74-b679-99b99c13994a"), HotelId = Guid.Parse("1b43177a-c518-4b2a-909a-ee4fc84c6820"), Number = "105", Floor = 1, Capacity = 4 },
                new Room { Id = Guid.Parse("7230b419-7743-4546-9f48-aa97486d60b7"), HotelId = Guid.Parse("1b43177a-c518-4b2a-909a-ee4fc84c6820"), Number = "106", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("6c7abc41-2099-4e6d-af1c-3fe563075404"), HotelId = Guid.Parse("1b43177a-c518-4b2a-909a-ee4fc84c6820"), Number = "107", Floor = 1, Capacity = 1 },
                new Room { Id = Guid.Parse("9a087c46-edfc-4d14-b628-c16baa4b2f08"), HotelId = Guid.Parse("1b43177a-c518-4b2a-909a-ee4fc84c6820"), Number = "108", Floor = 1, Capacity = 1 },

                new Room { Id = Guid.Parse("e1046fdb-4f8d-4a50-9094-23e1dd369427"), HotelId = Guid.Parse("e7432cfd-41df-4b37-b641-c8dbf94328e1"), Number = "101", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("964ca8a8-7245-46af-ace8-e84d9079805f"), HotelId = Guid.Parse("e7432cfd-41df-4b37-b641-c8dbf94328e1"), Number = "102", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("ba39e5c2-b1fb-4e64-ad50-44a29f831416"), HotelId = Guid.Parse("e7432cfd-41df-4b37-b641-c8dbf94328e1"), Number = "103", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("0236ca82-afe0-4b35-9fcf-8fb3187a18bb"), HotelId = Guid.Parse("e7432cfd-41df-4b37-b641-c8dbf94328e1"), Number = "104", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("829fa15f-e883-428b-8082-908c98380ac4"), HotelId = Guid.Parse("e7432cfd-41df-4b37-b641-c8dbf94328e1"), Number = "105", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("1d582461-c165-457a-a834-57eb36fa6c92"), HotelId = Guid.Parse("e7432cfd-41df-4b37-b641-c8dbf94328e1"), Number = "106", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("f401ed99-0bf5-4135-90b9-8b67f201965d"), HotelId = Guid.Parse("e7432cfd-41df-4b37-b641-c8dbf94328e1"), Number = "107", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("82c9b20f-5304-4d53-8818-39af4ca5381d"), HotelId = Guid.Parse("e7432cfd-41df-4b37-b641-c8dbf94328e1"), Number = "201", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("cf7e4e6f-d46c-46ef-ab6c-e0d67d5e1eae"), HotelId = Guid.Parse("e7432cfd-41df-4b37-b641-c8dbf94328e1"), Number = "202", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("c51d6453-2de8-4a38-acf5-b243884990c6"), HotelId = Guid.Parse("e7432cfd-41df-4b37-b641-c8dbf94328e1"), Number = "203", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("51c84918-3a1c-48b7-9279-daf3efd0c336"), HotelId = Guid.Parse("e7432cfd-41df-4b37-b641-c8dbf94328e1"), Number = "204", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("c20cac9f-b008-4dc2-9616-14d05833f3cf"), HotelId = Guid.Parse("e7432cfd-41df-4b37-b641-c8dbf94328e1"), Number = "205", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("9e79c29e-6669-40b0-90e3-581de2e846aa"), HotelId = Guid.Parse("e7432cfd-41df-4b37-b641-c8dbf94328e1"), Number = "206", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("e0a0fc8e-6ddf-42a8-b021-a6978664f794"), HotelId = Guid.Parse("e7432cfd-41df-4b37-b641-c8dbf94328e1"), Number = "207", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("836f2785-cece-4489-8e31-a63a23a0f2bf"), HotelId = Guid.Parse("e7432cfd-41df-4b37-b641-c8dbf94328e1"), Number = "208", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("0f0c36dd-90a6-498f-b3d2-5862336eddca"), HotelId = Guid.Parse("e7432cfd-41df-4b37-b641-c8dbf94328e1"), Number = "209", Floor = 2, Capacity = 2 },

                new Room { Id = Guid.Parse("6479c299-b7f8-4023-98df-edb8c530fc34"), HotelId = Guid.Parse("23de6950-b9b6-426b-a892-503dc1942335"), Number = "101", Floor = 1, Capacity = 1 },
                new Room { Id = Guid.Parse("89bac4c7-6879-4df3-a332-42887a2aa076"), HotelId = Guid.Parse("23de6950-b9b6-426b-a892-503dc1942335"), Number = "102", Floor = 1, Capacity = 1 },
                new Room { Id = Guid.Parse("b9ebfecf-4299-4530-9853-4cef81a8fc2d"), HotelId = Guid.Parse("23de6950-b9b6-426b-a892-503dc1942335"), Number = "103", Floor = 1, Capacity = 1 },
                new Room { Id = Guid.Parse("5c9b18b7-6f44-4c8d-9d2e-c491b6b38460"), HotelId = Guid.Parse("23de6950-b9b6-426b-a892-503dc1942335"), Number = "201", Floor = 2, Capacity = 1 },
                new Room { Id = Guid.Parse("4ae69a56-a4ff-4416-8fd6-7c44c993af2b"), HotelId = Guid.Parse("23de6950-b9b6-426b-a892-503dc1942335"), Number = "202", Floor = 2, Capacity = 1 },
                new Room { Id = Guid.Parse("759d2158-b840-4c4a-8ea2-3a404b38812e"), HotelId = Guid.Parse("23de6950-b9b6-426b-a892-503dc1942335"), Number = "203", Floor = 2, Capacity = 1 },
                new Room { Id = Guid.Parse("0203c85b-2362-42a9-9feb-554edee237b8"), HotelId = Guid.Parse("23de6950-b9b6-426b-a892-503dc1942335"), Number = "301", Floor = 3, Capacity = 1 },
                new Room { Id = Guid.Parse("04dab6ae-b643-4b75-a12a-ee4644b1aa4a"), HotelId = Guid.Parse("23de6950-b9b6-426b-a892-503dc1942335"), Number = "302", Floor = 3, Capacity = 1 },
                new Room { Id = Guid.Parse("93e98279-415c-41ec-afe4-6b6181bed3c4"), HotelId = Guid.Parse("23de6950-b9b6-426b-a892-503dc1942335"), Number = "303", Floor = 3, Capacity = 1 },
                new Room { Id = Guid.Parse("d6aacec0-acf1-492b-80d1-2ac45edd6c8c"), HotelId = Guid.Parse("23de6950-b9b6-426b-a892-503dc1942335"), Number = "401", Floor = 4, Capacity = 1 },
                new Room { Id = Guid.Parse("7a3a8ee8-58f7-4c29-a924-e47adff5c4ff"), HotelId = Guid.Parse("23de6950-b9b6-426b-a892-503dc1942335"), Number = "402", Floor = 4, Capacity = 1 },
                new Room { Id = Guid.Parse("a57d1ec6-180b-480f-ba6b-245e18ecc019"), HotelId = Guid.Parse("23de6950-b9b6-426b-a892-503dc1942335"), Number = "403", Floor = 4, Capacity = 1 },

                new Room { Id = Guid.Parse("841f6c53-d0f6-40b5-ba56-5bd40aa0127c"), HotelId = Guid.Parse("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), Number = "101", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("d61387b3-02dc-446c-922a-621e2d4a0a57"), HotelId = Guid.Parse("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), Number = "102", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("cb87c0f2-13cb-43ed-a245-18c576f7d711"), HotelId = Guid.Parse("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), Number = "103", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("f8266773-61a1-4888-8682-03b9b7f210df"), HotelId = Guid.Parse("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), Number = "104", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("247c1e4f-c5cf-47b3-afac-58e2c95de7ff"), HotelId = Guid.Parse("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), Number = "105", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("be837b05-891f-4304-9e6d-b48a87001494"), HotelId = Guid.Parse("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), Number = "106", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("672487eb-15bd-469c-99af-ee16c5b94a85"), HotelId = Guid.Parse("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), Number = "201", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("4245db33-d186-4cbb-8f16-51bcfdfaa184"), HotelId = Guid.Parse("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), Number = "202", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("6faed1cf-cced-4a68-b856-88c3e6ee3b82"), HotelId = Guid.Parse("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), Number = "203", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("305f6f57-7575-48f9-9b7a-69331d9f2f24"), HotelId = Guid.Parse("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), Number = "204", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("a8c07a37-66b4-4ba5-aad4-3ee60605e52e"), HotelId = Guid.Parse("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), Number = "205", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("4d205fdc-5683-467c-a9b0-298549929804"), HotelId = Guid.Parse("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), Number = "206", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("45941394-d096-49f1-b9c4-f80d37551999"), HotelId = Guid.Parse("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), Number = "207", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("bb2ab1f8-8740-4428-be85-e4d684d29a33"), HotelId = Guid.Parse("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), Number = "208", Floor = 2, Capacity = 2 },

                new Room { Id = Guid.Parse("6fe8fe67-80b5-44a2-a674-e54f8b30274c"), HotelId = Guid.Parse("a98f77b5-4572-485f-b355-7f565238eca9"), Number = "101", Floor = 1, Capacity = 1 },
                new Room { Id = Guid.Parse("da5b3fe3-6d72-4833-a9ce-a363c597fb97"), HotelId = Guid.Parse("a98f77b5-4572-485f-b355-7f565238eca9"), Number = "102", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("10ca8d19-1dda-443f-be80-7c7c2efba499"), HotelId = Guid.Parse("a98f77b5-4572-485f-b355-7f565238eca9"), Number = "103", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("6499a01f-fc7d-4ed2-bf4b-08e089977909"), HotelId = Guid.Parse("a98f77b5-4572-485f-b355-7f565238eca9"), Number = "201", Floor = 2, Capacity = 1 },
                new Room { Id = Guid.Parse("2828863c-f340-4631-ac60-151cc274f707"), HotelId = Guid.Parse("a98f77b5-4572-485f-b355-7f565238eca9"), Number = "202", Floor = 2, Capacity = 4 },
                new Room { Id = Guid.Parse("338f21eb-4808-40fb-ba0a-9f81d4773e87"), HotelId = Guid.Parse("a98f77b5-4572-485f-b355-7f565238eca9"), Number = "203", Floor = 2, Capacity = 4 },

                new Room { Id = Guid.Parse("25c28785-a085-44a2-9462-08824c040d32"), HotelId = Guid.Parse("c26bc1bd-9264-4d53-9c04-9e9a7aca7d0f"), Number = "101", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("61e19d6f-4a69-4621-bda3-c47d7c2614bb"), HotelId = Guid.Parse("c26bc1bd-9264-4d53-9c04-9e9a7aca7d0f"), Number = "102", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("9c19afaa-803a-4fb5-b213-d9ac6803edfd"), HotelId = Guid.Parse("c26bc1bd-9264-4d53-9c04-9e9a7aca7d0f"), Number = "103", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("1b119065-e85f-413b-b4e3-ae3d17363617"), HotelId = Guid.Parse("c26bc1bd-9264-4d53-9c04-9e9a7aca7d0f"), Number = "104", Floor = 1, Capacity = 5 },
                new Room { Id = Guid.Parse("9599adc6-61c9-41c8-915f-58d4c7f2e98c"), HotelId = Guid.Parse("c26bc1bd-9264-4d53-9c04-9e9a7aca7d0f"), Number = "105", Floor = 1, Capacity = 4 },
                new Room { Id = Guid.Parse("8bbe50f3-9cf4-41ee-b46b-d2ec1fa3d5a9"), HotelId = Guid.Parse("c26bc1bd-9264-4d53-9c04-9e9a7aca7d0f"), Number = "106", Floor = 1, Capacity = 2 },

                new Room { Id = Guid.Parse("52150feb-4bf2-4818-a0a3-2e85580c5d59"), HotelId = Guid.Parse("1ba6d3a7-beae-4745-b818-e62e150fbb0b"), Number = "101", Floor = 1, Capacity = 1 },
                new Room { Id = Guid.Parse("89d63328-9b59-4ddc-8485-41d33974bc81"), HotelId = Guid.Parse("1ba6d3a7-beae-4745-b818-e62e150fbb0b"), Number = "102", Floor = 1, Capacity = 1 },
                new Room { Id = Guid.Parse("97cbf9e4-d22f-4230-a607-32368fc95da2"), HotelId = Guid.Parse("1ba6d3a7-beae-4745-b818-e62e150fbb0b"), Number = "103", Floor = 1, Capacity = 1 },
                new Room { Id = Guid.Parse("07894cbb-397e-4c84-9a16-5184385f3d0a"), HotelId = Guid.Parse("1ba6d3a7-beae-4745-b818-e62e150fbb0b"), Number = "201", Floor = 2, Capacity = 1 },
                new Room { Id = Guid.Parse("640f1940-7a07-4322-a99a-2285d5bf1c21"), HotelId = Guid.Parse("1ba6d3a7-beae-4745-b818-e62e150fbb0b"), Number = "202", Floor = 2, Capacity = 1 },
                new Room { Id = Guid.Parse("7db92a1e-9a8f-43f9-931c-97bbcf24e355"), HotelId = Guid.Parse("1ba6d3a7-beae-4745-b818-e62e150fbb0b"), Number = "203", Floor = 2, Capacity = 1 },
                new Room { Id = Guid.Parse("cfba9831-0f96-4985-940e-70a655d13876"), HotelId = Guid.Parse("1ba6d3a7-beae-4745-b818-e62e150fbb0b"), Number = "301", Floor = 3, Capacity = 1 },
                new Room { Id = Guid.Parse("d65b6ff4-8bdc-4aea-9b35-a3cfed9b1483"), HotelId = Guid.Parse("1ba6d3a7-beae-4745-b818-e62e150fbb0b"), Number = "302", Floor = 3, Capacity = 1 },
                new Room { Id = Guid.Parse("4a682304-8272-4493-8225-97fb258f389c"), HotelId = Guid.Parse("1ba6d3a7-beae-4745-b818-e62e150fbb0b"), Number = "303", Floor = 3, Capacity = 1 },
                new Room { Id = Guid.Parse("b8047f8a-9ceb-4b55-927d-cffb9e5cada2"), HotelId = Guid.Parse("1ba6d3a7-beae-4745-b818-e62e150fbb0b"), Number = "401", Floor = 4, Capacity = 1 },
                new Room { Id = Guid.Parse("3a38ebdb-7ef3-47a8-8501-ca361c3dcde8"), HotelId = Guid.Parse("1ba6d3a7-beae-4745-b818-e62e150fbb0b"), Number = "402", Floor = 4, Capacity = 1 },
                new Room { Id = Guid.Parse("648ebe68-0f73-4cb1-a8a5-668d5546c1aa"), HotelId = Guid.Parse("1ba6d3a7-beae-4745-b818-e62e150fbb0b"), Number = "403", Floor = 4, Capacity = 1 },

                new Room { Id = Guid.Parse("b5c02714-d709-46c5-b0f5-82cd40c8815b"), HotelId = Guid.Parse("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), Number = "101", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("7a70bed3-1d82-4e34-8c13-1ea95f016639"), HotelId = Guid.Parse("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), Number = "102", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("0c9aeddd-87a2-4f6d-9c01-766d55f8d14c"), HotelId = Guid.Parse("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), Number = "103", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("bc3e74d0-8f36-486a-87fb-9e0d34d3c202"), HotelId = Guid.Parse("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), Number = "104", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("0401b525-45fe-4c75-992d-10adcd4cef60"), HotelId = Guid.Parse("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), Number = "105", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("3b41d3c9-3eb7-4ff8-b40b-e8edd3fe0795"), HotelId = Guid.Parse("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), Number = "106", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("760a5317-35ee-440d-81a5-745dc5995f45"), HotelId = Guid.Parse("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), Number = "107", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("fa6b67c0-2c7f-4db6-a7f4-43883471dfbe"), HotelId = Guid.Parse("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), Number = "201", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("92470ca6-a55b-4662-b053-260ec99a1eee"), HotelId = Guid.Parse("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), Number = "202", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("df5e5c52-6799-4052-a306-3fc67347443a"), HotelId = Guid.Parse("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), Number = "203", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("593eec4d-81d5-43b0-abf7-7577cb30495e"), HotelId = Guid.Parse("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), Number = "204", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("b5f0b3a3-23c6-4e44-b551-65ee5e5e8102"), HotelId = Guid.Parse("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), Number = "205", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("e8716a6a-83b0-48b0-8bcd-4385f31f58c0"), HotelId = Guid.Parse("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), Number = "206", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("962b2d27-e389-4513-9c12-1c3656cd8258"), HotelId = Guid.Parse("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), Number = "207", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("3b79559c-d8ca-4c03-aeac-831fed4cc055"), HotelId = Guid.Parse("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), Number = "208", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("6b6e7865-95f8-4170-8c6f-e23e6b751b7f"), HotelId = Guid.Parse("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), Number = "209", Floor = 2, Capacity = 2 },

                new Room { Id = Guid.Parse("258d4c97-f2b6-4542-8cbc-1aa193cba708"), HotelId = Guid.Parse("88e473f7-8048-465b-ad3b-9f711c6fba82"), Number = "101", Floor = 1, Capacity = 1 },
                new Room { Id = Guid.Parse("2cc778a8-1c37-4b11-a6a3-be4e4a759a61"), HotelId = Guid.Parse("88e473f7-8048-465b-ad3b-9f711c6fba82"), Number = "102", Floor = 1, Capacity = 1 },
                new Room { Id = Guid.Parse("1adbfe2a-25b3-4dd6-b2de-78d8588cd0f6"), HotelId = Guid.Parse("88e473f7-8048-465b-ad3b-9f711c6fba82"), Number = "103", Floor = 1, Capacity = 1 },
                new Room { Id = Guid.Parse("73bd48b4-7884-4459-b658-338d0679cc01"), HotelId = Guid.Parse("88e473f7-8048-465b-ad3b-9f711c6fba82"), Number = "201", Floor = 2, Capacity = 1 },
                new Room { Id = Guid.Parse("f31b366f-d359-4e4e-ada6-e6e8f75ad737"), HotelId = Guid.Parse("88e473f7-8048-465b-ad3b-9f711c6fba82"), Number = "202", Floor = 2, Capacity = 1 },
                new Room { Id = Guid.Parse("65d90003-979d-49a3-98d8-2cd157dcda6b"), HotelId = Guid.Parse("88e473f7-8048-465b-ad3b-9f711c6fba82"), Number = "203", Floor = 2, Capacity = 1 },
                new Room { Id = Guid.Parse("99baa070-27ad-44fa-a302-fd1f4c5b1bec"), HotelId = Guid.Parse("88e473f7-8048-465b-ad3b-9f711c6fba82"), Number = "301", Floor = 3, Capacity = 1 },
                new Room { Id = Guid.Parse("3236355d-8f3b-4745-9239-0059bccbceec"), HotelId = Guid.Parse("88e473f7-8048-465b-ad3b-9f711c6fba82"), Number = "302", Floor = 3, Capacity = 1 },
                new Room { Id = Guid.Parse("8dc91a10-06d1-4abb-861f-6ada4089e98c"), HotelId = Guid.Parse("88e473f7-8048-465b-ad3b-9f711c6fba82"), Number = "303", Floor = 3, Capacity = 1 },
                new Room { Id = Guid.Parse("fd13abe4-838f-46ec-b3c3-3348cde71487"), HotelId = Guid.Parse("88e473f7-8048-465b-ad3b-9f711c6fba82"), Number = "401", Floor = 4, Capacity = 1 },
                new Room { Id = Guid.Parse("66de7dcc-856b-4a58-8062-300dab4269c9"), HotelId = Guid.Parse("88e473f7-8048-465b-ad3b-9f711c6fba82"), Number = "402", Floor = 4, Capacity = 1 },
                new Room { Id = Guid.Parse("700e3dda-3a9e-48cb-b57b-852929837818"), HotelId = Guid.Parse("88e473f7-8048-465b-ad3b-9f711c6fba82"), Number = "403", Floor = 4, Capacity = 1 },

                new Room { Id = Guid.Parse("1078d6d9-76db-4fe9-b14f-338df0ca4337"), HotelId = Guid.Parse("b05df49e-1f60-4128-888f-4f5836cc043b"), Number = "101", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("8d8d378a-40e0-4022-abe4-23462293fc96"), HotelId = Guid.Parse("b05df49e-1f60-4128-888f-4f5836cc043b"), Number = "102", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("f3180f39-3869-4de2-8910-d53ced60ce24"), HotelId = Guid.Parse("b05df49e-1f60-4128-888f-4f5836cc043b"), Number = "103", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("ad57fa94-050b-43a5-9105-8916ec3671aa"), HotelId = Guid.Parse("b05df49e-1f60-4128-888f-4f5836cc043b"), Number = "104", Floor = 1, Capacity = 5 },
                new Room { Id = Guid.Parse("67302c16-9d04-4e1a-a3ca-59686a8c9284"), HotelId = Guid.Parse("b05df49e-1f60-4128-888f-4f5836cc043b"), Number = "105", Floor = 1, Capacity = 4 },
                new Room { Id = Guid.Parse("bb4d13f0-f69c-41c1-b346-9f564d7aabc8"), HotelId = Guid.Parse("b05df49e-1f60-4128-888f-4f5836cc043b"), Number = "106", Floor = 1, Capacity = 2 },

                new Room { Id = Guid.Parse("68c66403-7d68-4919-8bbf-0d39969ffd87"), HotelId = Guid.Parse("fbf4e4dc-c068-472c-8feb-d809384c3af8"), Number = "101", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("fbde0d19-5a64-4716-8f2a-ebe60c2075a1"), HotelId = Guid.Parse("fbf4e4dc-c068-472c-8feb-d809384c3af8"), Number = "102", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("cc9c982c-8fb7-4124-873d-b69ff3456a44"), HotelId = Guid.Parse("fbf4e4dc-c068-472c-8feb-d809384c3af8"), Number = "103", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("b8289abf-943d-4754-b535-0c8b30f656d1"), HotelId = Guid.Parse("fbf4e4dc-c068-472c-8feb-d809384c3af8"), Number = "104", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("93693c4c-dead-4395-8fac-cfd3c63404d3"), HotelId = Guid.Parse("fbf4e4dc-c068-472c-8feb-d809384c3af8"), Number = "105", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("3faef830-ff98-486f-8db2-5b820a8f5712"), HotelId = Guid.Parse("fbf4e4dc-c068-472c-8feb-d809384c3af8"), Number = "106", Floor = 1, Capacity = 2 },
                new Room { Id = Guid.Parse("8ce6f406-95f7-4744-a110-f9e52c3114dd"), HotelId = Guid.Parse("fbf4e4dc-c068-472c-8feb-d809384c3af8"), Number = "201", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("deef57ea-7770-4cb3-86e3-c0260936ca8e"), HotelId = Guid.Parse("fbf4e4dc-c068-472c-8feb-d809384c3af8"), Number = "202", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("4d2fff97-68a5-4ea6-9d4b-a0a0c3f689ec"), HotelId = Guid.Parse("fbf4e4dc-c068-472c-8feb-d809384c3af8"), Number = "203", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("53300253-ddc0-4394-ada8-666d77bd080f"), HotelId = Guid.Parse("fbf4e4dc-c068-472c-8feb-d809384c3af8"), Number = "204", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("deec06df-c9ab-4ed1-af3e-0cb8463512ea"), HotelId = Guid.Parse("fbf4e4dc-c068-472c-8feb-d809384c3af8"), Number = "205", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("ec07ab88-57f7-4c6a-b366-3a5a52be055c"), HotelId = Guid.Parse("fbf4e4dc-c068-472c-8feb-d809384c3af8"), Number = "206", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("c12bf98d-77b2-4835-a5c3-91fd3234755d"), HotelId = Guid.Parse("fbf4e4dc-c068-472c-8feb-d809384c3af8"), Number = "207", Floor = 2, Capacity = 2 },
                new Room { Id = Guid.Parse("612b2d89-3067-4e4c-b801-777889ff6985"), HotelId = Guid.Parse("fbf4e4dc-c068-472c-8feb-d809384c3af8"), Number = "208", Floor = 2, Capacity = 2 }
            );
        }

        public DbSet<Country> Countries { get; set; }
        public DbSet<Hotel> Hotels { get; set; }
        public DbSet<Room> Rooms { get; set; }

    }
}
