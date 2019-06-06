import java.util.Properties;

public class Test {

	public Test() {
		// TODO Auto-generated constructor stub
	}

	public static void main(String[] args) {
		String str = "sdf=";
		String f[] = str.split("=");
		System.out.println(f.length);

		Properties props = new Properties();
		props.setProperty("", "sadfsdf");
		System.out.println(props.getProperty(""));

	}

}
