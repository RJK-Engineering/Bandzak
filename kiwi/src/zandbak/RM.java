package zandbak;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import com.filenet.api.core.Connection;
import com.ibm.jarm.api.collection.PageableSet;
import com.ibm.jarm.api.constants.EntityType;
import com.ibm.jarm.api.core.DomainConnection;
import com.ibm.jarm.api.core.FilePlanRepository;
import com.ibm.jarm.api.core.RMDomain;
import com.ibm.jarm.api.core.RMFactory;
import com.ibm.jarm.api.core.RecordFolder;
import com.ibm.jarm.api.query.RMSearch;
import com.ibm.jarm.api.util.P8CE_Convert;

import nl.novadoc.operations.connection.CEMod;

public class RM {

	private static CEMod ceMod;
	private static String cePropertyFile = "ce.properties";
	private static FilePlanRepository fpRepos;

	public static void main(String[] args) throws Exception {
		Properties properties = getProperties();
		setupCEConnection(properties);
		fpRepos = fetchFilePlanRepository(ceMod, "FPOS");
		test1();
	}

	private static void test1() {
		String recordFolderId = "OP-BD-K569";
		String sql = "SELECT * FROM RecordFolder";
		sql += " WHERE RecordFolderIdentifier='" + recordFolderId + "'";

		RMSearch jarmSearch = new RMSearch(fpRepos);
		PageableSet<RecordFolder> resultSet = (PageableSet<RecordFolder>) jarmSearch.fetchObjects(
			 sql, // P8 SQL statement
			 EntityType.RecordFolder, // Type of object to return
			 null, // Default page size
			 null, // Bring back all properties
			 Boolean.FALSE
		);
		
		for (RecordFolder res : resultSet) {
			 System.out.printf("Record %s.%n", res.getObjectIdentity());
		}
//		return resultSet.totalCount() == 0 ? null : resultSet.iterator().next();
	}

	private static Properties getProperties() throws IOException {
		InputStream is = ExportScripts.class.getClassLoader().getResourceAsStream(cePropertyFile);
		Properties properties = new Properties();
		properties.load(is);
		return properties;
	}

	private static void setupCEConnection(Properties properties) throws IOException {
		CEMod.testUserName = properties.getProperty("UserName");
		CEMod.testPassword = properties.getProperty("Password");
		CEMod.testStanza = properties.getProperty("Stanza");
		CEMod.testUri = properties.getProperty("Uri");
		CEMod.test = true;

		ceMod = new CEMod();
	}

	public static FilePlanRepository fetchFilePlanRepository(CEMod ceMod, String objectStore) throws Exception {
	    return RMFactory.FilePlanRepository.fetchInstance(fetchRMDomain(ceMod.getConnection()), objectStore, null);
	}

	private static RMDomain fetchRMDomain(Connection ceConnection) throws Exception {
		DomainConnection rmConnection = P8CE_Convert.fromP8CE(ceConnection);
		return RMFactory.RMDomain.fetchInstance(rmConnection, null, null);
	}
	
}
