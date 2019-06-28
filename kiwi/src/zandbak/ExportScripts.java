package zandbak;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Iterator;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import org.apache.log4j.Logger;

import com.filenet.api.collection.DocumentSet;
import com.filenet.api.collection.FolderSet;
import com.filenet.api.core.Document;
import com.filenet.api.core.Factory;
import com.filenet.api.core.Folder;
import com.filenet.api.core.ObjectStore;

import nl.novadoc.operations.connection.CEMod;
import zandbak.util.ZipEntryVisitor;
import zandbak.util.Log;
import zandbak.util.Zip;

@SuppressWarnings("rawtypes")
public class ExportScripts {

	private static String ceModPropertyFile = "ExportScripts.properties";

	public static final String CE_SOLUTIONS_PATH = "/IBM Case Manager/Solutions";
	public static final String CE_SOLUTION_DEFINITION_NAME = "Solution Definition";
	public static final String CE_PAGE_FOLDER = "Pages";

	private static CEMod ceMod;
	private static ObjectStore os;

	protected static String outputDir;
	protected static String solutionOutputDir;
	protected static Logger logger;

	public static void main(String[] args) throws IOException {
		outputDir = args.length > 0 ? args[0] : ".";
		Properties properties = getProperties();

		Log.init(properties);
		logger = Log.getLogger(ExportScripts.class);
		logger.debug(properties);

//		String zip = "c:\\temp\\3.zip";
//		processPageZip(zip);

		setupCEConnection(properties);
		processSolutions(properties);
	}

	private static void processSolutions(Properties properties) throws IOException {
		Folder solutions = Factory.Folder.fetchInstance(os, CE_SOLUTIONS_PATH, null);
		FolderSet solutionFolders = solutions.get_SubFolders();
		Iterator i = solutionFolders.iterator();
		while (i.hasNext()) {
			Folder folder = (Folder) i.next();
			logger.info("Solution: " + folder.get_FolderName());
			solutionOutputDir = outputDir + File.separator + folder.get_FolderName();
			processSolution(folder);
		}
	}

	private static void processSolution(Folder solution) throws IOException {
		String solutionName = solution.get_FolderName();
		String solutionCEPath = CE_SOLUTIONS_PATH + "/" + solutionName;

		processSolutionDefinition(solutionCEPath + "/" + CE_SOLUTION_DEFINITION_NAME, solutionName);

		DocumentSet docs = solution.get_ContainedDocuments();
		processSolutionDocuments(docs);

		processPages(solutionCEPath + "/" + CE_PAGE_FOLDER);
	}

	private static void processSolutionDefinition(String cePath, String solutionName) throws IOException {
		Document solutionDefinition = Factory.Document.fetchInstance(os, cePath, null);
		InputStream is = getContentInputStream(solutionDefinition);
		String filename = solutionName + ".xml";
		OutputStream os = getFileOutputStream(filename, null);
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

		String filePath = solutionOutputDir + "/pages/" + filename;
//		processPageZip(filePath);
	}

	private static void processPageZip(String path) {
		Zip.traverse(path, new ZipEntryVisitor() {
			public void visitEntry(ZipEntry entry, ZipInputStream zis) {
				String name = entry.getName();
	            if (! entry.isDirectory() && name.startsWith("templates/"))
					try {
						String path = solutionOutputDir + File.separator + name;
						logger.info("Unzipping to " + path);
						Zip.extractFile(path, zis);
						processPage(path);
					} catch (IOException e) {
						logger.error(e);
						System.exit(1);
					}
			}
		});
	}

	public static void processPage(String path) throws IOException {
		logger.info("Path " + path);
		BufferedReader br = new BufferedReader(new FileReader(path));
		try {
			String scriptActionStr = "\"actionDefinitionId\": \"icm.action.utility.ScriptAction\"";
			Pattern scriptActionLabelPattern = Pattern.compile(".*\"label\": \"(.*)\".*");
			Pattern scriptActionScriptPattern = Pattern.compile(".*\"script(\\w+)\": \"(.*)\".*");
			Pattern scriptActionEndPattern = Pattern.compile("\\s*},?\\s*");
			Pattern scriptAdapterNamePattern = Pattern.compile(".*icm\\.pgwidget\\.scriptadapter\\.ScriptAdapter.*, name:\"(.+?)\".*");
			Pattern scriptAdapterPayloadPattern = Pattern.compile(".*\"payload\": \"(.*)\".*");
			Matcher m;
			boolean matchScriptAction = false;
			boolean matchAdapterScript = false;

			String line;
		    while ((line = br.readLine()) != null) {
		        if (matchScriptAction) {
					m = scriptActionEndPattern.matcher(line);
		        	if (m.matches()) {
						matchScriptAction = false;
		        		continue;
		        	}
					m = scriptActionLabelPattern.matcher(line);
					if (m.matches()) {
						String label = m.group(1);
//						System.out.println("label: " + label);
		        		continue;
					}
					m = scriptActionScriptPattern.matcher(line);
					if (m.matches()) {
						String type = m.group(1);
						String script = m.group(2);
//						if (type.equals("Execute"))
//						System.out.println("type: " + type + " script: " + script);
					}
		        } else if (matchAdapterScript) {
					m = scriptAdapterPayloadPattern.matcher(line);
					if (m.matches()) {
						String script = m.group(1);
//						System.out.println("script: " + script);
						matchAdapterScript = false;
					}
		        } else if (line.contains(scriptActionStr)) {
		        	matchScriptAction = true;
		        } else {
					m = scriptAdapterNamePattern.matcher(line);
					if (m.matches()) {
						String name = m.group(1);
//						System.out.println("name: " + name);
						matchAdapterScript = true;
					}
		        }
		    }
		} finally {
		    br.close();
		}
	}

	private static InputStream getContentInputStream(Document document) {
		return document.accessContentStream(0);
	}

	private static OutputStream getFileOutputStream(String filename, String subFolder) throws FileNotFoundException {
		String path = solutionOutputDir;
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
		os = ceMod.getObjectStore(properties.getProperty("DesignObjectStore"));
	}

	private static void write(InputStream is, OutputStream os) throws IOException {
	   	byte[] buffer = new byte[is.available()];
	    is.read(buffer);
		os.write(buffer);
	}

}
