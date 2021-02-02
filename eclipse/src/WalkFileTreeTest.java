import java.io.IOException;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.FileSystems;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.BasicFileAttributes;

public class WalkFileTreeTest {

	public static void main(String[] args) throws Exception {
		// Returns the default FileSystem. The default file system creates objects that provide access to the file systems accessible to the Java virtual machine. The working directory of the file system is the current user directory, named by the system property user.dir. This allows for interoperability with the java.io.File class.
		System.out.println(FileSystems.getDefault());

		Path p = Paths.get(System.getProperty("user.dir"));
		System.out.println(p.resolve(Paths.get(args[0])).normalize());
		System.out.println(Paths.get(args[0]).normalize());
		WalkFileTreeTest.walk(args[0]);
	}

	public static void walk(String path) throws Exception {
		Files.walkFileTree(Paths.get(path), new SimpleFileVisitor<Path>() {
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
