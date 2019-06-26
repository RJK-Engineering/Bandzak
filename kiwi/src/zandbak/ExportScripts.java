package zandbak;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import javax.swing.text.html.HTML.Tag;

import com.filenet.api.collection.DocumentSet;
import com.filenet.api.core.Document;
import com.filenet.api.core.Factory;
import com.filenet.api.core.Folder;
import com.filenet.api.core.ObjectStore;

import nl.novadoc.logger.Logger;
import nl.novadoc.operations.connection.CEMod;

public class ExportScripts {

	private static final String TAG = "ExportScripts";
	private static String objectStore = "DOS";
	private static String ceModPropertyFile = "ExportScripts.properties";
	private static String solutionsPath = "/IBM Case Manager/Solutions";
	private static String pageFolder = "Pages";
	private static CEMod ceMod;
	private static ObjectStore os;
	private static Logger logger;
	private static String solutionDefinitionDocumentName = "Solution Definition";

	public static void main(String[] args) throws IOException {
		Properties properties = getProperties();

		logger = Logger.getLogger(properties);

		setupCEConnection(properties);
		
		String solutionName = "Kiwi";
		String solutionPath = solutionsPath + "/" + solutionName;
		String solutionDefinitionPath = solutionPath + "/" + solutionDefinitionDocumentName;
		String pageFolderPath = solutionPath + "/" + pageFolder;

//		Folder solution = Factory.Folder.fetchInstance(os, solutionPath, null);
//		logger.debug(TAG, solution.get_FolderName());
//		DocumentSet docs = solution.get_ContainedDocuments();
//		logger.debug(TAG, docs);
		
		Document solutionDefinition = Factory.Document.fetchInstance(os, solutionDefinitionPath, null);
//		logger.debug(TAG, solutionDefinition);
		InputStream acs = solutionDefinition.accessContentStream(0);
		
		

		// download pages (zip files)
		// extract zip
		// extract javascript from html in "templates" directory
	}

	private static Properties getProperties() throws IOException {
        InputStream is = ExportScripts.class.getClassLoader().getResourceAsStream(ceModPropertyFile);
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
		os = ceMod.getObjectStore(objectStore);
	}

}
