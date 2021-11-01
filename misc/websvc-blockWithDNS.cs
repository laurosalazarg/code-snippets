using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;

using MySql.Data.MySqlClient;
using System.Data;

using System.Management;
using System.Net.Mail;
using System.DirectoryServices;
using System.DirectoryServices.AccountManagement;
using System.Security.Cryptography.X509Certificates;

using System.Text.RegularExpressions;
using System.Diagnostics;

using System.Threading.Tasks;
namespace DATABASEWService
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "Service1" in code, svc and config file together.
    public class Service1 : dnbService
    {
        internal ManagementScope scope;
        String connectionParams = "SERVER='1.2.3.4'; DATABASE='DATABASE'; USERID='dnbuser'; PASSWORD='pass';";
        bool userAuth;

        public Service1()
        {
            // WMI Connection
            scope = new ManagementScope("\\\\SERVER\\root\\MicrosoftDNS");
            scope.Connect();
          

        }

        public DataTable getBlockedZones()
        {
            //// Return Zones from AD
            //List<string> blockedZones = new List<string>();
            //// Display Forward Zones
            //ObjectQuery query = new ObjectQuery("SELECT * FROM MicrosoftDNS_Zone WHERE Reverse='False'");
            //ManagementObjectSearcher searcher = new ManagementObjectSearcher(scope, query);
            //ManagementObjectCollection queryCollection = searcher.Get();
            //foreach (ManagementObject m in queryCollection)
            //{
            //    blockedZones.Add(m["ContainerName"].ToString());
            //}

            // Return Zones from MySQL
            //List<string> blockedZones = new List<string>();

            try
            {
                DataSet DS = new DataSet();
                String MySQLquery = "SELECT * FROM blocked where blockedOn is not NULL";   //   orig is not
                using (MySqlConnection mySQLconn = new MySqlConnection(connectionParams))
                {
                    mySQLconn.Open();
                    using (MySqlDataAdapter adapter = new MySqlDataAdapter(MySQLquery, mySQLconn))
                    {

                        adapter.Fill(DS);

                    }

                }

                return DS.Tables[0];
            }
            catch (MySqlException ex)
            {
                string sSource = "[DATABASE WebService] Operations.getBlockedZones";
                string sLog = "Application";
                string sEvent = "Failed to retrive blocked zones \n" + ex.ToString();

                if (!EventLog.SourceExists(sSource))
                    EventLog.CreateEventSource(sSource, sLog);

                //EventLog.WriteEntry(sSource,sEvent);
                EventLog.WriteEntry(sSource, sEvent, EventLogEntryType.Error, 038);
                return null;
            }
           
        }

        public bool validEmail(string user)
        {
            bool varEmail;

            try
            {
                user = new MailAddress(user).Address;
                varEmail = true;

            }
            catch (FormatException)
            {
                varEmail = false;
            }


            if (varEmail == true)
            {
                return true;
            }
            else
            {
                string sSource = "[DATABASE WebService] UserLogIn.validEmail";
                string sLog = "Application";
                string sEvent = "" + user + " is not a valid email";

                if (!EventLog.SourceExists(sSource))
                    EventLog.CreateEventSource(sSource, sLog);

                //EventLog.WriteEntry(sSource,sEvent);
                EventLog.WriteEntry(sSource, sEvent, EventLogEntryType.Warning, 50201);

                return false;
            }


        }
        public int getRole(string user)
        {
            int role = 0;
            try
            {

                String MySQLquery = "SELECT role FROM authorized where user = @UserName";
                using (MySqlConnection mySQLconn = new MySqlConnection(connectionParams))
                {

                    mySQLconn.Open();
                    using (MySqlCommand cmd = new MySqlCommand(MySQLquery, mySQLconn))
                    {
                        cmd.Parameters.AddWithValue("@UserName", user);
                        using (MySqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                role = (int)reader["role"];

                            }

                        }


                    }
                }


            }
            catch
            {

                string sSource = "[DATABASE WebService] UserLogIn.getRole";
                string sLog = "Application";
                string sEvent = "Failed to retrive " + user + " role";

                if (!EventLog.SourceExists(sSource))
                    EventLog.CreateEventSource(sSource, sLog);

                //EventLog.WriteEntry(sSource,sEvent);
                EventLog.WriteEntry(sSource, sEvent, EventLogEntryType.Error, 50301);
                return 0;
            }


            
            return role;
        }
        public bool authentication(string user, string password)
        {

            bool varEmail;
            // validate user email sign in
            varEmail = validEmail(user);

            if (varEmail == true)
            {
                try
                {

                    // check if authorized
                    String MySQLquery = "SELECT * FROM authorized where user = @UserName";// +user + "'";
                    using (MySqlConnection mySQLconn = new MySqlConnection(connectionParams))
                    {
                        mySQLconn.Open();
                        using (MySqlCommand cmd = new MySqlCommand(MySQLquery, mySQLconn))
                        {

                            cmd.Parameters.AddWithValue("@UserName", user);
                            using (MySqlDataReader reader = cmd.ExecuteReader())
                            {
                                //MySqlDataReader reader;
                                // String userFromMySQL; int role;
                                //reader = cmd.ExecuteReader();

                                while (reader.Read())
                                {
                                    //blockedZones.Add(reader["domainName"].ToString() + " | " + reader["blockedOn"].ToString()
                                    //           + " | " + reader["reason"].ToString() + " | " + reader["user"].ToString());
                                    if (reader["user"].ToString() == user)
                                    {
                                        userAuth = true;

                                    }
                                    else
                                    {
                                        string sSource = "[DATABASE WebService] UserLogIn.authorized";
                                        string sLog = "Application";
                                        string sEvent = "User " + user + " not authorized to login";

                                        if (!EventLog.SourceExists(sSource))
                                            EventLog.CreateEventSource(sSource, sLog);

                                        //EventLog.WriteEntry(sSource,sEvent);
                                        EventLog.WriteEntry(sSource, sEvent, EventLogEntryType.Warning, 50101);

                                        userAuth = false;
                                    }

                                }
                            }
                        }
                    }


                    //

                    if (userAuth == true)
                    {

                        DirectoryEntry rootEntry = new DirectoryEntry("LDAP://SERVER.domain.com:636/dc=domain2,dc=pvt", "ldapbind2", "pass", AuthenticationTypes.SecureSocketsLayer);
                        DirectorySearcher srch = new DirectorySearcher(rootEntry);
                        srch.SearchScope = SearchScope.Subtree;
                        // search for userPrincipalName (email) belonging to group
                        String memberOfGroup = "DATABASEGroup"; String OUgroup = "WebServicesAdmins";
                        srch.Filter = "(&(objectClass=user)(userPrincipalName=" + user + ")(memberOf=cn=" + memberOfGroup + ",OU=" + OUgroup + ",OU=Groups,dc=domain2,dc=pvt))";
                        SearchResult res = srch.FindOne();
                        if (res == null)
                        {
                            // did not find any results, user not in group
                            string sSource = "[DATABASE WebService] UserLogIn.auth";
                            string sLog = "Application";
                            string sEvent = "User " + user + " not found in AD DATABASEGroup";

                            if (!EventLog.SourceExists(sSource))
                                EventLog.CreateEventSource(sSource, sLog);

                            //EventLog.WriteEntry(sSource,sEvent);
                            EventLog.WriteEntry(sSource, sEvent, EventLogEntryType.Warning, 50401);
                            return false;

                        }
                        else
                        {
                            // Proceed to authenticate user with passwd
                            PrincipalContext adContext = new PrincipalContext(ContextType.Domain);
                            bool authWithAD;
                            using (adContext)
                            {

                                //return adContext.ValidateCredentials(user, password);
                                authWithAD = adContext.ValidateCredentials(user, password);
                            }


                            if (authWithAD == true)
                            {
                                string sSource = "[DATABASE WebService] UserLogIn.ADcredential";
                                string sLog = "Application";
                                string sEvent = "User " + user + " successfully logged in.";

                                if (!EventLog.SourceExists(sSource))
                                    EventLog.CreateEventSource(sSource, sLog);

                                //EventLog.WriteEntry(sSource,sEvent);
                                EventLog.WriteEntry(sSource, sEvent, EventLogEntryType.Information, 50501);
                                return true;
                            }
                            else
                            {
                                string sSource = "[DATABASE WebService] UserLogIn.ADcredential";
                                string sLog = "Application";
                                string sEvent = "User " + user + " entered wrong password";

                                if (!EventLog.SourceExists(sSource))
                                    EventLog.CreateEventSource(sSource, sLog);

                                //EventLog.WriteEntry(sSource,sEvent);
                                EventLog.WriteEntry(sSource, sEvent, EventLogEntryType.Warning, 50502);
                                return false;
                            }


                        }

                    }
                    else
                    {


                        string sSource = "[DATABASE WebService] UserLogIn.auth";
                        string sLog = "Application";
                        string sEvent = "User " + user + " not authorized";

                        if (!EventLog.SourceExists(sSource))
                            EventLog.CreateEventSource(sSource, sLog);

                        //EventLog.WriteEntry(sSource,sEvent);
                        EventLog.WriteEntry(sSource, sEvent, EventLogEntryType.Warning, 50402);


                        return false;
                    }


                }
                catch
                {

                    string sSource = "[DATABASE WebService] UserLogIn.auth";
                    string sLog = "Application";
                    string sEvent = "User " + user + " failed to login\nVerify that MySQL is working correctly and there is a connection to AD";

                    if (!EventLog.SourceExists(sSource))
                        EventLog.CreateEventSource(sSource, sLog);

                    //EventLog.WriteEntry(sSource,sEvent);
                    EventLog.WriteEntry(sSource, sEvent, EventLogEntryType.Error, 50403);
                    return false;
                }
            }
            else
            {
   
                return false;
            }




        }
        public void sendPendingNotificationEmail(string urlToBlock, string user, string reason)
        {
            // Send an email notifying of block
            SmtpClient smtp = new SmtpClient("smtp.office365.com", 587);
            MailMessage emailMessage = new MailMessage();
            smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
            smtp.UseDefaultCredentials = true;
            smtp.Credentials = new System.Net.NetworkCredential("mail@domain.com", "pass");
            smtp.EnableSsl = true;
            emailMessage.From = new MailAddress("mail@domain.com", "USER");
            emailMessage.To.Add(new MailAddress("monitor@domain.com"));
            emailMessage.CC.Add(new MailAddress(user));
            emailMessage.Subject = "[ DATABASE ]: " + user + " Requests to block " + urlToBlock;
            emailMessage.Body = "The host [ " + urlToBlock + " ] has been found offensive and is being requested to be blocked by [ "
                + user + " ] \nReason:  " + reason + " \n\nIf you are an administrator follow this link and sign in with your domain credentials to approve or deny the request: https://DATABASE/ \n\nDATABASE WebService\nCloud and Computing Platforms\nmail@domain.com";

            new Task(delegate { smtp.Send(emailMessage); 
            smtp.Dispose();
            emailMessage.Dispose();
            
            }).Start();
        }
        public void sendDeniedEmail(string urlToBlock, string user)
        {
            // Send an email informing of denied request
            SmtpClient smtp = new SmtpClient("smtp.office365.com", 587);
            MailMessage emailMessage = new MailMessage();
            smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
            smtp.UseDefaultCredentials = true;
            smtp.Credentials = new System.Net.NetworkCredential("mail@domain.com", "pass");
            smtp.EnableSsl = true;
            emailMessage.From = new MailAddress("mail@domain.com", "USER");
            emailMessage.To.Add(new MailAddress("monitor@domain.com"));
            emailMessage.CC.Add(new MailAddress(user));
            emailMessage.Subject = "[ DATABASE ]: " + user + " Denied request to block " + urlToBlock;
            emailMessage.Body = " https://DATABASE/ \n\nDATABASE WebService\nCloud and Computing Platforms\nmail@domain.com";

            new Task(delegate
            {
                smtp.Send(emailMessage);
                smtp.Dispose();
                emailMessage.Dispose();

            }).Start();



        }
        public void sendBlockedNotification(string urlToBlock, string user, string reason)
        {
            SmtpClient smtp = new SmtpClient("smtp.office365.com", 587);
            MailMessage emailMessage = new MailMessage();
            smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
            smtp.UseDefaultCredentials = true;
            smtp.Credentials = new System.Net.NetworkCredential("mail@domain.com", "pass");
            smtp.EnableSsl = true;
            emailMessage.From = new MailAddress("mail@domain.com", "USER");
            emailMessage.To.Add(new MailAddress("monitor@domain.com"));
            emailMessage.CC.Add(new MailAddress(user));
            emailMessage.Subject = "[ DATABASE ]: " + user + " Approved blocking " + urlToBlock;
            emailMessage.Body = "The host [ " + urlToBlock + " ] has been found offensive and has been approved to be blocked by [ "
                + user + " ] \nReason:  " + reason + "  \n\nDATABASE WebService\nCloud and Computing Platforms\nmail@domain.com";

            new Task(delegate
            {
                smtp.Send(emailMessage);
                smtp.Dispose();
                emailMessage.Dispose();
            }).Start();


        }
        public DataTable getHistory()
        {
            try
            {
                DataSet DS = new DataSet();
                String query = "SELECT * FROM subHistory";
                using (MySqlConnection mySQLconn = new MySqlConnection(connectionParams))
                {
                    mySQLconn.Open();
                    using (MySqlDataAdapter adapter = new MySqlDataAdapter(query, mySQLconn))
                    {
                        adapter.Fill(DS);
                    }
                }
                return DS.Tables[0];
            }
            catch (MySqlException ex)
            {
                string sSource = "[DATABASE WebService] Operations.getHistory";
                string sLog = "Application";
                string sEvent = "Failed to retrive all history from table subhistory\n" + ex.ToString();

                if (!EventLog.SourceExists(sSource))
                    EventLog.CreateEventSource(sSource, sLog);

                //EventLog.WriteEntry(sSource,sEvent);
                EventLog.WriteEntry(sSource, sEvent, EventLogEntryType.Error, 50601);

                return null;

            }




        }
        public DataTable getPendingZones()
        {
            //List<string> pendingZones = new List<string>();
            try
            {
                DataSet DS = new DataSet();
                String query = "SELECT * FROM subHistory where approval is NULL";
                using (MySqlConnection mySQLconn = new MySqlConnection(connectionParams))
                {
                    mySQLconn.Open();
                    using (MySqlDataAdapter adapter = new MySqlDataAdapter(query, mySQLconn))
                    {
                        adapter.Fill(DS);
                    }
                }
                return DS.Tables[0];
            }
            catch (MySqlException ex)
            {
                string sSource = "[DATABASE WebService] Operations.getPendingZones";
                string sLog = "Application";
                string sEvent = "Failed to retrieve pending zones from table subhistory\n" + ex.ToString();

                if (!EventLog.SourceExists(sSource))
                    EventLog.CreateEventSource(sSource, sLog);

                //EventLog.WriteEntry(sSource,sEvent);
                EventLog.WriteEntry(sSource, sEvent, EventLogEntryType.Error, 50701);
             
                return null;

            }


        }
        // clicking the submit request to block button
        public bool execPendingBlock(string urlToBlock, string reason, string user, string action)
        {

            String checker="";
            if (Regex.IsMatch(urlToBlock, "domain", RegexOptions.IgnoreCase) || Regex.IsMatch(urlToBlock, "domain2", RegexOptions.IgnoreCase)
               || Regex.IsMatch(urlToBlock, @"\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b", RegexOptions.IgnoreCase) 
               || Regex.IsMatch(urlToBlock, "google", RegexOptions.IgnoreCase)
               || Regex.IsMatch(urlToBlock, "yahoo", RegexOptions.IgnoreCase)
               || Regex.IsMatch(urlToBlock, "dell", RegexOptions.IgnoreCase)
               || Regex.IsMatch(urlToBlock, "hotmail", RegexOptions.IgnoreCase))
            {
                return false;
            }
            else
            {
                
                // find another record before submitting
                using (MySqlConnection mySQLconn = new MySqlConnection(connectionParams))
                {
                    mySQLconn.Open();
                    // count rows in history table
                    String countQuery = "SELECT domainName from subhistory where domainName=@DNSub";
                    using (MySqlCommand cmd = new MySqlCommand(countQuery, mySQLconn))
                    {

                        cmd.Parameters.AddWithValue("@DNSub", urlToBlock);
                        cmd.ExecuteNonQuery();
                        using (MySqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                checker = reader["DomainName"].ToString();
                            }
                        }
                    }

                }
                //
                if (checker.Equals(urlToBlock))
                {
                    return false;
                }
                else
                {


                    try
                    {
                        int numRows = 0;
                        using (MySqlConnection mySQLconn = new MySqlConnection(connectionParams))
                        {
                            mySQLconn.Open();
                            // count rows in history table
                            String countQuery = "SELECT count(*) AS TotalCount from subHistory";

                            using (MySqlCommand cmd = new MySqlCommand(countQuery, mySQLconn))
                            {

                                cmd.ExecuteNonQuery();


                                using (MySqlDataReader reader = cmd.ExecuteReader())
                                {
                                    while (reader.Read())
                                    {
                                        numRows = int.Parse(reader["TotalCount"].ToString());
                                    }
                                }



                            }

                        }
                        // mySQLconn2.Close();
                        numRows++;
                        //  reader.Close();
                        // reader.Dispose();

                        //Add to MySQL database
                        DateTime TimeNow = DateTime.Now;
                        string dateFormat = "yyyy-MM-dd HH:mm:ss"; // MySQL style date 2014-02-24 15:33:56
                        String query2 = "INSERT INTO subHistory(idVal, domainName, submittedOn, reason, user, action) VALUES (@p_IDnum, @p_DN, @p_DateBlocked, @p_ReasonBlock, @p_UserName, @p_AC)";
                        // VALUES('URLTOBLOCK','TIMENOW','REASON','USER')

                        //  MySqlConnection mySQLconn3 = new MySqlConnection(connectionParams);
                        // mySQLconn3.Open();
                        using (MySqlConnection mySQLconn = new MySqlConnection(connectionParams))
                        {
                            mySQLconn.Open();
                            using (MySqlCommand cmdSubmit2 = new MySqlCommand(query2, mySQLconn))
                            {
                                cmdSubmit2.Parameters.AddWithValue("@p_IDnum", numRows);
                                cmdSubmit2.Parameters.AddWithValue("@p_DN", urlToBlock);
                                cmdSubmit2.Parameters.AddWithValue("@p_DateBlocked", TimeNow.ToString(dateFormat));
                                cmdSubmit2.Parameters.AddWithValue("@p_ReasonBlock", reason);
                                cmdSubmit2.Parameters.AddWithValue("@p_UserName", user);
                                cmdSubmit2.Parameters.AddWithValue("@p_AC", action);
                                cmdSubmit2.ExecuteNonQuery();
                            }

                        }
                        // if successfully executed
                        return true;
                    }

                    catch (MySqlException ex)
                    {
                        string sSource = "[DATABASE WebService] Operations.execPendingBlock";
                        string sLog = "Application";
                        string sEvent = "Failed to insert into table subhistory \n" + ex.ToString();

                        if (!EventLog.SourceExists(sSource))
                            EventLog.CreateEventSource(sSource, sLog);

                        EventLog.WriteEntry(sSource, sEvent, EventLogEntryType.Error, 50801);
                        return false;
                    }
                }


            }

        }
        public bool updateApproval(int idVal, string user, string approvalValue)
        {
            try
            {
                String query = "UPDATE subHistory set approval=@ApprovalParam,approvalBy=@UserParam WHERE idVal=@idValParam";
                using (MySqlConnection mySQLconn = new MySqlConnection(connectionParams))
                {
                    mySQLconn.Open();
                    using (MySqlCommand cmdSubmit = new MySqlCommand(query, mySQLconn))
                    {
                        // update the subHistory table to deny the block
                        cmdSubmit.Parameters.AddWithValue("@ApprovalParam", approvalValue);
                        cmdSubmit.Parameters.AddWithValue("@idValParam", idVal);
                        cmdSubmit.Parameters.AddWithValue("@UserParam", user);
                        cmdSubmit.ExecuteNonQuery();

                    }

                }
                return true;
            }
            catch (MySqlException ex)
            {
                //System.Console.WriteLine("Error from service");
                string sSource = "[DATABASE WebService] Operations.updateApproval";
                string sLog = "Application";
                string sEvent = "Failed to update table subhistory \n" + ex.ToString();

                if (!EventLog.SourceExists(sSource))
                    EventLog.CreateEventSource(sSource, sLog);

                //EventLog.WriteEntry(sSource,sEvent);
                EventLog.WriteEntry(sSource, sEvent, EventLogEntryType.Error, 50901);
                return false;

            }
        }


        public bool execBlockZone(string urlToBlock, string reason, string user)
        {
            String redirectIP = "1.2.3.4"; //   No Browse page

            // return false if domain, domain2, or any ip is tried to ban
            if (Regex.IsMatch(urlToBlock, "domain", RegexOptions.IgnoreCase) || Regex.IsMatch(urlToBlock, "domain2", RegexOptions.IgnoreCase)
                || Regex.IsMatch(urlToBlock, @"\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b", RegexOptions.IgnoreCase))
            {
                return false;
            }
            else
            {
                // WMI 
                ManagementObject mc = new ManagementClass(scope, new ManagementPath("MicrosoftDNS_Zone"), null);
                ManagementObject mc2 = new ManagementClass(scope, new ManagementPath("MicrosoftDNS_AType"), null);
               
                ManagementBaseObject parameters = mc.GetMethodParameters("CreateZone");
                ManagementBaseObject parameters2 = mc2.GetMethodParameters("CreateInstanceFromPropertyData");
               
                ManagementBaseObject outParam = null;
                ManagementBaseObject outParam2 = null;
          
                //Forward Lookup Zone
                parameters["ZoneName"] = urlToBlock;
                parameters["ZoneType"] = 0;  // Primary Zone, 
                parameters["DsIntegrated"] = true; //Active Directory Integrated
                parameters["DataFileName"] = null;
                parameters["IpAddr"] = null;
                parameters["AdminEmailName"] = null;
                // Resource Record
                parameters2["IPAddress"] = redirectIP;
                parameters2["DnsServerName"] = "SERVER";
                parameters2["OwnerName"] = urlToBlock;
                parameters2["ContainerName"] = urlToBlock;
                // Start of Authority
                
                try
                {
                    // Perform the operation
                    outParam = mc.InvokeMethod("CreateZone", parameters, null);
                    outParam2 = mc2.InvokeMethod("CreateInstanceFromPropertyData", parameters2, null);
                    


                        //Add to MySQL database
                        DateTime TimeNow = DateTime.Now;
                        string dateFormat = "yyyy-MM-dd HH:mm:ss"; // MySQL style date 2014-02-24 15:33:56
                        // String query = "INSERT INTO blocked(domainName, blockedOn, reason, user) VALUES(" + "'" + urlToBlock + "'," + "'" +
                        //    TimeNow.ToString(dateFormat) + "'," + "'" + reason + "'," + "'" + user + "'" + ")";

                        String query = "INSERT INTO blocked(domainName, blockedOn, reason, user) VALUES (@DN, @Date,@ReasonBlock, @UserName)";
                        // VALUES('URLTOBLOCK','TIMENOW','REASON','USER')


                        // open mysql connection, insert blocked into database
                        using (MySqlConnection mySQLconn = new MySqlConnection(connectionParams))
                        {
                            mySQLconn.Open();
                            using (MySqlCommand cmdSubmit = new MySqlCommand(query, mySQLconn))
                            {
                                cmdSubmit.Parameters.AddWithValue("@DN", urlToBlock);
                                cmdSubmit.Parameters.AddWithValue("@Date", TimeNow.ToString(dateFormat));
                                cmdSubmit.Parameters.AddWithValue("@ReasonBlock", reason);
                                cmdSubmit.Parameters.AddWithValue("@UserName", user);
                                cmdSubmit.ExecuteNonQuery();
                            }
                        }

                        // Send an email notifying of block
                        sendBlockedNotification(urlToBlock, user, reason);
                   

                    // if successfully executed
                        string sSource = "[DATABASE WebService] Operations.execBlockZone";
                        string sLog = "Application";
                        string sEvent = "The host " + urlToBlock + " has been blocked by " + user;

                        if (!EventLog.SourceExists(sSource))
                            EventLog.CreateEventSource(sSource, sLog);

                        //EventLog.WriteEntry(sSource,sEvent);
                        EventLog.WriteEntry(sSource, sEvent, EventLogEntryType.Information, 51001);
                    return true;
                }
                catch(ManagementException me)
                {
                   
                    string sSource = "[DATABASE WebService] Operations.execBlockZone";
                    string sLog = "Application";
                    string sEvent = "Failed to block the host. Verify that MySQL is working correctly and there is access to a WMI connection on SERVER\n" + me.ToString();

                    if (!EventLog.SourceExists(sSource))
                        EventLog.CreateEventSource(sSource, sLog);

                    //EventLog.WriteEntry(sSource,sEvent);
                    EventLog.WriteEntry(sSource, sEvent, EventLogEntryType.Error, 51002);

                    return false;
                }


            }
        }


  

    }
}

