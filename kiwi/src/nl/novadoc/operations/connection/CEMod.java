package nl.novadoc.operations.connection;

import java.security.AccessController;

import javax.security.auth.Subject;

import com.filenet.api.core.Connection;
import com.filenet.api.core.Domain;
import com.filenet.api.core.EntireNetwork;
import com.filenet.api.core.Factory;
import com.filenet.api.core.ObjectStore;
import com.filenet.api.util.UserContext;

import filenet.vw.integrator.CMUserContext;
import filenet.vw.server.Configuration;
import nl.novadoc.logger.Logger;

/**
 * This object represents the connection with the Content Engine. Once
 * connection is established it intializes Domain and ObjectStoreSet with
 * available Domain and ObjectStoreSet.
 *
 */
public class CEMod {
	static Logger logger = Logger.getLogger();
	static String TAG = "CEMod";

	public static String testUserName;
	public static String testPassword;
	public static String testStanza;
	public static String testUri;
	public static boolean test = false;

	private Domain dom = null;

	/*
	 * constructor
	 */
	public CEMod() {
		try {
			if(test)
				establishConnectionTest();
			else
				establishConnection();
		} catch (Exception e) {
			logger.error(TAG, "Could not establish connection Content Engine!", e);
		}
	}

	/*
	 * Establishes connection with Content Engine using supplied username, password,
	 * JAAS stanza and CE Uri.
	 */
	private void establishConnection() throws Exception {
		try {
			// log.debug("Establishing connection with: " + uri);
			// con = Factory.Connection.getConnection(uri);

			// Subject sub = UserContext.createSubject(con, userName, password, stanza);
			// uc.pushSubject(sub);
			dom = fetchDomain();
			// ost = getOSSet();
		} catch (Exception e) {
			logger.error(TAG, e.getMessage());
			throw e;
		}
	}

	/**
	 * Establishes connection with Content Engine using
	 * supplied username, password, JAAS stanza and CE Uri.
	 * For testing
	 */
	public void establishConnectionTest()
	{
		try {
			UserContext uc = UserContext.get();

			Connection con = Factory.Connection.getConnection(testUri);
			Subject sub = UserContext.createSubject(con,testUserName,testPassword,testStanza);

			uc.pushSubject(sub);

			dom = Factory.Domain.fetchInstance(con, null, null);
		} catch (Exception e) {
			logger.error(TAG, e.getMessage());
		}
	}

	/*
	 * Returns Domain object.
	 */
	public Domain fetchDomain() throws Exception {
		Domain localDomain = null;
		try {
			Subject sub = Subject.getSubject(AccessController.getContext());
			if (sub == null) {
				sub = UserContext.getAmbientSubject();
			}
			if (sub == null) {
				sub = CMUserContext.getSubject();
			}
			String ceURI = Configuration.GetCEURI(null, null);

			Connection conn = Factory.Connection.getConnection(ceURI);

			UserContext uc = new UserContext();
			uc.pushSubject(sub);
			UserContext.set(uc);

			EntireNetwork entireNetwork = Factory.EntireNetwork.fetchInstance(conn, null);

			localDomain = entireNetwork.get_LocalDomain();
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		return localDomain;
	}

	public Domain getDomain() {
		return dom;
	}

	public Connection getConnection() {
		return dom.getConnection();
	}

	/*
	 * private Domain fetchDomain() throws Exception { try {
	 * log.debug("fetching Domain"); dom = Factory.Domain.fetchInstance(con, null,
	 * null); log.debug("Domain: " + dom.get_Name());
	 *
	 * return dom; } catch (Exception e) { log.error("could not fetch Domain");
	 * log.error(e.getMessage()); throw e; } }
	 */

	/*
	 * Returns ObjectStore object for supplied object store name.
	 */
	public ObjectStore fetchOS(String name) throws Exception {
		ObjectStore os = null;

		try {
			logger.debug(TAG, "fetching ObjectStore");
			os = Factory.ObjectStore.fetchInstance(dom, name, null);
			logger.debug(TAG, "ObjectStore: " + os.get_DisplayName());

			return os;
		} catch (Exception e) {
			logger.error(TAG, "could not return ObjectStore");
			logger.error(TAG, e.getMessage());
			throw e;
		}
	}

	public String toString() {
		return testUserName + "; " + testStanza + "; " + testUri;
	}

	public ObjectStore getObjectStore(String osName) {
		try {
			return fetchOS(osName);
		} catch (Exception e) {
			logger.error(TAG, "Could not retrieve Objectstore", e);
		}
		return null;
	}

}
