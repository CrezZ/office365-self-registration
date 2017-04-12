# office365-self-registration

Project consist of 2 parts
1) web registration in AD from any site-based IIS server
2) Syncronization script for Group/OU based License assigning

We need
1 Windows AD Server
2 installed AzureAD Connector (AAD)
3 Filter in AAD connector for some OU to sync with
4 IIS Web server for registraion script (wwwroot folder)
5 Scheduler for sync script (script.cmd in script folder)

This system created to sync any external User database with AD and AAD. Any external service can generate link to wwwroot/register.asp?params1&param2...  for initiate user self registration. In params we can transfer Name,FName,Dept, email and other parameters. All parameters can be sign with HMAC (MD5 with secret key and current date). All parameters can be transfered both a=xxx&b=yyy manner and params=base64(a=xxx&b=yyy) manner

## Quick start

1 Copy wwwroot to c:\inetpub\wwwroot on IIS server
2 edit register.asp.cs, set this parameters
<pre>
//Domain
private string baseOU="dc=test,dc=onmicrosoft,dc=com";
private string baseOU2="ou=test.onmicrosoft.com";

//Login-password for user with Edit rights
private string devopslogin="devops";
private string devopspass="123123123123";

//PreSharedKey for md5 HMAC sign of request
private string secret="SECRET222322";


</pre>

3 Create on AD OrganizationUnit with name 

## GET/POST request for registration
  name - Firs name
	fname - Family name
	email - work email
	email2 - private email
	form-tel - telephone (mobile for password recovery)
	dep - department
  faculty - top level department 
	key - HMAC key
	type - 0,1,2,3 - for student, postdoc and other (see below)
	login - unique login (usually already exist in organization)
	id - (id for future puposes, we get in from organization database)
 
 ## GET/POST Base64 request
 
 q - base64(full get/post request)
 
 ### how to generate HMAC
  
  // Check MD5 HMAC sign

	string dat = Convert.ToDateTime(DateTime.Now, CultureInfo.GetCultureInfo("ru-RU")).ToString("yyyy-MM-dd");
	string source = id+name+fname+email+login+type+fac+kaf+secret+dat;
	string hash = GetMd5Hash(md5, source);


  
  


