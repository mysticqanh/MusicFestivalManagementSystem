using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MySqlConnector;

namespace MusicFestivalManagementSystem
{
    internal class Program
    {
        static void Main(string[] args)
        {
            string connectionString =
                "Server=127.0.0.1;" +
                "Port=3306;" +
                "Database=MFMS;" +
                "User ID=root;" +
                "Password=;";

            try
            {
                using (var connection = new MySqlConnection(connectionString))
                {
                    connection.Open();

                    Console.WriteLine( "Database connection SUCCESS!");

                    string sql ="SELECT COUNT(*) FROM Persons;";

                    using (var command = new MySqlCommand(sql, connection))
                    {
                        int count = Convert.ToInt32(command.ExecuteScalar());

                        Console.WriteLine("Total participants: " + count);
                    }
                }
            }
            catch (MySqlException ex)
            {
                Console.WriteLine("Database connection FAILED!");

                Console.WriteLine("Error: " + ex.Message);
            }
        
    }

    }
}