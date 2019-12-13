import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class WalkDirs {
	
	private static ScanModuleVisitor visitor;
	
	public static void main(String[] args) throws Exception {
		visitor = new ScanModuleVisitor();
//		scanDir();
		scanFile();
	}
	
	private static void scanDir() throws IOException {
		Files.walkFileTree(Paths.get("C:\\temp"), visitor);	
	}

	private static void scanFile() {
		Path file = Paths.get("C:\\temp\\ids.txt");
//		doesn't work
//		Files.walkFileTree(file, visitor);
		
		visitor.visitFile(file.toFile());
	}

}
