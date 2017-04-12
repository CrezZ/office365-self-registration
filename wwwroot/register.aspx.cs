using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.DirectoryServices;
using System.DirectoryServices.AccountManagement;
using System.Security.Cryptography;
using System.Globalization;     
using System.Text;

public partial class SamplePage : System.Web.UI.Page
{
//CHANGE THIS
//Domain
private string baseOU="dc=test,dc=onmicrosoft,dc=com";
private string baseOU2="ou=test.onmicrosoft.com";
private string base_email="test.onmicrosoft.com";
private string company="test.onmicrosoft.com";
private string usersOU="office365";



//Login-password for user with Edit rights
private string devopslogin="devops";
private string devopspass="123123";

//PreSharedKey for md5 HMAC sign of request
private string secret="P@SSSSS";



public string name="";
public string fname="";
public string email="";
public string email2="";
public string tel="";
public string fac="";
public string kaf="";
public string type="";
public string login="";
public string key="";
public string id="0";

private string pass="";

public string hide="block"; //hide main form
public string hide2="none"; //show message div
public string message=""; // message in div

protected void Page_Load(object sender, EventArgs e)
    {

System.Collections.Specialized.NameValueCollection Request2;
	if (!string.IsNullOrEmpty(Request["q"])){
	string src=Request["q"];
	string query=Encoding.UTF8.GetString(Convert.FromBase64String(src));
	Request2 = HttpUtility.ParseQueryString(query);
//	Request2 = Request.QueryString;

	} else
{
//Request2=Request.QueryString;
 if (Request.RequestType=="POST"){ //POST
 Request2=Request.Form; 
} else { //GET
 Request2=Request.QueryString; 
 }

}

	name=Request2["name"];
	fname=Request2["fname"];
	email=Request2["email"];
	email2=Request2["form-email2"];
	tel=Request2["form-tel"];
	kaf=Request2["dep"];
	fac=Request2["faculty"];
	key=Request2["key"];
	type=Request2["type"];
	login=Request2["login"];
	id=Request2["id"];
	MD5 md5 = MD5.Create();


// Check MD5 HMAC sign

	string dat = Convert.ToDateTime(DateTime.Now, CultureInfo.GetCultureInfo("ru-RU")).ToString("yyyy-MM-dd");
	string source = id+name+fname+email+login+type+fac+kaf+secret+dat;
	string hash = GetMd5Hash(md5, source);


	if (hash!=key){  // Sign error

		//Generate Error
		throw(new ArgumentNullException());
 	// Response.Write("MD5:"+source+':'+hash);  // For debug ONLY
	}
	    SearchResult user= searchUser(login);

		if (user!=null){   // Existing  user
			message="<h3 style='color:black;'><strong>Вы уже зарегистрированы, можете обновить информацию</strong></h1><p>"+
				 "";
			hide2="block";
			

			}

   
        pass=Request2["form-password"];
	
	if (!string.IsNullOrEmpty(pass)){ 
//bool adduser(string login, string pass, string f, string i, string email, string fac, string kaf, string group, string type){

		if (!adduser(login,pass,fname,name,email,fac,kaf,"",type)){
			message="<h3 style='color:red;'><strong>НЕ МОГУ СОЗДАТЬ ЗАПРОС</strong></h3>"+
				 "<p style='color:white'>Возможно пароль слишком легкий</span>";
			hide2="block";
			} else
			{message="<h1 style='color:white;'><strong>ЗАПРОС СОЗДАН <H3 style='color:white;'>Через 30 минут</strong></h1>"+
				 "<h3 style='color:white;'>Войти можно на <a href='http://portal.office.com'>PORTAL.OFFICE.COM</a></h2><br>"+
				 "<h3 style='color:white;'><a href='/index.html'>Узнать как работать с office365</a></h2>";
			hide="none"; hide2="block";
			}		
			//Environment.FailFast("0");
		}

        Page.DataBind();
    }

