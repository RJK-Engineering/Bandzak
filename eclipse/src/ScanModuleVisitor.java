import java.io.File;
import java.io.FileFilter;
import java.io.IOException;
import java.nio.file.FileVisitResult;
import java.nio.file.FileVisitor;
import java.nio.file.Path;
import java.nio.file.attribute.BasicFileAttributes;

public class ScanModuleVisitor implements FileVisitor<Path> {

	@Override
	public FileVisitResult preVisitDirectory(Path dir, BasicFileAttributes attrs) throws IOException {
		scanModule_preVisitDir(dir.toFile());
		dir.toFile().listFiles(new FileFilter() {
			public boolean accept(File file) {
				scanModule_visitFile(file);
				return false;
			}
		});
		scanModule_postVisitDir(dir.toFile());
		return FileVisitResult.CONTINUE;
	}

	@Override
	public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
		return FileVisitResult.CONTINUE;
	}

	@Override
	public FileVisitResult visitFileFailed(Path file, IOException e) throws IOException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public FileVisitResult postVisitDirectory(Path dir, IOException e) throws IOException {
		if (e == null) {
			return FileVisitResult.CONTINUE;
		} else {
			throw e;
		}
	}

	public void visitFile(File file) {
		scanModule_visitFile(file);
	}

	private void scanModule_preVisitDir(File dir) {
		System.out.println(dir.getAbsolutePath());
	}

	private void scanModule_postVisitDir(File dir) {
		System.out.println("-----------------------");
	}

	private void scanModule_visitFile(File file) {
		System.out.println(file.getName());
	}

}
