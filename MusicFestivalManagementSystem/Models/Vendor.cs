using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace MusicFestivalManagementSystem.Models
{
    // Vendor subtype. Stored in the Vendors table, with categories in the Vendor_Product_Category link table.
    public class Vendor : Person
    {
        public Vendor(int personId, string name, string telephone, string email)
            : base(personId, name, telephone, email, ParticipantRole.Vendor)
        {
            VendorName = string.Empty;
            ProductCategories = new List<ProductCategory>();
        }

        public string VendorName { get; set; }

        // Must contain exactly 3 distinct product categories (checked by ParticipantValidator).
        public List<ProductCategory> ProductCategories { get; set; }

        public override ParticipantRole GetRole()
        {
            return ParticipantRole.Vendor;
        }

        public override string GetRoleSummary()
        {
            List<string> categoryNames = new List<string>();
            foreach (ProductCategory category in ProductCategories)
            {
                categoryNames.Add(category.CategoryName);
            }

            return base.GetRoleSummary()
                + ", Vendor name: " + VendorName
                + ", Categories: " + string.Join(", ", categoryNames);
        }
    }
}

