using System.Net.Http.Json;

namespace FeaturesApp.Features
{
    public class FeaturesService
    {
        private readonly HttpClient http;

        public FeaturesService(HttpClient http)
        {
            this.http = http;
        }

        public async Task<FeaturesType[]?> GetFeatures()
        {
            return await this.http.GetFromJsonAsync<FeaturesType[]>("https://localhost:7229/features");
        }

        public async Task<FeaturesIdType[]?> GetFeaturesId(double featuresIdId)
        {
            // var featuresIdId = "5";

            return await this.http.GetFromJsonAsync<FeaturesIdType[]>($"https://localhost:7229/features/{featuresIdId}");
        }
    }
}