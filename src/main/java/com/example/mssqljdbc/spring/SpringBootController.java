package com.example.mssqljdbc.spring;

import java.net.URISyntaxException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

import javax.naming.NamingException;
import javax.sql.DataSource;

import org.springframework.jndi.JndiObjectFactoryBean;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.microsoft.aad.adal4j.AuthenticationContext;
import com.microsoft.aad.adal4j.AuthenticationResult;
import com.microsoft.aad.adal4j.ClientCredential;
import com.microsoft.sqlserver.jdbc.SQLServerColumnEncryptionAzureKeyVaultProvider;
import com.microsoft.sqlserver.jdbc.SQLServerColumnEncryptionKeyStoreProvider;
import com.microsoft.sqlserver.jdbc.SQLServerConnection;
import com.microsoft.sqlserver.jdbc.SQLServerException;
import com.microsoft.sqlserver.jdbc.SQLServerKeyVaultAuthenticationCallback;

/**
 * RUN THIS APPLICATION AFTER RUNNING "setup_sqldb.sql" script to setup SQLDB database and all tables.
 */
@Controller
public class SpringBootController { 

	protected static final String applicationClientID = "<applicationClientID>";
	protected static final String applicationKey = "<applicationKey>";
	
	//Tables used in application
    private static final String user = "[user]";
    private static final String userAE = "[userAE]";
    private static final String userAEAKV = "[userAEAKV]";
    private static final String userAEJKS = "[userAEJKS]";
	
	public SpringBootController() {
		//Register AKV Provider and insert data in tables.
		try {
			registerAKVProvider();
			insertData();
		} catch (SQLException | URISyntaxException | IllegalArgumentException | NamingException e) {
			e.printStackTrace();
		}
	}
	
	private void insertData() throws SQLException, IllegalArgumentException, NamingException {
        try (Connection con = jndiDataSourceAEJKS().getConnection();) {
            insertInto(con, user);
            insertInto(con, userAE);
            insertInto(con, userAEAKV);
            insertInto(con, userAEJKS);
            System.out.println("Data inserted successfully.");
        }
	}

    private DataSource jndiDataSourceAEJKS() throws IllegalArgumentException, NamingException {
		JndiObjectFactoryBean bean = new JndiObjectFactoryBean();
		bean.setJndiName("java:/comp/env/jdbc/sqlserverAEJKS");
		bean.setProxyInterface(DataSource.class);
		bean.afterPropertiesSet();
		return (DataSource) bean.getObject();
	}

	private static void insertInto(Connection con, String table) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement("INSERT INTO " + table + " values (?,?);");) {
            ps.setString(1, "Adam");
            ps.setInt(2, 23);
            ps.addBatch();
            ps.setString(1, "Bob");
            ps.setInt(2, 30);
            ps.addBatch();
            ps.setString(1, "Chris");
            ps.setInt(2, 21);
            ps.addBatch();
            ps.setString(1, "Denise");
            ps.setInt(2, 24);
            ps.addBatch();
            ps.setString(1, "Eric");
            ps.setInt(2, 40);
            ps.addBatch();
            ps.executeBatch();
        }
    }

	@RequestMapping("/")
	public String welcome(Map<String, Object> model) {
		model.put("message", "Disabled");
		return "index";
	}

	@RequestMapping("/index")
	public String index(Map<String, Object> model) {
		model.put("message", "Disabled");
		return "index";
	}
	
	@RequestMapping("/ae")
	public String aeAuthentication(Map<String, Object> model) {
		model.put("message", "Enabled");
		return "ae";
	}

	@RequestMapping("/aeakv")
	public String aeAKVAuthentication(Map<String, Object> model) {
		model.put("message", "Enabled with Azure key Vault");
		return "aeakv";
	}

	@RequestMapping("/aejks")
	public String aeJKSAuthentication(Map<String, Object> model) {
		model.put("message", "Enabled with Java key Store");
		return "aejks";
	}
	
	private static void registerAKVProvider()
			throws SQLServerException, URISyntaxException {
		SQLServerColumnEncryptionAzureKeyVaultProvider akvProvider = new SQLServerColumnEncryptionAzureKeyVaultProvider(
				tryAuthenticationCallback());
		Map<String, SQLServerColumnEncryptionKeyStoreProvider> map1 = new HashMap<String, SQLServerColumnEncryptionKeyStoreProvider>();
		map1.put(akvProvider.getName(), akvProvider);
		try {
			SQLServerConnection.registerColumnEncryptionKeyStoreProviders(map1);
			System.out.println("REGISTERED : " + akvProvider.getName());
		} catch (SQLServerException e) {
			e.printStackTrace();
		}
	}

	private static SQLServerKeyVaultAuthenticationCallback tryAuthenticationCallback()
			throws URISyntaxException, SQLServerException {
		SQLServerKeyVaultAuthenticationCallback authenticationCallback = new SQLServerKeyVaultAuthenticationCallback() {

			@Override
			public String getAccessToken(String authority, String resource,
					String scope) {
				AuthenticationResult result = null;
				try {
					ExecutorService service = Executors.newFixedThreadPool(1);
					AuthenticationContext context = new AuthenticationContext(
							authority, false, service);
					ClientCredential cred = new ClientCredential(
							applicationClientID, applicationKey);
					Future<AuthenticationResult> future = context
							.acquireToken(resource, cred, null);
					result = future.get();
					service.shutdown();
				} catch (Exception e) {
					e.printStackTrace();
				}
				return result.getAccessToken();
			}
		};

		return authenticationCallback;
	}

}
