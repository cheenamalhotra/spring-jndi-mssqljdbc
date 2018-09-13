
# Spring JNDI with 'mssqljdbc'
Sample application to demonstrate using Tomcat datasource configuration in Spring Boot Application.

## Below mechanisms have been covered:
- Reading non-encrypted data (Basic Connection)
- Decrypting data encrypted with Windows Key Store
- Decrypting data encrypted with Java key Store
- Decrypting data encrypted with Azure Key Vault

## Steps to begin:
1. Execute **setup_sqldb.sql** – This setup setups Database 'SQLDB' and creates tables for running this application. 
   - Provide Azure Key Vault URL details for Encryption
   - Run the script
2. Setup **context.xml** – Use tomcat-context.xml from repository to setup context.xml file for Tomcat Server JDBC Resource Configurations
    - Provide server details for dataSources configured.
    - Create 'AE_Certificates' folder in `${catalina.base}\\conf` directory and provide `.jks` certificate.
    - Update the certificate name in context.xml file.
    - If elsewhere, make sure user running Tomcat Server is able to access Java Key Store.
4. Provide `sqljdbc_auth.dll` to Tomcat Native DLL path by placing it in `JDK_HOME\bin` folder (or any other location recognized by Tomcat `catalina.bat` script).
5. Register Tomcat Server Application as “Service Principal” on Azure portal and provide access to Azure Key Vault.
6. Provide only 1 `mssql-jdbc` driver JAR for **AZURE KEY VAULT** provider registration and performing Encryption/Decryption.
    - This is applicable in this case where Azure Key Vault provider is registered in Controller class. If done elsewhere, it may not be applicable.
    - The application would fail if a copy of `mssql-jdbc` driver Jar is also placed in tomcat server’s lib directory. If client application does not access any driver classes, the driver is not required to be added as a Maven dependency. But if it is added a dependency in pom.xml, it should not be provided in the Tomcat Server’s lib directory.
7. Update **Application Client ID** and **Application Secret** in SpringBootController.java
7. Build the WAR file with `mvn clean package`.
8. Deploy WAR file to Tomcat Server.
