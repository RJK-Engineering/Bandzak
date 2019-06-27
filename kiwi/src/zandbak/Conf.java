package zandbak;

import java.io.StringReader;
import java.util.Properties;

import com.ibm.json.java.JSONArray;
import com.ibm.json.java.JSONObject;

public class Conf {
	public static void main(String[] args) throws Exception  {
		// String configString = "abcde";
		// String configString = "abcde";
		// String configString = "[\"abcde\"]";
		// String configString = "{\"a\": \"abcde\"]";
		// String configString = "\n{\"a\": \"abcde\"}";
		// String configString = "b=123\na=abcde";
		String configString = "b=123\na=abcde";
		String[] keys = new String[]{null};

		String[] vals;
		try {
			vals = getConfigValues(configString, keys);
		} catch (Exception e) {
			throw new Exception("Error parsing configuration: " + configString, e);
		}
		System.out.println(vals[0]);
	}

	/**
	 * Get configuration value(s) from <code>configString</code>.
	 *
	 * If <code>keys</code> is <code>null</code>, the returned array will contain the entire (trimmed)
	 * <code>configString</code> at index 0, otherwise:
	 *
	 * <ul>
	 * <li>If <code>configString</code> contains a JSON array, all the elements in the array will be returned.</li>
	 * <li>If <code>configString</code> contains a JSON object, the values in the object for the specified
	 * <code>keys</code> will be returned.</li>
	 * <li>If <code>configString</code> contains a property list, the values for the properties specified
	 * in <code>keys</code> will be returned.</li>
	 * <li>If <code>configString</code> is empty, an empty array will be returned.</li>
	 * <li>Throws an <code>Exception</code> otherwise.</li>
	 * </ul>
	 *
	 * @param configString
	 * 		Configuration string
	 * @param keys
	 * 		Keys to get values for
	 * @return
	 * 		List of values
	 * @throws Exception
	 *	  When parsing fails
	 * @throws Exception
	 *	  When <code>configString</code> contains a JSON object and <code>keys</code> is empty.
	 * @throws Exception
	 *	  When <code>configString</code> contains a property list and <code>keys</code> is empty.
	 */
	private static String[] getConfigValues(String configString, String[] keys) throws Exception {
		configString = configString.trim();
		String[] values = {};

		if (keys == null) {
			values = new String[]{configString};
		}
		else if (configString.startsWith("[")) {
			JSONArray array = JSONArray.parse(configString);

			values = new String[array.size()];
			array.toArray(values);
		}
		else if (configString.startsWith("{")) {
			if (keys.length == 0) throw new Exception("No keys specified");
			JSONObject object = JSONObject.parse(configString);

			values = new String[keys.length];
			for (int i=0; i<values.length; i++)
				values[i] = (String) object.get(keys[i]);
		}
		else if (configString.contains("=")) {
			if (keys.length == 0) throw new Exception("No keys specified");
			Properties props = new Properties();
			props.load(new StringReader(configString));

			values = new String[keys.length];
			for (int i=0; i<values.length; i++)
				values[i] = props.getProperty(keys[i]);
		}
		else if (!configString.equals("")) {
			throw new Exception("Invalid configuration string");
		}

		return values;
	}
}