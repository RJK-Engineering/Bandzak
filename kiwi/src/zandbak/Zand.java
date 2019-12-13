package zandbak;

import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.regex.Pattern;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import nl.novadoc.rm.rest.utils.RMRestUtils;
import zandbak.util.Zip;
import zandbak.util.ZipEntryVisitor;

public class Zand {

	protected static String bla = "!";
	private static int maxRecordFolderNameLength;

	public static void main(String[] args) {
	    Calendar c = Calendar.getInstance();
	    c.add(Calendar.YEAR, 20);  
	    System.out.println(c.getTime());
//		search("f", "w", "o", 0);
//		search("f", "w", "o", 1);
//		search("f", "w", "", 0);
//		search("f", "", "", 0);
//		search("f", "", "o", 0);
	}

	public static void search(String from, String where,
			String orderBy, int maxResults) {

		String topString 	 = maxResults > 0 						 ? String.format(" TOP %s", maxResults) : "";
		String whereString   = where   != null && !where  .isEmpty() ? String.format(" WHERE %s", where) : "";
		String orderByString = orderBy != null && !orderBy.isEmpty() ? String.format(" ORDER BY %s ASC", orderBy) : "";
	
		System.out.println( 
			String.format("SELECT%s * FROM %s%s%s", topString, from, whereString, orderByString)
		);
	}

	private static void test() {
		System.out.println(String.format("%s - %s_%d", "onderwerp", "thema", 123));
	}

    private static void strRepeat() {
		maxRecordFolderNameLength = 10;
//		System.out.println"123"));
		String str = "abc"; 
		str = new String(new char[10]).replace("\0", str);
		System.out.println(getFolderName(str));
	}

	private static String getFolderName(String name) {
        name = name.replaceAll("[*\\\\/:\\?\\\"<>\\|]", ".");
        if (maxRecordFolderNameLength < name.length())
            name = name.substring(0, maxRecordFolderNameLength);
        return name;
    }
	
	private static void test6() {
		System.out.println("abc".substring(0,2));
	}

	private static void test5() {
		
		String[] illegalChars = {"/", "\\", "?", "%", "*", ":", "|", "\"", "<", ">"};

		String regex = "";
		for (int i=0; i<illegalChars.length; i++)
			regex += illegalChars[i];
		regex = "[" + Pattern.quote(regex) + "]";
		
		System.out.println(regex);
			
		String str = "/, \\, ?, %, *, :, |, \", <, >";
		str = str.replaceAll(regex, "!");
		System.out.println(str);
	}

	private static void test4() {
		// >= java 8
		// compiled with java 8 "java -source 1.6" => can be run with java 8 
		String[] a = new String[]{"a","b"};
//		System.out.println(String.join("a", a));
	}


	private static void test2() {
		String str = "asdsad";
		System.out.println(str.toString());

		System.out.println(str.subSequence(1, str.length()-1));
	}

	private static void test3() {
//		Zip.unzip("c:\\temp\\test.zip", "");
//		Zip.traverse("c:\\temp\\DetailsFOType.zip", new ZipEntryVisitor() {
		Zip.traverse("c:\\temp\\3.zip", new ZipEntryVisitor() {
			public void visitEntry(ZipEntry entry, ZipInputStream zis) {
				//					Zip.extractFile(fileName, zis);
	            if (! entry.isDirectory())
	            	System.out.println(entry.getName() + Zand.bla);
			}
		});
	
	}

	private static void test1() {
		String str = "123asdkoj";
		try {
			DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
			formatter.parse(str);
		} catch (ParseException e) {
			System.out.println("Error parsing date at: " + str.substring(e.getErrorOffset()));
		}
	}

}
