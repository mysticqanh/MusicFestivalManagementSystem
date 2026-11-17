using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicFestivalManagementSystem.Models
{
    // Raw values typed by the user. It carries input from the View to the Service; it is not a domain object.
    public class PersonInputDto
    {
        public PersonInputDto()
        {
            Name = string.Empty;
            Telephone = string.Empty;
            Email = string.Empty;
            Role = ParticipantRole.Performer;
            GenreIds = new List<int>();
            EmploymentType = EmploymentType.FullTime;
            VendorName = string.Empty;
            CategoryIds = new List<int>();
        }

        // Common fields
        public string Name { get; set; }

        public string Telephone { get; set; }

        public string Email { get; set; }

        public ParticipantRole Role { get; set; }

        // Performer fields
        public decimal Fee { get; set; }

        public List<int> GenreIds { get; set; }

        // Crew fields
        public decimal HourlyRate { get; set; }

        public EmploymentType EmploymentType { get; set; }

        public int WeeklyHours { get; set; }

        // Vendor fields
        public string VendorName { get; set; }

        public List<int> CategoryIds { get; set; }
    }
}
