import java.io.IOException;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.BasicFileAttributes;

public class WalkFileTree {

	public static void main(String[] args) throws Exception {
		Files.walkFileTree(Paths.get("C:\\temp"), new SimpleFileVisitor<Path>() {
			public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
				System.out.println(file.toAbsolutePath());
	            return FileVisitResult.CONTINUE;
	        }
			public FileVisitResult preVisitDirectory(Path dir, BasicFileAttributes attrs) {
					System.out.println("PRE " + dir.toAbsolutePath());
	            return FileVisitResult.CONTINUE;
	        }
			public FileVisitResult postVisitDirectory(Path dir, IOException e) throws IOException {
	            if (e == null) {
	 				System.out.println("POST " + dir.toAbsolutePath());
	                return FileVisitResult.CONTINUE;
	            } else {
	                throw e;
	            }
	        }
		});
	}
	
}
