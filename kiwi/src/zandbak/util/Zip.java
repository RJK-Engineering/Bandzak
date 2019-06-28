package zandbak.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

public class Zip {

	public static void unzip(String filePath, String destDirPath) {
		File dir = new File(destDirPath);
		if (!dir.exists()) dir.mkdirs();

		FileInputStream fis;
		byte[] buffer = new byte[1024];
		try {
			fis = new FileInputStream(filePath);
			ZipInputStream zis = new ZipInputStream(fis);
			ZipEntry ze = zis.getNextEntry();
			while (ze != null){
				if (zis.available() == 0) continue;
				String fileName = ze.getName();
				File newFile = new File(destDirPath + File.separator + fileName);
				System.out.println("Unzipping to "+newFile.getAbsolutePath());
				new File(newFile.getParent()).mkdirs();
				FileOutputStream fos = new FileOutputStream(newFile);
//				System.exit(0);
				int len;
				while ((len = zis.read(buffer)) > 0)
					fos.write(buffer, 0, len);
				fos.close();
			   	zis.closeEntry();
				ze = zis.getNextEntry();
			}
			zis.closeEntry();
			zis.close();
			fis.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public static void traverse(String filePath, ZipEntryVisitor visitor) {
		FileInputStream fis;
		try {
			fis = new FileInputStream(filePath);
			ZipInputStream zis = new ZipInputStream(fis);
			ZipEntry entry = zis.getNextEntry();
			while (entry != null) {
				visitor.visitEntry(entry, zis);
			   	zis.closeEntry();
				entry = zis.getNextEntry();
			}
			zis.closeEntry();
			zis.close();
			fis.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public static void extractFile(String filename, ZipInputStream zis) throws IOException {
		File newFile = new File(filename);
		new File(newFile.getParent()).mkdirs();

		FileOutputStream fos = new FileOutputStream(newFile);
		int len;
		byte[] buffer = new byte[1024];
		while ((len = zis.read(buffer)) > 0)
			fos.write(buffer, 0, len);
		fos.close();
	}

}
