using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace MusicFestivalManagementSystem.Models
{
    // Crew subtype. Stored in the Crew table.
    public class Crew : Person
    {
        public Crew(int personId, string name, string telephone, string email): base(personId, name, telephone, email, ParticipantRole.Crew)
        {
            HourlyRate = 0;
            EmploymentType = EmploymentType.FullTime;
            WeeklyHours = 0;
        }

        public decimal HourlyRate { get; set; }

        public EmploymentType EmploymentType { get; set; }

        // FullTime: 25 to 40 hours. PartTime: 1 to 24 hours (checked by ParticipantValidator).
        public int WeeklyHours { get; set; }

        public override ParticipantRole GetRole()
        {
            return ParticipantRole.Crew;
        }

        public override string GetRoleSummary()
        {
            return base.GetRoleSummary()
                + ", Hourly rate: " + HourlyRate.ToString("0.00")
                + ", Employment: " + EmploymentType
                + ", Weekly hours: " + WeeklyHours;
        }
    }
}

