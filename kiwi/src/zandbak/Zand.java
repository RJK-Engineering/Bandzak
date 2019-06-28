package zandbak;

import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.regex.Pattern;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import zandbak.util.Zip;
import zandbak.util.ZipEntryVisitor;

public class Zand {

	protected static String bla = "!";

	public static void main(String[] args) {
		test5();
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
