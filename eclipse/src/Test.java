import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;

public class Test {

	public static void main(String[] args) throws Exception {
		test3();
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
