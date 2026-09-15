//using ESCAPIA.Services.IServices;
//using Twilio;
//using Twilio.Rest.Api.V2010.Account;

//namespace ESCAPIA.Services
//{
                  //.........Future plans.........

//    public class TwilioService : ITwilioService
//    {
//        private readonly IConfiguration configuration;
//        public TwilioService(IConfiguration configuration)
//        {
//            this.configuration = configuration;
//        }
//        public async Task SendEmergencySmsAsync(string message, string phoneNumber)
//        {
//            var accountSid = configuration["Twilio:AccountSid"];
//            var authToken = configuration["Twilio:AuthToken"];
//            var fromPhone = configuration["Twilio:FromPhone"];

//            TwilioClient.Init(accountSid, authToken);
//            await MessageResource.CreateAsync(
//                body: message,
//                from: new Twilio.Types.PhoneNumber(fromPhone),
//                to: new Twilio.Types.PhoneNumber(phoneNumber)
//                );
//        }
//    }
//}
