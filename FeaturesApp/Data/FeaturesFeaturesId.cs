//namespace FeaturesApp.Data.Features; // Razor won't recognize third level namespace
namespace FeaturesApp.Features;

public class FeaturesIdType
{
    public double? FeatureId { get; set; }
    public double? ProductId { get; set; }
    public string? Title { get; set; }
    public string? Description { get; set; }
    public string? RequestorEmail { get; set; }
    public string? DateAdded { get; set; }
    public string? Product { get; set; }
}
