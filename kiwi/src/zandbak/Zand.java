package zandbak;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import zandbak.util.Zip;

public class Zand {

	public static void main(String[] args) {
		test3();
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
		Zip.unzip("c:\\temp\\zandbak.zip", "");
		
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
