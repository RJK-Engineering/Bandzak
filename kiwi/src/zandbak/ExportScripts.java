package zandbak;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Iterator;
import java.util.Properties;

import com.filenet.api.collection.DocumentSet;
import com.filenet.api.collection.FolderSet;
import com.filenet.api.core.Document;
import com.filenet.api.core.Factory;
import com.filenet.api.core.Folder;
import com.filenet.api.core.ObjectStore;

import nl.novadoc.logger.Logger;
import nl.novadoc.operations.connection.CEMod;

@SuppressWarnings("rawtypes")
public class ExportScripts {

//	private static final String TAG = "ExportScripts";
	private static String objectStore = "DOS";
	private static String ceModPropertyFile = "ExportScripts.properties";
	private static String solutionsPath = "/IBM Case Manager/Solutions";
	private static String pageFolder = "Pages";
	private static CEMod ceMod;
	private static ObjectStore os;
//	private static Logger logger;
	private static String solutionDefinitionDocumentName = "Solution Definition";
	private static String outputDir;

	public static void main(String[] args) throws IOException {
		outputDir = args.length > 0 ? args[0] : ".";
		Properties properties = getProperties();
//		logger = Logger.getLogger(properties);
		Logger.getLogger(properties);

		setupCEConnection(properties);
		processSolutions(properties);
	}

	private static void processSolutions(Properties properties) throws IOException {
		Folder solutions = Factory.Folder.fetchInstance(os, solutionsPath, null);
		FolderSet solutionFolders = solutions.get_SubFolders();
		Iterator i = solutionFolders.iterator();
		while (i.hasNext()) {
			Folder folder = (Folder) i.next();
			processSolution(folder);
		}
	}

	private static void processSolution(Folder solution) throws IOException {
		String solutionName = solution.get_FolderName();
		String solutionCEPath = solutionsPath + "/" + solutionName;

		processSolutionDefinition(solutionCEPath + "/" + solutionDefinitionDocumentName, solutionName);

		DocumentSet docs = solution.get_ContainedDocuments();
		processSolutionDocuments(docs);

		processPages(solutionCEPath + "/" + pageFolder);
	}

	private static void processSolutionDefinition(String cePath, String solutionName) throws IOException {
		Document solutionDefinition = Factory.Document.fetchInstance(os, cePath, null);
		InputStream is = getContentInputStream(solutionDefinition);
		String filename = solutionName + ".xml";
		OutputStream os = getFileOutputStream(filename, "solutions");
		write(is, os);
	}

	private static void processSolutionDocuments(DocumentSet docs) throws IOException {
		Iterator i = docs.iterator();
		while (i.hasNext()) {
			Document doc = (Document) i.next();
			String clazz = doc.get_ClassDescription().get_SymbolicName();
			if (clazz.equals("WorkflowDefinition"))
				processWorkflow(doc);
		}
	}

	private static void processWorkflow(Document doc) throws IOException {
		InputStream is = getContentInputStream(doc);
		String filename = doc.get_Name() + ".xml";
		OutputStream os = getFileOutputStream(filename, "workflows");
		write(is, os);
	}

	private static void processPages(String cePath) throws IOException {
		Folder pages = Factory.Folder.fetchInstance(os, cePath, null);
		DocumentSet docs = pages.get_ContainedDocuments();
		Iterator i = docs.iterator();
		while (i.hasNext()) {
			Document doc = (Document) i.next();
			processPage(doc);
		}
	}

	private static void processPage(Document doc) throws IOException {
		InputStream is = getContentInputStream(doc);
		String filename = doc.get_Name().replaceAll("[\\\\/:*?\"<>|]", "_") + ".zip";
		OutputStream os = getFileOutputStream(filename, "pages");
		write(is, os);

		String filePath = outputDir + "/pages/" + filename;
		processPageZip(filePath);
	}

	private static void processPageZip(String filePath) {

//		logger.debug(TAG, docs);
		// extract javascript from html in "templates" directory
	}

	private static InputStream getContentInputStream(Document document) {
		return document.accessContentStream(0);
	}

	private static OutputStream getFileOutputStream(String filename, String subFolder) throws FileNotFoundException {
		String path = outputDir;
		if (subFolder != null) path += "/" + subFolder;

		File dir = new File(path);
		if (! dir.exists()) dir.mkdirs();

		path += "/" + filename;
		return new FileOutputStream(path);
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

	private static void write(InputStream is, OutputStream os) throws IOException {
	   	byte[] buffer = new byte[is.available()];
	    is.read(buffer);
		os.write(buffer);
	}

}
