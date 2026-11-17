using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicFestivalManagementSystem.Models
{
    public enum ParticipantRole
       //Role of a participant.The names match the Role column in the Persons table.
    {
        Performer,
        Crew, 
        Vendor
    }
}
