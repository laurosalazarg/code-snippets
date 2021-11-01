using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Runtime.InteropServices;
using System.Security.Principal;
using System.Security.Permissions;
using Microsoft.Win32.SafeHandles;
using System.Runtime.ConstrainedExecution;
using System.Security;
// Add Simple Impersonation Library NuGet Package to References
using SimpleImpersonation;
using System.IO;
using System.Drawing;
using System.Drawing.Imaging;
using System.Diagnostics;


namespace PhotosExport_task
{
    class photoExport
    {

        static void Main(string[] args)
        {
            String connectionParams = @"user id=DOMAIN\dbphoto; password=pass; server=MSSQL; database=DATABASE;Integrated Security=true";
            // Use another user as windows login. Domain: DOMAIN User:dbphoto Password: LogonType for MSSQL
            string sSource = "[user] Export Photos";
            string sLog = "Application";
            string sEvent = @"Started exporting photos from MSSQL to c:\images\";

            if (!EventLog.SourceExists(sSource))
                EventLog.CreateEventSource(sSource, sLog);

            EventLog.WriteEntry(sSource, sEvent, EventLogEntryType.Information, 50101);

            using (Impersonation.LogonUser("DOMAIN", "dbphoto", "pass", LogonType.NewCredentials))
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(connectionParams))
                    {
                        conn.Open();
                        System.Console.WriteLine(@"Logged in. Exporting photos from MSSQL to C:\images\");
                        // export query
                        String query = "SELECT TID, TPHOTO FROM TABLEDB WHERE IDWPhoto <> '' and TID <> '12345' and TID <> '123456' and TPHOTO is not null";
                        SqlDataReader rdr;
                        String idNumConverted;

                            using (SqlCommand cmd = new SqlCommand(query, conn))
                            {
                                cmd.CommandType = System.Data.CommandType.Text;
                                rdr = cmd.ExecuteReader();
                                // if result is not null
                                if (rdr.HasRows)
                                {
                                    while (rdr.Read())
                                    {
                                        byte[] data = (byte[])rdr["TPHOTO"];
                                        // save to folder
                                        idNumConverted = string.Format("{0:0000000}", rdr["TID"]);
                                        using (Image image = Image.FromStream(new MemoryStream(data)))
                                        {
                                             // removes Properties->Comments from image
                                            image.Save(@"C:\images\" + idNumConverted + ".jpg", ImageFormat.Jpeg);
                                           
                                        }

                                    }

                                }
                                else
                                {
                                    System.Console.WriteLine("Error. Contact user@domain.com.");
                                    sEvent = "Error. Contact user@domain.com.";

                                    if (!EventLog.SourceExists(sSource))
                                        EventLog.CreateEventSource(sSource, sLog);

                                    EventLog.WriteEntry(sSource, sEvent, EventLogEntryType.Error, 50102);
                                }
                                rdr.Dispose();
                                cmd.Dispose();

                            }
                            conn.Close();
                       
                            System.Console.WriteLine("Connection closed. Finished exporting!");
                            sEvent = "Connection closed. Finished exporting!";

                            if (!EventLog.SourceExists(sSource))
                                EventLog.CreateEventSource(sSource, sLog);

                            EventLog.WriteEntry(sSource, sEvent, EventLogEntryType.Information, 50103);
                        }

                    }

                catch (Exception ex)
                {
                    System.Console.WriteLine("Error" + ex.ToString());
                    sEvent = "Error" + ex.ToString();

                    if (!EventLog.SourceExists(sSource))
                        EventLog.CreateEventSource(sSource, sLog);

                    EventLog.WriteEntry(sSource, sEvent, EventLogEntryType.Error, 50104);

                }

                   



            }
        }

      


    }
}
