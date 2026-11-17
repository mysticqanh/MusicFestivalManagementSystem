using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace MusicFestivalManagementSystem.Models
{
    // Lookup entry from the Product_Categories table. Shared by many vendors.
    public class ProductCategory
    {
        public ProductCategory(int categoryId, string categoryName)
        {
            CategoryID = categoryId;
            CategoryName = categoryName;
        }

        public int CategoryID { get; private set; }

        public string CategoryName { get; private set; }
    }
}

