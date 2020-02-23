Getting Started with Basic Info Web Application:
------------------------------------------------

This application is basically a simple User Input Form that takes input from user and saves it in MYSQL database.

Note: This project is build with java 11.


Maven Configuration:
---------------------------

In order to create pom.xml, following steps are to be done:
		
		1. Edit your pom.xml settings and you are ready to go.


Project Configuration:
--------------------------

         1. Open Config.properties (located in WebContent folder).

         2. Update the details of your MySql service in it.

                  app42.paas.db.username = <your_database_username>
                  app42.paas.db.port = <your_service_port>
                  app42.paas.db.password = <your_database_password>
                  app42.paas.db.ip = <your_service_ip>
                  app42.paas.db.name = <your_database_name>
				  
				
Generating War File using Maven:
-----------------------------------

		1. First create pom.xml.
		
		2. Run the following command:
		
			### mvn clean
			### mvn install
			

Post Build Actions:
---------------------

    ### > ant clean
    ### > ant makedir
    ### > ant copy-artifacts
    ### > ant all-clean
    ### > ant clean makedir copy-artifacts
    

    
				  
