package zandbak;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class RegExVoorJan {

	public static void main(String[] args) {
		String arguments = "export " 
		    + "-q \"SELECT d.* FROM Document d INNER JOIN ContentSearch c ON d.This = c.QueriedObject WHERE CONTAINS(d.*,'\\\"Shell\\\" OR \\\"NAM\\\" OR \\\"Nederlandse aardolie maatschappij\\\"')\" " 
		    + "-p \"Id Creator\" "
		    + "-os TOS "
		    + "-o migratie_test.txt";
//		String[] args = arguments.split("");

//		Matcher m = Pattern.compile("(-\)").matcher(arguments);
//		while (m.find())
//			System.out.println(m.group(1).replace("\"", ""));
	}
	

}