  public void Page_Error(object sender,EventArgs e)
{
	Exception objErr = Server.GetLastError().GetBaseException();
	string err =	"<b>Упс, неверный ключ защиты</b><hr><br>";
	Response.Write(err.ToString());
	Server.ClearError();
}  
        static string GetMd5Hash(MD5 md5Hash, string input)
        {

            // Convert the input string to a byte array and compute the hash.
            byte[] data = md5Hash.ComputeHash(Encoding.UTF8.GetBytes(input));

            // Create a new Stringbuilder to collect the bytes
            // and create a string.
            StringBuilder sBuilder = new StringBuilder();

            // Loop through each byte of the hashed data 
            // and format each one as a hexadecimal string.
            for (int i = 0; i < data.Length; i++)
            {
                sBuilder.Append(data[i].ToString("x2"));
            }

            // Return the hexadecimal string.
            return sBuilder.ToString();
        }

        // Verify a hash against a string.
        static bool VerifyMd5Hash(MD5 md5Hash, string input, string hash)
        {
            // Hash the input.
            string hashOfInput = GetMd5Hash(md5Hash, input);

            // Create a StringComparer an compare the hashes.
            StringComparer comparer = StringComparer.OrdinalIgnoreCase;

            if (0 == comparer.Compare(hashOfInput, hash))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

DirectoryEntry GetOU(string OU){
try{
  string comma = (OU=="")?"":",";
  //Response.Write("LDAP://"+OU+comma+baseOU);
    return   new DirectoryEntry("LDAP://"+OU+comma+baseOU,devopslogin,devopspass);
 } //try
            catch (Exception ex){
 //Create new OU?
       return null;
}//catch

}//GetOU
DirectoryEntry GetCN(string OU){
try{
  //Response.Write("LDAP://"+OU+comma+baseOU);
    return   new DirectoryEntry("LDAP://"+OU,devopslogin,devopspass);
 } //try
            catch (Exception ex){
 //Create new OU?
       return null;
}//catch

}//GetOU

bool searchOU(string OU){
DirectorySearcher searcher = new DirectorySearcher("LDAP://"+baseOU);
// specify that you search for organizational units 
searcher.Filter = "(objectCategory=organizationalUnit)";
//searcher.SearchScope = SearchScope.SubTree;  // search entire subtree from here on down
try
	{
		return  searcher.FindOne()==null;
	}//try
    catch (Exception ex)
{
   Response.Write(ex.Source + " - search<br />");
   Response.Write(ex.Message + "<br />");
   Response.Write(ex.InnerException);
   return false;
}//catch
}//searchOU


SearchResult  searchUser(string user){
DirectorySearcher searcher = new DirectorySearcher("LDAP://"+baseOU2+","+baseOU);
// specify that you search for organizational units 
searcher.Filter = string.Format("(&(objectCategory=person)(anr={0}))", user);
 searcher.SearchScope = SearchScope.Subtree;  // search entire subtree from here on down
try
	{
              SearchResultCollection resultCollection = searcher.FindAll();
               if(resultCollection != null && resultCollection.Count > 0)
 			{ 
				return resultCollection[0];  
  			} else {return null;}
	}//try
    catch (Exception ex)
{
   Response.Write(ex.Source + " - USER <br />");
   Response.Write(ex.Message + "<br />");
   Response.Write(ex.InnerException);
   return null;
}//catch
}//searchOU



bool createOU(string kaf, string fac){
      DirectoryEntry ouEntry = GetOU("");

try{           // Response.Write("OU="+fac+","+baseOU2);
		DirectoryEntry childEntry = ouEntry.Children.Add("OU="+fac+","+baseOU2 , "OrganizationalUnit");
		childEntry.CommitChanges();
//	        DirectoryEntry ouEntry = GetOU("OU="+fac+","+baseOU2);
		DirectoryEntry userD = childEntry.Children.Add("CN="+fac , "group");
                userD.CommitChanges();

                //ouEntry.CommitChanges();

}
    catch (Exception ex)
{
 //  Response.Write(ex.Source + "-create fac <br />");
  // Response.Write(ex.Message + "<br />");
 //  Response.Write(ex.InnerException);
// return false;
}//catch
try{
		DirectoryEntry childEntry = ouEntry.Children.Add("OU="+kaf+",OU="+fac+","+baseOU2 , "organizationalUnit");
                childEntry.CommitChanges();
		DirectoryEntry userD = childEntry.Children.Add("CN="+kaf , "group");
                userD.CommitChanges();

 //               ouEntry.CommitChanges();
return true;
}
    catch (Exception ex)
{
  // Response.Write(ex.Source + "-create kaf<br />");
  // Response.Write(ex.Message + "<br />");
  // Response.Write(ex.InnerException);
 return false;
}//catch

}

bool adduser(string login, string pass, string f, string i, string email, string fac, string kaf, string group, string type){
login=login.ToLower();
   createOU(kaf,fac);
   SearchResult user= searchUser(login);
   DirectoryEntry userD;
	try
            {

if (user==null)
{ //create new one
	        DirectoryEntry ouEntry = GetOU("OU="+kaf+",OU="+fac+","+baseOU2);
		userD = ouEntry.Children.Add("CN="+login , "inetOrgPerson");
                userD.CommitChanges();
                ouEntry.CommitChanges();

    } //create new
 else {//get user object
    string path=user.GetDirectoryEntry().Properties["distinguishedName"][0].ToString();
  //  Response.Write(path);
    userD = GetCN(path);
 //   userD.Invoke("SetPassword", new object[] { pass });
//    userD.CommitChanges();

} 
    userD.Invoke("SetPassword", new object[] { pass });

              //  userD.Password = pass;
//                userD.CommitChanges();
      
	 userD.Properties["userAccountControl"][0]=0x200;   //enabled
	 userD.Properties["userPrincipalName"].Value=login+"@"+base_email;   //enabled
         userD.Properties["GivenName"].Value=name;
         userD.Properties["displayName"].Value=name+' '+fname;
         userD.Properties["SAMAccountName"].Value=login;
	 userD.Properties["sn"].Value=fname;
	 userD.Properties["mail"].Value="SMTP:"+email2;
	 userD.Properties["mobile"].Value=tel;
	 userD.Properties["description"].Value=id;
	 userD.Properties["department"].Value=fac+", "+kaf;
	 userD.Properties["company"].Value=company;
	 userD.Properties["countryCode"].Value="643"; //russia
//	 userD.Properties["UsageLocation"].Value="RU";
	 userD.Properties["c"].Value="RU";
	// userD.Properties["proxyAddresses"].Value="SMTP:"+email2;
	// userD.Properties["proxyAddresses"].Add("smtp:"+email);

	
	 userD.CommitChanges();


//remove from all groups
foreach(string s in userD.Properties["memberOf"]){
DirectoryEntry gr2=GetCN(s);
gr2.Properties["member"].Remove(userD.Properties["distinguishedName"][0].ToString());
gr2.CommitChanges();
gr2.Close();
//Response.Write("G:"+s);
}

DirectoryEntry gr;

//add to FACULTY GROUP

        gr=GetCN("cn="+fac+",OU="+fac+","+baseOU2+","+baseOU);
	gr.Properties["member"].Add(userD.Properties["distinguishedName"][0].ToString());
        gr.CommitChanges();
	gr.Close();
//add to KAFEDRA GROUP
        gr=GetCN("cn="+kaf+",OU="+kaf+",OU="+fac+","+baseOU2+","+baseOU);
	gr.Properties["member"].Add(userD.Properties["distinguishedName"][0].ToString());
        gr.CommitChanges();
	gr.Close();

if (type=="3"){ //add to students
       gr=GetCN("cn=office_students,"+baseOU2+","+baseOU);
}else
if (type=="1"){ //add to prepods
       gr=GetCN("cn=office_prepods,"+baseOU2+","+baseOU);
}else  
if (type=="4"){ //add to postdok
       gr=GetCN("cn=office_postdoc,"+baseOU2+","+baseOU);
}else  
        {      
	  //add to users == lohs, type=2
	  gr=GetCN("cn=office_users,"+baseOU2+","+baseOU);
	}
      gr.Properties["member"].Add(userD.Properties["distinguishedName"][0].ToString());
      gr.CommitChanges();
      gr.Close();
      userD.Close();

     //TODO: HERE WE MUST UPDATE USER INFO in userD object
            } //try

            catch (Exception ex)
            {
   // Response.Write(ex.Source + "-create kaf<br />");
//   Response.Write(ex.Message + "<br />");
  //Response.Write(ex.InnerException);

             return false;
            }      //catch

 return true;
}

}