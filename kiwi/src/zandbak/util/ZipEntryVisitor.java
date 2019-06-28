package zandbak.util;

import java.util.zip.ZipInputStream;

public interface ZipEntryVisitor {
	public void visitEntry(String fileName, ZipInputStream zis);
}
