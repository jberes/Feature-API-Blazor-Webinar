using System;
using System.Collections.Generic;

namespace FeaturesApi.Models
{
    public partial class VwFeatureProduct
    {
        public int FeatureId { get; set; }
        public int ProductId { get; set; }
        public string Title { get; set; } = null!;
        public string? Description { get; set; }
        public string RequestorEmail { get; set; } = null!;
        public DateTime DateAdded { get; set; }
        public string Product { get; set; } = null!;
    }
}
