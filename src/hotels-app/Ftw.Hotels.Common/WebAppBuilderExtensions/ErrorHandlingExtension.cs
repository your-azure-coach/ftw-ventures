using HotChocolate.AspNetCore.Serialization;
using HotChocolate.Execution;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace Ftw.Hotels.Common.WebAppBuilderExtensions
{
    public class ErrorHandlingExtension : DefaultHttpResponseFormatter
    {
        protected override HttpStatusCode OnDetermineStatusCode(
        IQueryResult result, FormatInfo format,
        HttpStatusCode? proposedStatusCode)
        {
            if (proposedStatusCode == HttpStatusCode.InternalServerError)
            {
                return HttpStatusCode.OK;
            }

            return base.OnDetermineStatusCode(result, format, proposedStatusCode);
        }
    }
}
