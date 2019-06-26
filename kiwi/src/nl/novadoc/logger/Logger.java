package nl.novadoc.logger;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;

public class Logger {
	private static File logFolder;
	private static Logger defaultLogger;
	private static long logFileSize;
	private final File logFile;
	private DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss:SSS");
	public static final int All = 5;
	public static final int DEBUG = 4;
	public static final int INFO = 3;
	public static final int WARN = 2;
	public static final int ERROR = 1;
	public static final int NONE = 0;
	private static long maxFileSize = 1048576;
	private static int maxLogFiles = 5;

	public static final String[] levels = { "None", "Error", "Warn", "Info", "Debug" };

	private int level = DEBUG;
	private static Logger LOGDUMMY;

	static {
		LOGDUMMY = new Logger(null);
		LOGDUMMY.setLevel(NONE);
	}

	public int getLevel() {
		return level;
	}

	public void setLevel(int level) {
		this.level = level;
	}
	
	public void setLevel(String level) {
		level = level.toLowerCase();
		for (int i = 0; i < All; i++)
			if (level.equalsIgnoreCase(levels[i].toLowerCase())) {
				setLevel(i);
				return;
			}
		setLevel(DEBUG);
	}

	public void setRollingLog(long newMaxFileSize, int newMaxLogFiles) {
		maxFileSize = newMaxFileSize;
		maxLogFiles = newMaxLogFiles;
	}

	private Logger(File logFile) {
		defaultLogger = this;
		this.logFile = logFile;
	}

	public static Logger getLogger() {
		if (defaultLogger != null) {
			return defaultLogger;
		}
		return LOGDUMMY;
	}

	public static Logger getLogger(Properties properties) {
		Logger logger = getLogger(
				new File(properties.getProperty("logpath", "c:/log")),
				properties.getProperty("logname", "log"));
		
		logger.setLevel(properties.getProperty("loglevel", "error"));
		
		logger.setRollingLog(
				Long.parseLong(properties.getProperty("logfilesize", "1048576")), 
				Integer.parseInt(properties.getProperty("logfiles", "5")));
		
		return logger;
	}
	
	public static Logger getLogger(String name) {
		try {
			if (!logFolder.exists()) {
				logFolder.mkdirs();
			}
			File file = new File(logFolder, name + ".log");
			file.createNewFile();
			logFileSize = file.length();
			return new Logger(file);
		} catch (Exception e) {
			return LOGDUMMY;
		}
	}

	public static Logger getLogger(File directory, String name) {
		try {
			if (!directory.exists()) {
				directory.mkdirs();
			}
			logFolder = directory;
			File file = new File(logFolder, name + ".log");
			file.createNewFile();
			
			logFileSize = file.length();
			System.out.println("logFileSize: " + logFileSize);

			return new Logger(file);
		} catch (Exception e) {
			return LOGDUMMY;
		}
	}

	public void debug(String TAG, Object ... message) {
		if (this.level >= DEBUG) {
			appendFile(logFile, TAG, DEBUG, message);
		}
	}

	public void info(String TAG, Object ... message) {
		if (this.level >= INFO) {
			appendFile(logFile, TAG, INFO, message);
		}
	}

	public void warn(String TAG, Object ... message) {
		if (this.level >= WARN) {
			appendFile(logFile, TAG, WARN, message);
		}
	}

	public void error(String TAG, Object ... message) {
		if (this.level >= ERROR) {
			appendFile(logFile, TAG, ERROR, message);
		}
	}

	private void appendFile(File file, String TAG, int level, Object ... objects) {
		for(Object object : objects) {
			if(object instanceof Throwable)
				appendThrowable(file, TAG, (Throwable) object, level, false);
			else
				appendFile(file, TAG, object, level, true);
		}
	}
	
	public void appendThrowable(File file, String TAG, Throwable t, int level, boolean header) {
		appendFile(file, TAG, t.toString(), level, header);
		
		for (StackTraceElement stackTraceEl : t.getStackTrace()) {
			appendFile(file, TAG, stackTraceEl.toString(), level, header);
		}
	}

	private boolean appendFile(File file, String TAG, Object object, int level, boolean header) {
		Writer out = null;
		try {
			if(logFileSize > maxFileSize) {
				rotateLogFiles(file);
				logFileSize = 0;
			}
			
			String logText = "";
			if (header)
				logText = format.format(new Date()) + " " + levels[level] + "\t" + TAG;
			
			logText = logText + "\t" + String.valueOf(object) + "\r\n";			
			
			out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file, true), "utf-8"));
			out.write(logText);
			out.flush();
			
			logFileSize = logFileSize + logText.length();
			
			return true;
		} catch (IOException e) {
			return false;
		} finally {
			if (out != null) {
				try {
					out.close();
				} catch (Exception ex) {
					System.err.println(ex.getMessage());
				}
			}
		}
	}
	
	private void rotateLogFiles(File file) {
		try {
			for(int i = maxLogFiles; i >= 0; --i) {
				String fileName = file.getPath()+"."+(i-1);
				
				if(checkFileExists(fileName)) {
					if(i == maxLogFiles)
						deleteFile(fileName);
					else
						renameFile(fileName, file.getPath()+"."+i);
				}
			}

			renameFile(file.getPath(), file.getPath()+".0");
			file.createNewFile();
			
		} catch(Exception e) {
			System.err.println("Could not rotate logfiles");
		}
	}
	
	private void renameFile(String oldFileName, String newFileName) {
		File oldFile = new File(oldFileName);
		File newFile = new File(newFileName);
		
    if(!oldFile.renameTo(newFile))
    	System.out.println("Rename of ("+oldFile.getPath()+") to ("+newFile.getPath()+") failed");
	}
	
	public boolean checkFileExists(String file) {
		File f = new File(file);
		
		if(f.exists() && !f.isDirectory())
			return true;
		
		return false;
	}
	
	public void deleteFile(String file) {
		File f = new File(file);

		if(!f.delete())
			System.err.println("Delete operation of ("+f.getPath()+") failed.");
	}
}
