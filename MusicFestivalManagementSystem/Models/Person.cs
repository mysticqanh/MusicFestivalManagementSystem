using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace MusicFestivalManagementSystem.Models
{
    // Base class for every participant. Shared data is stored in the Persons table.
    public abstract class Person
    {
        protected Person(int personId, string name, string telephone, string email, ParticipantRole role)
        {
            PersonID = personId;
            Name = name;
            Telephone = telephone;
            Email = email;
            Role = role;
        }

        // Read-only: the ID is set once and never changes, even when the role changes.
        public int PersonID { get; private set; }

        public string Name { get; set; }

        public string Telephone { get; set; }

        public string Email { get; set; }

        public ParticipantRole Role { get; private set; }

        // Each subclass returns its own role value (polymorphism).
        public abstract ParticipantRole GetRole();

        // Returns a short text description of the participant.
        public virtual string GetRoleSummary()
        {
            return "ID: " + PersonID + ", Name: " + Name + ", Role: " + Role;
        }
    }
}

