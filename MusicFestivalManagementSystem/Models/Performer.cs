using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace MusicFestivalManagementSystem.Models
{
    // Performer subtype. Stored in the Performers table, with genres in the Performer_Genres link table.
    public class Performer : Person
    {
        public Performer(int personId, string name, string telephone, string email): base(personId, name, telephone, email, ParticipantRole.Performer)
        {
            Fee = 0;
            Genres = new List<Genre>();
        }


        public decimal Fee { get; set; }

        // Must contain exactly 2 distinct genres (checked by ParticipantValidator).
        public List<Genre> Genres { get; set; }

        public override ParticipantRole GetRole()
        {
            return ParticipantRole.Performer;
        }

        public override string GetRoleSummary()
        {
            List<string> genreNames = new List<string>();
            foreach (Genre genre in Genres)
            {
                genreNames.Add(genre.GenreName);
            }

            return base.GetRoleSummary()
                + ", Fee: " + Fee.ToString("0.00")
                + ", Genres: " + string.Join(", ", genreNames);
        }
    }
}

