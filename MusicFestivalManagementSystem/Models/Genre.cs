using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace MusicFestivalManagementSystem.Models
{
    // Lookup entry from the Genres table. Shared by many performers.
    public class Genre
    {
        public Genre(int genreId, string genreName)
        {
            GenreID = genreId;
            GenreName = genreName;
        }

        public int GenreID { get; private set; }

        public string GenreName { get; private set; }
    }
}

