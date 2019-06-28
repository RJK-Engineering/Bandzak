package zandbak.util;

import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

public interface ZipEntryVisitor {
	public void visitEntry(ZipEntry entry, ZipInputStream zis);
}
