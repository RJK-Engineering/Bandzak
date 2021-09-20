import java.nio.file.Paths;

public class Path {

	public static void main(String[] args) throws Exception {
		System.out.println(Paths.get("", "", "temp", "a", ""));
		System.out.println(Paths.get("A:\\file.txt"));
		System.out.println(Paths.get("A:\\asdsad\\file.txt").getParent());
		System.out.println(Paths.get("A:\\a..\\asdsad.\\..\\\\.\\file.txt."));
		System.out.println(Paths.get("A:\\a..\\asdsad.\\..\\\\.\\file.txt.").normalize());
		System.out.println(Paths.get("A:\\.").getFileName());
		System.out.println(Paths.get("A:\\. \" asdf").getFileName());
	}

}
