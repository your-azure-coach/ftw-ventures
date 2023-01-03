using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Ftw.Hotels.HotelCatalog.Data.Migrations
{
    /// <inheritdoc />
    public partial class hotelsrooms : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "City",
                table: "Hotels",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<Guid>(
                name: "CountryId",
                table: "Hotels",
                type: "uniqueidentifier",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<double>(
                name: "Latitude",
                table: "Hotels",
                type: "float",
                nullable: false,
                defaultValue: 0.0);

            migrationBuilder.AddColumn<double>(
                name: "Longitude",
                table: "Hotels",
                type: "float",
                nullable: false,
                defaultValue: 0.0);

            migrationBuilder.UpdateData(
                table: "Countries",
                keyColumn: "Id",
                keyValue: new Guid("337b4bfa-8906-4035-a0ef-260ec8034469"),
                columns: new[] { "Code", "Name" },
                values: new object[] { "US", "United States of America" });

            migrationBuilder.UpdateData(
                table: "Countries",
                keyColumn: "Id",
                keyValue: new Guid("f42bec68-0475-4843-a16b-d4307acb80a3"),
                columns: new[] { "Code", "Name" },
                values: new object[] { "JP", "Japan" });

            migrationBuilder.InsertData(
                table: "Hotels",
                columns: new[] { "Id", "City", "CountryId", "Description", "Latitude", "Longitude", "Name", "Stars" },
                values: new object[,]
                {
                    { new Guid("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), "Washington", new Guid("337b4bfa-8906-4035-a0ef-260ec8034469"), "", 38.8950368, -77.036542699999998, "Eastern Willow Hotel", 4 },
                    { new Guid("1b43177a-c518-4b2a-909a-ee4fc84c6820"), "Hasselt", new Guid("4e206904-5ce5-45c2-97c0-5c9aff34bf74"), "", 50.930691000000003, 5.3324800000000003, "Queen's Cosmos Motel", 4 },
                    { new Guid("1ba6d3a7-beae-4745-b818-e62e150fbb0b"), "New York", new Guid("337b4bfa-8906-4035-a0ef-260ec8034469"), "", 40.7127281, -74.006015199999993, "Farmhouse Resort", 5 },
                    { new Guid("23de6950-b9b6-426b-a892-503dc1942335"), "Bruges", new Guid("4e206904-5ce5-45c2-97c0-5c9aff34bf74"), "", 51.209347000000001, 3.2246990000000002, "Prism Hotel", 3 },
                    { new Guid("2eb0d367-1fe6-4968-9d99-13cdf192b984"), "Brussels", new Guid("4e206904-5ce5-45c2-97c0-5c9aff34bf74"), "", 50.850346000000002, 4.3517210000000004, "Crown Resort & Spa", 4 },
                    { new Guid("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), "Osaka", new Guid("f42bec68-0475-4843-a16b-d4307acb80a3"), "", 34.693736999999999, 135.50216699999999, "Paragon Motel", 4 },
                    { new Guid("88e473f7-8048-465b-ad3b-9f711c6fba82"), "Los Angeles", new Guid("337b4bfa-8906-4035-a0ef-260ec8034469"), "", 34.053690899999999, -118.242766, "Paradise Resort", 3 },
                    { new Guid("a98f77b5-4572-485f-b355-7f565238eca9"), "Kyoto", new Guid("f42bec68-0475-4843-a16b-d4307acb80a3"), "", 35.021040999999997, 135.7556075, "Ruby Shores Hotel", 4 },
                    { new Guid("b05df49e-1f60-4128-888f-4f5836cc043b"), "Chicago", new Guid("337b4bfa-8906-4035-a0ef-260ec8034469"), "", 41.875561599999997, -87.6244212, "Antique Bay Spa", 3 },
                    { new Guid("c26bc1bd-9264-4d53-9c04-9e9a7aca7d0f"), "Sakai", new Guid("f42bec68-0475-4843-a16b-d4307acb80a3"), "", 34.529124000000003, 135.50156000000001, "Sunset Legacy Hotel", 5 },
                    { new Guid("e7432cfd-41df-4b37-b641-c8dbf94328e1"), "Kortrijk", new Guid("4e206904-5ce5-45c2-97c0-5c9aff34bf74"), "", 50.827969000000003, 3.2649300000000001, "Historic Dune Resort", 5 },
                    { new Guid("fbf4e4dc-c068-472c-8feb-d809384c3af8"), "Dallas", new Guid("337b4bfa-8906-4035-a0ef-260ec8034469"), "", 32.776271899999998, -96.796855899999997, "Antique Cavern Hotel", 4 }
                });

            migrationBuilder.InsertData(
                table: "Rooms",
                columns: new[] { "Id", "Capacity", "Floor", "HotelId", "Number" },
                values: new object[,]
                {
                    { new Guid("0203c85b-2362-42a9-9feb-554edee237b8"), 1, 3, new Guid("23de6950-b9b6-426b-a892-503dc1942335"), "301" },
                    { new Guid("0236ca82-afe0-4b35-9fcf-8fb3187a18bb"), 2, 1, new Guid("e7432cfd-41df-4b37-b641-c8dbf94328e1"), "104" },
                    { new Guid("0401b525-45fe-4c75-992d-10adcd4cef60"), 2, 1, new Guid("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), "105" },
                    { new Guid("04dab6ae-b643-4b75-a12a-ee4644b1aa4a"), 1, 3, new Guid("23de6950-b9b6-426b-a892-503dc1942335"), "302" },
                    { new Guid("06d8c1fe-7006-4383-aeb9-51b5a67880a7"), 5, 1, new Guid("1b43177a-c518-4b2a-909a-ee4fc84c6820"), "104" },
                    { new Guid("07894cbb-397e-4c84-9a16-5184385f3d0a"), 1, 2, new Guid("1ba6d3a7-beae-4745-b818-e62e150fbb0b"), "201" },
                    { new Guid("0c9aeddd-87a2-4f6d-9c01-766d55f8d14c"), 2, 1, new Guid("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), "103" },
                    { new Guid("0f0c36dd-90a6-498f-b3d2-5862336eddca"), 2, 2, new Guid("e7432cfd-41df-4b37-b641-c8dbf94328e1"), "209" },
                    { new Guid("1078d6d9-76db-4fe9-b14f-338df0ca4337"), 2, 1, new Guid("b05df49e-1f60-4128-888f-4f5836cc043b"), "101" },
                    { new Guid("10ca8d19-1dda-443f-be80-7c7c2efba499"), 2, 1, new Guid("a98f77b5-4572-485f-b355-7f565238eca9"), "103" },
                    { new Guid("1adbfe2a-25b3-4dd6-b2de-78d8588cd0f6"), 1, 1, new Guid("88e473f7-8048-465b-ad3b-9f711c6fba82"), "103" },
                    { new Guid("1b119065-e85f-413b-b4e3-ae3d17363617"), 5, 1, new Guid("c26bc1bd-9264-4d53-9c04-9e9a7aca7d0f"), "104" },
                    { new Guid("1cef858b-5c87-4fdb-b997-752aa5dce2a2"), 2, 1, new Guid("1b43177a-c518-4b2a-909a-ee4fc84c6820"), "102" },
                    { new Guid("1d582461-c165-457a-a834-57eb36fa6c92"), 2, 1, new Guid("e7432cfd-41df-4b37-b641-c8dbf94328e1"), "106" },
                    { new Guid("247c1e4f-c5cf-47b3-afac-58e2c95de7ff"), 2, 1, new Guid("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), "105" },
                    { new Guid("258d4c97-f2b6-4542-8cbc-1aa193cba708"), 1, 1, new Guid("88e473f7-8048-465b-ad3b-9f711c6fba82"), "101" },
                    { new Guid("25c28785-a085-44a2-9462-08824c040d32"), 2, 1, new Guid("c26bc1bd-9264-4d53-9c04-9e9a7aca7d0f"), "101" },
                    { new Guid("268ca2d2-2fd5-43a1-bf68-293f6ce33f31"), 1, 1, new Guid("2eb0d367-1fe6-4968-9d99-13cdf192b984"), "101" },
                    { new Guid("2828863c-f340-4631-ac60-151cc274f707"), 4, 2, new Guid("a98f77b5-4572-485f-b355-7f565238eca9"), "202" },
                    { new Guid("2cc778a8-1c37-4b11-a6a3-be4e4a759a61"), 1, 1, new Guid("88e473f7-8048-465b-ad3b-9f711c6fba82"), "102" },
                    { new Guid("305f6f57-7575-48f9-9b7a-69331d9f2f24"), 2, 2, new Guid("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), "204" },
                    { new Guid("3236355d-8f3b-4745-9239-0059bccbceec"), 1, 3, new Guid("88e473f7-8048-465b-ad3b-9f711c6fba82"), "302" },
                    { new Guid("338f21eb-4808-40fb-ba0a-9f81d4773e87"), 4, 2, new Guid("a98f77b5-4572-485f-b355-7f565238eca9"), "203" },
                    { new Guid("3a38ebdb-7ef3-47a8-8501-ca361c3dcde8"), 1, 4, new Guid("1ba6d3a7-beae-4745-b818-e62e150fbb0b"), "402" },
                    { new Guid("3b41d3c9-3eb7-4ff8-b40b-e8edd3fe0795"), 2, 1, new Guid("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), "106" },
                    { new Guid("3b79559c-d8ca-4c03-aeac-831fed4cc055"), 2, 2, new Guid("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), "208" },
                    { new Guid("3faef830-ff98-486f-8db2-5b820a8f5712"), 2, 1, new Guid("fbf4e4dc-c068-472c-8feb-d809384c3af8"), "106" },
                    { new Guid("4245db33-d186-4cbb-8f16-51bcfdfaa184"), 2, 2, new Guid("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), "202" },
                    { new Guid("45941394-d096-49f1-b9c4-f80d37551999"), 2, 2, new Guid("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), "207" },
                    { new Guid("4a682304-8272-4493-8225-97fb258f389c"), 1, 3, new Guid("1ba6d3a7-beae-4745-b818-e62e150fbb0b"), "303" },
                    { new Guid("4ae69a56-a4ff-4416-8fd6-7c44c993af2b"), 1, 2, new Guid("23de6950-b9b6-426b-a892-503dc1942335"), "202" },
                    { new Guid("4d205fdc-5683-467c-a9b0-298549929804"), 2, 2, new Guid("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), "206" },
                    { new Guid("4d2fff97-68a5-4ea6-9d4b-a0a0c3f689ec"), 2, 2, new Guid("fbf4e4dc-c068-472c-8feb-d809384c3af8"), "203" },
                    { new Guid("51c84918-3a1c-48b7-9279-daf3efd0c336"), 2, 2, new Guid("e7432cfd-41df-4b37-b641-c8dbf94328e1"), "204" },
                    { new Guid("52150feb-4bf2-4818-a0a3-2e85580c5d59"), 1, 1, new Guid("1ba6d3a7-beae-4745-b818-e62e150fbb0b"), "101" },
                    { new Guid("53300253-ddc0-4394-ada8-666d77bd080f"), 2, 2, new Guid("fbf4e4dc-c068-472c-8feb-d809384c3af8"), "204" },
                    { new Guid("593eec4d-81d5-43b0-abf7-7577cb30495e"), 2, 2, new Guid("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), "204" },
                    { new Guid("5c9b18b7-6f44-4c8d-9d2e-c491b6b38460"), 1, 2, new Guid("23de6950-b9b6-426b-a892-503dc1942335"), "201" },
                    { new Guid("612b2d89-3067-4e4c-b801-777889ff6985"), 2, 2, new Guid("fbf4e4dc-c068-472c-8feb-d809384c3af8"), "208" },
                    { new Guid("61e19d6f-4a69-4621-bda3-c47d7c2614bb"), 2, 1, new Guid("c26bc1bd-9264-4d53-9c04-9e9a7aca7d0f"), "102" },
                    { new Guid("6303cba9-a76e-4d2b-82b7-057fcccb36c1"), 2, 1, new Guid("1b43177a-c518-4b2a-909a-ee4fc84c6820"), "101" },
                    { new Guid("640f1940-7a07-4322-a99a-2285d5bf1c21"), 1, 2, new Guid("1ba6d3a7-beae-4745-b818-e62e150fbb0b"), "202" },
                    { new Guid("6479c299-b7f8-4023-98df-edb8c530fc34"), 1, 1, new Guid("23de6950-b9b6-426b-a892-503dc1942335"), "101" },
                    { new Guid("648ebe68-0f73-4cb1-a8a5-668d5546c1aa"), 1, 4, new Guid("1ba6d3a7-beae-4745-b818-e62e150fbb0b"), "403" },
                    { new Guid("6499a01f-fc7d-4ed2-bf4b-08e089977909"), 1, 2, new Guid("a98f77b5-4572-485f-b355-7f565238eca9"), "201" },
                    { new Guid("65d90003-979d-49a3-98d8-2cd157dcda6b"), 1, 2, new Guid("88e473f7-8048-465b-ad3b-9f711c6fba82"), "203" },
                    { new Guid("66de7dcc-856b-4a58-8062-300dab4269c9"), 1, 4, new Guid("88e473f7-8048-465b-ad3b-9f711c6fba82"), "402" },
                    { new Guid("672487eb-15bd-469c-99af-ee16c5b94a85"), 2, 2, new Guid("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), "201" },
                    { new Guid("67302c16-9d04-4e1a-a3ca-59686a8c9284"), 4, 1, new Guid("b05df49e-1f60-4128-888f-4f5836cc043b"), "105" },
                    { new Guid("68c66403-7d68-4919-8bbf-0d39969ffd87"), 2, 1, new Guid("fbf4e4dc-c068-472c-8feb-d809384c3af8"), "101" },
                    { new Guid("6b6e7865-95f8-4170-8c6f-e23e6b751b7f"), 2, 2, new Guid("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), "209" },
                    { new Guid("6c7abc41-2099-4e6d-af1c-3fe563075404"), 1, 1, new Guid("1b43177a-c518-4b2a-909a-ee4fc84c6820"), "107" },
                    { new Guid("6faed1cf-cced-4a68-b856-88c3e6ee3b82"), 2, 2, new Guid("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), "203" },
                    { new Guid("6fe8fe67-80b5-44a2-a674-e54f8b30274c"), 1, 1, new Guid("a98f77b5-4572-485f-b355-7f565238eca9"), "101" },
                    { new Guid("700e3dda-3a9e-48cb-b57b-852929837818"), 1, 4, new Guid("88e473f7-8048-465b-ad3b-9f711c6fba82"), "403" },
                    { new Guid("7230b419-7743-4546-9f48-aa97486d60b7"), 2, 1, new Guid("1b43177a-c518-4b2a-909a-ee4fc84c6820"), "106" },
                    { new Guid("73bd48b4-7884-4459-b658-338d0679cc01"), 1, 2, new Guid("88e473f7-8048-465b-ad3b-9f711c6fba82"), "201" },
                    { new Guid("759d2158-b840-4c4a-8ea2-3a404b38812e"), 1, 2, new Guid("23de6950-b9b6-426b-a892-503dc1942335"), "203" },
                    { new Guid("760a5317-35ee-440d-81a5-745dc5995f45"), 2, 1, new Guid("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), "107" },
                    { new Guid("7a3a8ee8-58f7-4c29-a924-e47adff5c4ff"), 1, 4, new Guid("23de6950-b9b6-426b-a892-503dc1942335"), "402" },
                    { new Guid("7a70bed3-1d82-4e34-8c13-1ea95f016639"), 2, 1, new Guid("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), "102" },
                    { new Guid("7d4ed052-bda2-4dfd-8b3e-13246bbafce0"), 1, 3, new Guid("2eb0d367-1fe6-4968-9d99-13cdf192b984"), "302" },
                    { new Guid("7db92a1e-9a8f-43f9-931c-97bbcf24e355"), 1, 2, new Guid("1ba6d3a7-beae-4745-b818-e62e150fbb0b"), "203" },
                    { new Guid("829fa15f-e883-428b-8082-908c98380ac4"), 2, 1, new Guid("e7432cfd-41df-4b37-b641-c8dbf94328e1"), "105" },
                    { new Guid("82c9b20f-5304-4d53-8818-39af4ca5381d"), 2, 2, new Guid("e7432cfd-41df-4b37-b641-c8dbf94328e1"), "201" },
                    { new Guid("836f2785-cece-4489-8e31-a63a23a0f2bf"), 2, 2, new Guid("e7432cfd-41df-4b37-b641-c8dbf94328e1"), "208" },
                    { new Guid("841f6c53-d0f6-40b5-ba56-5bd40aa0127c"), 2, 1, new Guid("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), "101" },
                    { new Guid("89bac4c7-6879-4df3-a332-42887a2aa076"), 1, 1, new Guid("23de6950-b9b6-426b-a892-503dc1942335"), "102" },
                    { new Guid("89d63328-9b59-4ddc-8485-41d33974bc81"), 1, 1, new Guid("1ba6d3a7-beae-4745-b818-e62e150fbb0b"), "102" },
                    { new Guid("8bbe50f3-9cf4-41ee-b46b-d2ec1fa3d5a9"), 2, 1, new Guid("c26bc1bd-9264-4d53-9c04-9e9a7aca7d0f"), "106" },
                    { new Guid("8ce6f406-95f7-4744-a110-f9e52c3114dd"), 2, 2, new Guid("fbf4e4dc-c068-472c-8feb-d809384c3af8"), "201" },
                    { new Guid("8d8d378a-40e0-4022-abe4-23462293fc96"), 2, 1, new Guid("b05df49e-1f60-4128-888f-4f5836cc043b"), "102" },
                    { new Guid("8dc91a10-06d1-4abb-861f-6ada4089e98c"), 1, 3, new Guid("88e473f7-8048-465b-ad3b-9f711c6fba82"), "303" },
                    { new Guid("92470ca6-a55b-4662-b053-260ec99a1eee"), 2, 2, new Guid("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), "202" },
                    { new Guid("93000f05-3afa-4c37-b0e7-2700efcd0612"), 2, 1, new Guid("2eb0d367-1fe6-4968-9d99-13cdf192b984"), "102" },
                    { new Guid("93693c4c-dead-4395-8fac-cfd3c63404d3"), 2, 1, new Guid("fbf4e4dc-c068-472c-8feb-d809384c3af8"), "105" },
                    { new Guid("93e98279-415c-41ec-afe4-6b6181bed3c4"), 1, 3, new Guid("23de6950-b9b6-426b-a892-503dc1942335"), "303" },
                    { new Guid("9599adc6-61c9-41c8-915f-58d4c7f2e98c"), 4, 1, new Guid("c26bc1bd-9264-4d53-9c04-9e9a7aca7d0f"), "105" },
                    { new Guid("962b2d27-e389-4513-9c12-1c3656cd8258"), 2, 2, new Guid("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), "207" },
                    { new Guid("964ca8a8-7245-46af-ace8-e84d9079805f"), 2, 1, new Guid("e7432cfd-41df-4b37-b641-c8dbf94328e1"), "102" },
                    { new Guid("97cbf9e4-d22f-4230-a607-32368fc95da2"), 1, 1, new Guid("1ba6d3a7-beae-4745-b818-e62e150fbb0b"), "103" },
                    { new Guid("99baa070-27ad-44fa-a302-fd1f4c5b1bec"), 1, 3, new Guid("88e473f7-8048-465b-ad3b-9f711c6fba82"), "301" },
                    { new Guid("9a087c46-edfc-4d14-b628-c16baa4b2f08"), 1, 1, new Guid("1b43177a-c518-4b2a-909a-ee4fc84c6820"), "108" },
                    { new Guid("9c19afaa-803a-4fb5-b213-d9ac6803edfd"), 2, 1, new Guid("c26bc1bd-9264-4d53-9c04-9e9a7aca7d0f"), "103" },
                    { new Guid("9e79c29e-6669-40b0-90e3-581de2e846aa"), 2, 2, new Guid("e7432cfd-41df-4b37-b641-c8dbf94328e1"), "206" },
                    { new Guid("a57d1ec6-180b-480f-ba6b-245e18ecc019"), 1, 4, new Guid("23de6950-b9b6-426b-a892-503dc1942335"), "403" },
                    { new Guid("a8c07a37-66b4-4ba5-aad4-3ee60605e52e"), 2, 2, new Guid("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), "205" },
                    { new Guid("ad57fa94-050b-43a5-9105-8916ec3671aa"), 5, 1, new Guid("b05df49e-1f60-4128-888f-4f5836cc043b"), "104" },
                    { new Guid("b5c02714-d709-46c5-b0f5-82cd40c8815b"), 2, 1, new Guid("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), "101" },
                    { new Guid("b5f0b3a3-23c6-4e44-b551-65ee5e5e8102"), 2, 2, new Guid("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), "205" },
                    { new Guid("b67a9def-f00c-4fd5-a934-b659c5f8ee03"), 2, 1, new Guid("1b43177a-c518-4b2a-909a-ee4fc84c6820"), "103" },
                    { new Guid("b8047f8a-9ceb-4b55-927d-cffb9e5cada2"), 1, 4, new Guid("1ba6d3a7-beae-4745-b818-e62e150fbb0b"), "401" },
                    { new Guid("b8289abf-943d-4754-b535-0c8b30f656d1"), 2, 1, new Guid("fbf4e4dc-c068-472c-8feb-d809384c3af8"), "104" },
                    { new Guid("b9ebfecf-4299-4530-9853-4cef81a8fc2d"), 1, 1, new Guid("23de6950-b9b6-426b-a892-503dc1942335"), "103" },
                    { new Guid("ba39e5c2-b1fb-4e64-ad50-44a29f831416"), 2, 1, new Guid("e7432cfd-41df-4b37-b641-c8dbf94328e1"), "103" },
                    { new Guid("bb2ab1f8-8740-4428-be85-e4d684d29a33"), 2, 2, new Guid("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), "208" },
                    { new Guid("bb4d13f0-f69c-41c1-b346-9f564d7aabc8"), 2, 1, new Guid("b05df49e-1f60-4128-888f-4f5836cc043b"), "106" },
                    { new Guid("bc3e74d0-8f36-486a-87fb-9e0d34d3c202"), 2, 1, new Guid("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), "104" },
                    { new Guid("be837b05-891f-4304-9e6d-b48a87001494"), 2, 1, new Guid("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), "106" },
                    { new Guid("c12bf98d-77b2-4835-a5c3-91fd3234755d"), 2, 2, new Guid("fbf4e4dc-c068-472c-8feb-d809384c3af8"), "207" },
                    { new Guid("c20cac9f-b008-4dc2-9616-14d05833f3cf"), 2, 2, new Guid("e7432cfd-41df-4b37-b641-c8dbf94328e1"), "205" },
                    { new Guid("c51d6453-2de8-4a38-acf5-b243884990c6"), 2, 2, new Guid("e7432cfd-41df-4b37-b641-c8dbf94328e1"), "203" },
                    { new Guid("cb87c0f2-13cb-43ed-a245-18c576f7d711"), 2, 1, new Guid("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), "103" },
                    { new Guid("cc9c982c-8fb7-4124-873d-b69ff3456a44"), 2, 1, new Guid("fbf4e4dc-c068-472c-8feb-d809384c3af8"), "103" },
                    { new Guid("cd9f8074-fbe2-4902-b18d-abac2c15f864"), 4, 2, new Guid("2eb0d367-1fe6-4968-9d99-13cdf192b984"), "202" },
                    { new Guid("cf7e4e6f-d46c-46ef-ab6c-e0d67d5e1eae"), 2, 2, new Guid("e7432cfd-41df-4b37-b641-c8dbf94328e1"), "202" },
                    { new Guid("cfba9831-0f96-4985-940e-70a655d13876"), 1, 3, new Guid("1ba6d3a7-beae-4745-b818-e62e150fbb0b"), "301" },
                    { new Guid("d1f4ddd1-bf73-4722-a5ec-ebe11d12d727"), 2, 1, new Guid("2eb0d367-1fe6-4968-9d99-13cdf192b984"), "103" },
                    { new Guid("d61387b3-02dc-446c-922a-621e2d4a0a57"), 2, 1, new Guid("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), "102" },
                    { new Guid("d65b6ff4-8bdc-4aea-9b35-a3cfed9b1483"), 1, 3, new Guid("1ba6d3a7-beae-4745-b818-e62e150fbb0b"), "302" },
                    { new Guid("d6aacec0-acf1-492b-80d1-2ac45edd6c8c"), 1, 4, new Guid("23de6950-b9b6-426b-a892-503dc1942335"), "401" },
                    { new Guid("da5b3fe3-6d72-4833-a9ce-a363c597fb97"), 2, 1, new Guid("a98f77b5-4572-485f-b355-7f565238eca9"), "102" },
                    { new Guid("ddbd2d96-4478-41d8-9d78-af6f3e688124"), 1, 2, new Guid("2eb0d367-1fe6-4968-9d99-13cdf192b984"), "201" },
                    { new Guid("deec06df-c9ab-4ed1-af3e-0cb8463512ea"), 2, 2, new Guid("fbf4e4dc-c068-472c-8feb-d809384c3af8"), "205" },
                    { new Guid("deef57ea-7770-4cb3-86e3-c0260936ca8e"), 2, 2, new Guid("fbf4e4dc-c068-472c-8feb-d809384c3af8"), "202" },
                    { new Guid("df5e5c52-6799-4052-a306-3fc67347443a"), 2, 2, new Guid("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), "203" },
                    { new Guid("e0a0fc8e-6ddf-42a8-b021-a6978664f794"), 2, 2, new Guid("e7432cfd-41df-4b37-b641-c8dbf94328e1"), "207" },
                    { new Guid("e1046fdb-4f8d-4a50-9094-23e1dd369427"), 2, 1, new Guid("e7432cfd-41df-4b37-b641-c8dbf94328e1"), "101" },
                    { new Guid("e233b2be-4d01-4783-a05d-176688c00d9c"), 4, 2, new Guid("2eb0d367-1fe6-4968-9d99-13cdf192b984"), "203" },
                    { new Guid("e8716a6a-83b0-48b0-8bcd-4385f31f58c0"), 2, 2, new Guid("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), "206" },
                    { new Guid("ec07ab88-57f7-4c6a-b366-3a5a52be055c"), 2, 2, new Guid("fbf4e4dc-c068-472c-8feb-d809384c3af8"), "206" },
                    { new Guid("f3180f39-3869-4de2-8910-d53ced60ce24"), 2, 1, new Guid("b05df49e-1f60-4128-888f-4f5836cc043b"), "103" },
                    { new Guid("f31b366f-d359-4e4e-ada6-e6e8f75ad737"), 1, 2, new Guid("88e473f7-8048-465b-ad3b-9f711c6fba82"), "202" },
                    { new Guid("f401ed99-0bf5-4135-90b9-8b67f201965d"), 2, 1, new Guid("e7432cfd-41df-4b37-b641-c8dbf94328e1"), "107" },
                    { new Guid("f67b4346-02d3-4c74-b679-99b99c13994a"), 4, 1, new Guid("1b43177a-c518-4b2a-909a-ee4fc84c6820"), "105" },
                    { new Guid("f8266773-61a1-4888-8682-03b9b7f210df"), 2, 1, new Guid("3a4287d1-8df6-4cf9-92de-6dfe7f094035"), "104" },
                    { new Guid("f8cc5d2c-be43-4870-badf-6c956fbdc4a0"), 2, 3, new Guid("2eb0d367-1fe6-4968-9d99-13cdf192b984"), "301" },
                    { new Guid("fa6b67c0-2c7f-4db6-a7f4-43883471dfbe"), 2, 2, new Guid("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"), "201" },
                    { new Guid("fbde0d19-5a64-4716-8f2a-ebe60c2075a1"), 2, 1, new Guid("fbf4e4dc-c068-472c-8feb-d809384c3af8"), "102" },
                    { new Guid("fd13abe4-838f-46ec-b3c3-3348cde71487"), 1, 4, new Guid("88e473f7-8048-465b-ad3b-9f711c6fba82"), "401" }
                });

            migrationBuilder.CreateIndex(
                name: "IX_Hotels_CountryId",
                table: "Hotels",
                column: "CountryId");

            migrationBuilder.AddForeignKey(
                name: "FK_Hotels_Countries_CountryId",
                table: "Hotels",
                column: "CountryId",
                principalTable: "Countries",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Hotels_Countries_CountryId",
                table: "Hotels");

            migrationBuilder.DropIndex(
                name: "IX_Hotels_CountryId",
                table: "Hotels");

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("0203c85b-2362-42a9-9feb-554edee237b8"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("0236ca82-afe0-4b35-9fcf-8fb3187a18bb"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("0401b525-45fe-4c75-992d-10adcd4cef60"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("04dab6ae-b643-4b75-a12a-ee4644b1aa4a"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("06d8c1fe-7006-4383-aeb9-51b5a67880a7"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("07894cbb-397e-4c84-9a16-5184385f3d0a"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("0c9aeddd-87a2-4f6d-9c01-766d55f8d14c"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("0f0c36dd-90a6-498f-b3d2-5862336eddca"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("1078d6d9-76db-4fe9-b14f-338df0ca4337"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("10ca8d19-1dda-443f-be80-7c7c2efba499"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("1adbfe2a-25b3-4dd6-b2de-78d8588cd0f6"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("1b119065-e85f-413b-b4e3-ae3d17363617"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("1cef858b-5c87-4fdb-b997-752aa5dce2a2"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("1d582461-c165-457a-a834-57eb36fa6c92"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("247c1e4f-c5cf-47b3-afac-58e2c95de7ff"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("258d4c97-f2b6-4542-8cbc-1aa193cba708"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("25c28785-a085-44a2-9462-08824c040d32"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("268ca2d2-2fd5-43a1-bf68-293f6ce33f31"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("2828863c-f340-4631-ac60-151cc274f707"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("2cc778a8-1c37-4b11-a6a3-be4e4a759a61"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("305f6f57-7575-48f9-9b7a-69331d9f2f24"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("3236355d-8f3b-4745-9239-0059bccbceec"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("338f21eb-4808-40fb-ba0a-9f81d4773e87"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("3a38ebdb-7ef3-47a8-8501-ca361c3dcde8"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("3b41d3c9-3eb7-4ff8-b40b-e8edd3fe0795"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("3b79559c-d8ca-4c03-aeac-831fed4cc055"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("3faef830-ff98-486f-8db2-5b820a8f5712"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("4245db33-d186-4cbb-8f16-51bcfdfaa184"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("45941394-d096-49f1-b9c4-f80d37551999"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("4a682304-8272-4493-8225-97fb258f389c"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("4ae69a56-a4ff-4416-8fd6-7c44c993af2b"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("4d205fdc-5683-467c-a9b0-298549929804"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("4d2fff97-68a5-4ea6-9d4b-a0a0c3f689ec"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("51c84918-3a1c-48b7-9279-daf3efd0c336"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("52150feb-4bf2-4818-a0a3-2e85580c5d59"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("53300253-ddc0-4394-ada8-666d77bd080f"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("593eec4d-81d5-43b0-abf7-7577cb30495e"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("5c9b18b7-6f44-4c8d-9d2e-c491b6b38460"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("612b2d89-3067-4e4c-b801-777889ff6985"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("61e19d6f-4a69-4621-bda3-c47d7c2614bb"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("6303cba9-a76e-4d2b-82b7-057fcccb36c1"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("640f1940-7a07-4322-a99a-2285d5bf1c21"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("6479c299-b7f8-4023-98df-edb8c530fc34"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("648ebe68-0f73-4cb1-a8a5-668d5546c1aa"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("6499a01f-fc7d-4ed2-bf4b-08e089977909"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("65d90003-979d-49a3-98d8-2cd157dcda6b"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("66de7dcc-856b-4a58-8062-300dab4269c9"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("672487eb-15bd-469c-99af-ee16c5b94a85"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("67302c16-9d04-4e1a-a3ca-59686a8c9284"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("68c66403-7d68-4919-8bbf-0d39969ffd87"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("6b6e7865-95f8-4170-8c6f-e23e6b751b7f"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("6c7abc41-2099-4e6d-af1c-3fe563075404"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("6faed1cf-cced-4a68-b856-88c3e6ee3b82"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("6fe8fe67-80b5-44a2-a674-e54f8b30274c"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("700e3dda-3a9e-48cb-b57b-852929837818"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("7230b419-7743-4546-9f48-aa97486d60b7"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("73bd48b4-7884-4459-b658-338d0679cc01"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("759d2158-b840-4c4a-8ea2-3a404b38812e"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("760a5317-35ee-440d-81a5-745dc5995f45"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("7a3a8ee8-58f7-4c29-a924-e47adff5c4ff"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("7a70bed3-1d82-4e34-8c13-1ea95f016639"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("7d4ed052-bda2-4dfd-8b3e-13246bbafce0"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("7db92a1e-9a8f-43f9-931c-97bbcf24e355"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("829fa15f-e883-428b-8082-908c98380ac4"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("82c9b20f-5304-4d53-8818-39af4ca5381d"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("836f2785-cece-4489-8e31-a63a23a0f2bf"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("841f6c53-d0f6-40b5-ba56-5bd40aa0127c"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("89bac4c7-6879-4df3-a332-42887a2aa076"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("89d63328-9b59-4ddc-8485-41d33974bc81"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("8bbe50f3-9cf4-41ee-b46b-d2ec1fa3d5a9"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("8ce6f406-95f7-4744-a110-f9e52c3114dd"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("8d8d378a-40e0-4022-abe4-23462293fc96"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("8dc91a10-06d1-4abb-861f-6ada4089e98c"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("92470ca6-a55b-4662-b053-260ec99a1eee"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("93000f05-3afa-4c37-b0e7-2700efcd0612"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("93693c4c-dead-4395-8fac-cfd3c63404d3"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("93e98279-415c-41ec-afe4-6b6181bed3c4"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("9599adc6-61c9-41c8-915f-58d4c7f2e98c"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("962b2d27-e389-4513-9c12-1c3656cd8258"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("964ca8a8-7245-46af-ace8-e84d9079805f"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("97cbf9e4-d22f-4230-a607-32368fc95da2"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("99baa070-27ad-44fa-a302-fd1f4c5b1bec"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("9a087c46-edfc-4d14-b628-c16baa4b2f08"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("9c19afaa-803a-4fb5-b213-d9ac6803edfd"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("9e79c29e-6669-40b0-90e3-581de2e846aa"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("a57d1ec6-180b-480f-ba6b-245e18ecc019"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("a8c07a37-66b4-4ba5-aad4-3ee60605e52e"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("ad57fa94-050b-43a5-9105-8916ec3671aa"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("b5c02714-d709-46c5-b0f5-82cd40c8815b"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("b5f0b3a3-23c6-4e44-b551-65ee5e5e8102"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("b67a9def-f00c-4fd5-a934-b659c5f8ee03"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("b8047f8a-9ceb-4b55-927d-cffb9e5cada2"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("b8289abf-943d-4754-b535-0c8b30f656d1"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("b9ebfecf-4299-4530-9853-4cef81a8fc2d"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("ba39e5c2-b1fb-4e64-ad50-44a29f831416"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("bb2ab1f8-8740-4428-be85-e4d684d29a33"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("bb4d13f0-f69c-41c1-b346-9f564d7aabc8"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("bc3e74d0-8f36-486a-87fb-9e0d34d3c202"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("be837b05-891f-4304-9e6d-b48a87001494"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("c12bf98d-77b2-4835-a5c3-91fd3234755d"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("c20cac9f-b008-4dc2-9616-14d05833f3cf"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("c51d6453-2de8-4a38-acf5-b243884990c6"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("cb87c0f2-13cb-43ed-a245-18c576f7d711"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("cc9c982c-8fb7-4124-873d-b69ff3456a44"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("cd9f8074-fbe2-4902-b18d-abac2c15f864"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("cf7e4e6f-d46c-46ef-ab6c-e0d67d5e1eae"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("cfba9831-0f96-4985-940e-70a655d13876"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("d1f4ddd1-bf73-4722-a5ec-ebe11d12d727"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("d61387b3-02dc-446c-922a-621e2d4a0a57"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("d65b6ff4-8bdc-4aea-9b35-a3cfed9b1483"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("d6aacec0-acf1-492b-80d1-2ac45edd6c8c"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("da5b3fe3-6d72-4833-a9ce-a363c597fb97"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("ddbd2d96-4478-41d8-9d78-af6f3e688124"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("deec06df-c9ab-4ed1-af3e-0cb8463512ea"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("deef57ea-7770-4cb3-86e3-c0260936ca8e"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("df5e5c52-6799-4052-a306-3fc67347443a"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("e0a0fc8e-6ddf-42a8-b021-a6978664f794"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("e1046fdb-4f8d-4a50-9094-23e1dd369427"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("e233b2be-4d01-4783-a05d-176688c00d9c"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("e8716a6a-83b0-48b0-8bcd-4385f31f58c0"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("ec07ab88-57f7-4c6a-b366-3a5a52be055c"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("f3180f39-3869-4de2-8910-d53ced60ce24"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("f31b366f-d359-4e4e-ada6-e6e8f75ad737"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("f401ed99-0bf5-4135-90b9-8b67f201965d"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("f67b4346-02d3-4c74-b679-99b99c13994a"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("f8266773-61a1-4888-8682-03b9b7f210df"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("f8cc5d2c-be43-4870-badf-6c956fbdc4a0"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("fa6b67c0-2c7f-4db6-a7f4-43883471dfbe"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("fbde0d19-5a64-4716-8f2a-ebe60c2075a1"));

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: new Guid("fd13abe4-838f-46ec-b3c3-3348cde71487"));

            migrationBuilder.DeleteData(
                table: "Hotels",
                keyColumn: "Id",
                keyValue: new Guid("0a9fa4b3-a2d2-4455-b61c-c471adbc3bd3"));

            migrationBuilder.DeleteData(
                table: "Hotels",
                keyColumn: "Id",
                keyValue: new Guid("1b43177a-c518-4b2a-909a-ee4fc84c6820"));

            migrationBuilder.DeleteData(
                table: "Hotels",
                keyColumn: "Id",
                keyValue: new Guid("1ba6d3a7-beae-4745-b818-e62e150fbb0b"));

            migrationBuilder.DeleteData(
                table: "Hotels",
                keyColumn: "Id",
                keyValue: new Guid("23de6950-b9b6-426b-a892-503dc1942335"));

            migrationBuilder.DeleteData(
                table: "Hotels",
                keyColumn: "Id",
                keyValue: new Guid("2eb0d367-1fe6-4968-9d99-13cdf192b984"));

            migrationBuilder.DeleteData(
                table: "Hotels",
                keyColumn: "Id",
                keyValue: new Guid("3a4287d1-8df6-4cf9-92de-6dfe7f094035"));

            migrationBuilder.DeleteData(
                table: "Hotels",
                keyColumn: "Id",
                keyValue: new Guid("88e473f7-8048-465b-ad3b-9f711c6fba82"));

            migrationBuilder.DeleteData(
                table: "Hotels",
                keyColumn: "Id",
                keyValue: new Guid("a98f77b5-4572-485f-b355-7f565238eca9"));

            migrationBuilder.DeleteData(
                table: "Hotels",
                keyColumn: "Id",
                keyValue: new Guid("b05df49e-1f60-4128-888f-4f5836cc043b"));

            migrationBuilder.DeleteData(
                table: "Hotels",
                keyColumn: "Id",
                keyValue: new Guid("c26bc1bd-9264-4d53-9c04-9e9a7aca7d0f"));

            migrationBuilder.DeleteData(
                table: "Hotels",
                keyColumn: "Id",
                keyValue: new Guid("e7432cfd-41df-4b37-b641-c8dbf94328e1"));

            migrationBuilder.DeleteData(
                table: "Hotels",
                keyColumn: "Id",
                keyValue: new Guid("fbf4e4dc-c068-472c-8feb-d809384c3af8"));

            migrationBuilder.DropColumn(
                name: "City",
                table: "Hotels");

            migrationBuilder.DropColumn(
                name: "CountryId",
                table: "Hotels");

            migrationBuilder.DropColumn(
                name: "Latitude",
                table: "Hotels");

            migrationBuilder.DropColumn(
                name: "Longitude",
                table: "Hotels");

            migrationBuilder.UpdateData(
                table: "Countries",
                keyColumn: "Id",
                keyValue: new Guid("337b4bfa-8906-4035-a0ef-260ec8034469"),
                columns: new[] { "Code", "Name" },
                values: new object[] { "DE", "Germany" });

            migrationBuilder.UpdateData(
                table: "Countries",
                keyColumn: "Id",
                keyValue: new Guid("f42bec68-0475-4843-a16b-d4307acb80a3"),
                columns: new[] { "Code", "Name" },
                values: new object[] { "FR", "France" });
        }
    }
}
