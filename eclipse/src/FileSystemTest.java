import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.FileSystem;
import java.nio.file.FileStore;
import java.nio.file.FileSystems;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Set;
import java.lang.Iterable;

public class FileSystemTest {

	public static void main(String[] args) throws Exception {
		FileSystem fs = FileSystems.getDefault();
		System.out.println(fs);
		Set<String> attrs = fs.supportedFileAttributeViews();
		System.out.println(attrs);
		Iterable<FileStore> stores = fs.getFileStores();
		for (FileStore s : stores) {
			System.out.println("\t" + s.name() + "\t" + s.type());
			System.out.println("\t" + s.getTotalSpace() + "\t" + s.getUnallocatedSpace() + "\t" + s.getUsableSpace() + "\t" + s.isReadOnly());
		}
	}

}
