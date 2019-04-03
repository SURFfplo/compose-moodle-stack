# compose-moodle-stack
Deze compose directory in combinatie met het moodle-image project bouwt een docker swarm 
De Moodle app (apache, php  moodle source en modules) wordt als een app gezien de database als een adere om zo een samengestelde service te maken

# opbouw
De image is opgebouwd op basis van alpine 3.7 aangevuld met apache, php7 en de source code voor moodle en de saml2 module: https://github.com/catalyst/moodle-auth_saml2 

Een losse db 
met een eigen configuratie

# opstarten
Om hem op te starten gebruiken we:
initial_startup.sh

# data uitwisseling 
Aanaken van een admin user
Aanmaken van toegang tot de webservices en de bijbehorende tokens op basis van de bestaande user

Here you will find instructions to create Web Services on Moodle.
I am not a Moodle expert. I have collected the information below from may different sources and I have eliminated their errors to give you an easy to follow tutorial together with a working example.
This tutorial creates a web service enabled to create a new user and then enroll this user to a course.
1) Create the user which will serve the web services. Go to:
Site Administrator > Users > Accounts > Add new user
Username: wsuser (user your own)
Password: (user your own)
Fill in the required fields.
2) Give the wsuser the appropriate role. Go to:
Site Administrator > Users > Permissions > Define roles
press the Add new role button
Select Role archetype = ARCHETYPE: Manager and press continue
On the form:
Web Service User
Context types where this role may be assigned: System/User/Category/Course
Leave the rest selections as they appear.
Capabilities
Add the following capabilities
webservice/rest:use
moodle/user:create
enrol/manual:enrol
enrol/category:synchronised
enrol/manual:unenrolself
Press Create this role button.
3) Assign System roles. Go to:
Site Administrator > Users > Permissions > Assign System Roles
Assign wsuser user.
4) Create the needed services. Go to:
Site Administrator > Plugins > Web Services > External Services
We need the two services below:
a) Create user – service
On custom services table press add.
Name: create_user
Short: create_user
Enabled should be checked
Authorized users only should be checked
Press show more
Search for capability moodle/user:create and select it.
Press add service.
This service has no functions
Add functions
Search for the core_user_create_user
Select it and press add function.
b) Enroll user – service
On custom services table press add.
Name: enrol_user
Short: enrol_user
Enabled should be checked
Authorized users only should be checked
Press show more
Search for capability enroll/manual:enrol and select it.
Press add service
This service has no functions
Add functions
Search for the enrol_manual_enrol_users
Select it and press add function.
On the list of custom services you have to add the authorized user to be the wsuser.
5) Create the Tokens. Go to:
Site Administrator > Plugins > Web Services > External Services > Manage Tokens
Add
a) Create User
Select user Web Service User
Service – create user
Save changes.
b) Enroll User
Select user Web Service User
Service – enrol user
Save changes.
You now have the two required tokens.
6) All web service protocols are disabled. The «Enable web services» setting can be found in Advanced features. Go to:
• Site Administrator > Advanced features > Enable web services checked – Save.
• Site Administrator > Plugins > Web Services > External Services > Manage Protocols.
Activate REST protocol.
Check the documentation box.
7) CURL.php is required on the client side. You may download it here.
8) Check if create user works using php code.
9) Check if enroll user works using php code.
10) The wsuser user can not assign role without being enrolled in the course/s!!!
