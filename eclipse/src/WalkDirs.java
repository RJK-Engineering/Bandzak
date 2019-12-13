import java.nio.file.FileVisitor;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class WalkDirs {

	public static void main(String[] args) throws Exception {
		FileVisitor<? super Path> visitor = new ScanModuleVisitor();
		Files.walkFileTree(Paths.get("C:\\temp"), visitor);
	}
	
}
