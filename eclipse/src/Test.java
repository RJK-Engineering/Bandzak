import java.io.File;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;

public class Test {

	public static void main(String[] args) throws Exception {
		File resultsFolder = new File(".");
		System.out.println(resultsFolder.getCanonicalPath() + File.separator + "fileName");
		System.out.println(String.format("value is %.2f", 32.3));  
		System.out.println(String.format("value is %.0f", 32.3));
		System.out.println(System.getenv("APPDATA"));
		System.out.println("asdf/sdfd/sf".replaceAll("/", "a"));
	}
	
	private static void test5() throws ParseException {
		char[] a = null;
		if (a instanceof char[])
			System.out.println("Zekers");
		a = new char[] {'a'};
		if (a instanceof char[])
			System.out.println("Zekers");
	}

	private static void test4() throws ParseException {
		 System.out.println( "* \\ / : ? \" < > |".replaceAll("[*\\\\/:\\?\\\"<>\\|]", ".") );
	}
	
	private static void test3() throws ParseException {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmm00");
		String now = sdf.format(new Date());
		System.out.println(now);
	}

	private static void test2() throws ParseException {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmmss");
		String now = sdf.format(new Date());
		System.out.println(now);
		if (sdf.getCalendar().isWeekDateSupported()) {
			Date date = sdf.parse("20000101000001");
			System.out.println(sdf.format(date));
			sdf = new SimpleDateFormat("YYYYMMddhhmmss");
			System.out.println(sdf.format(date));
		}
	}

	private static void test1() {
		String str = "sdf=";
		String f[] = str.split("=");
		System.out.println(f.length);

		Properties props = new Properties();
		props.setProperty("", "sadfsdf");
		System.out.println(props.getProperty(""));
	}

}
