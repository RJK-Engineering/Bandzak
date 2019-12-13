package zandbak;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import com.filenet.api.core.Document;
import com.filenet.api.core.Factory;
import com.filenet.api.core.IndependentObject;
import com.filenet.api.core.ObjectStore;
import com.filenet.api.exception.EngineRuntimeException;

import nl.novadoc.operations.connection.CEMod;

public class ContentEngine {

	private static CEMod ceMod;
	private static String cePropertyFile = "ce.properties";
	private static ObjectStore os;

	public static void main(String[] args) throws IOException {
		Properties properties = getProperties();
		setupCEConnection(properties);
		test1();
	}

	private static void test2() {
//		Factory.Folder.fetchInstance(os, "{80503868-0000-CD16-9D17-1DE73F057704}", null);
		// does not return null but throws exception
		try {
			Factory.Folder.fetchInstance(os, "{80503868-0000-CD16-9D17-1DE73F057702}", null);
		} catch (EngineRuntimeException e) {
			// Het gevraagde item is niet gevonden. 
			// Object-ID: classId=Folder&objectId={80503868-0000-CD16-9D17-1DE73F057702}&objectStore={84A9B0D4-3821-40D9-B836-5F2CFA1DEB62}. 
			// Klassennaam: Folder.
			System.out.println(e.getMessage());
			System.out.println(e.getClass().getName());
		}
	}
	
	private static void test1() {
		try {
			IndependentObject o = os.fetchObject("Document", "{C0DABE69-0000-C212-84C5-9F8C317609D1}", null);
			
			try {
				o.fetchProperty("ExternZaaknummer", null); // only fetches objects
			} catch (RuntimeException e) {
				System.out.println(e.getMessage());
			}

			Document d = (Document) o; 
			System.out.println(d.get_Name()); // Document has methods for default props (get_*)

			// values must be retrieved via Properties object
			com.filenet.api.property.Properties props = o.getProperties();
			System.out.println(props.get("DocumentNummer").getStringValue());
			// or
			System.out.println(props.getStringValue("ExternZaaknummer"));
			System.out.println(props.getIdValue("Id"));
			
			System.out.println("" + (Document)(props.get("DocumentDISSecurityProxy").getObjectValue()));
			
			// find does not throw error like get() but returns null
			System.out.println("find() -> " + props.find("sdfdsf"));
			
			System.out.println("find() -> " + props.find("ComponentBindingLabel"));
			// Property value is null if not set
			System.out.println("getStringValue() -> " + props.find("ComponentBindingLabel").getStringValue());
			
		} catch (RuntimeException e) {
			e.printStackTrace();
		}
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
		os = ceMod.getObjectStore(properties.getProperty("TargetObjectStore"));
	}

}
