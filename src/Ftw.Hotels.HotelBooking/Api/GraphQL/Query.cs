using System;
using Ftw.Hotels.HotelBooking.Api.Types;

namespace Ftw.Hotels.HotelBooking.Api.GraphQL
{
    public class Query
    {
        private static Random _random = new Random();

        public IEnumerable<RoomAvailabilityType> GetRoomAvailability(Guid roomId, int numberOfDays = 7)
        { 
            var roomAvailability = new List<RoomAvailabilityType>();
            for (int i = 0; i < numberOfDays; i++)
            {
                roomAvailability.Add(new RoomAvailabilityType()
                {
                    Day = DateOnly.FromDateTime(DateTime.Now.AddDays(i)),
                    IsAvailable = Convert.ToBoolean(_random.Next(2))
                });
            }
            return roomAvailability;
        }
    }
}
