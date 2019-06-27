package zandbak.util;

import java.io.IOException;
import java.util.Properties;

import org.apache.log4j.Appender;
import org.apache.log4j.ConsoleAppender;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.apache.log4j.PatternLayout;
import org.apache.log4j.RollingFileAppender;

public class Log {

    private static final String DEFAULT_LOG_LEVEL = "ERROR";
	private static final String DEFAULT_LOG_FORMAT = "%d %p %F:%L - %m%n";
	
    private static String logLevel;
    private static String logFile;
    private static PatternLayout layout;

    public static void setLog(Properties properties) {
        logLevel = properties.getProperty("LogLevel");
        String logFormat = properties.getProperty("LogFormat");
        layout = new PatternLayout(logFormat);
        logFile = properties.getProperty("LogFile");

        if (layout != null)
            logFormat = layout.getConversionPattern();
    }

    public static Logger getLogger(Class<?> clazz) {

        Logger logger = Logger.getLogger(clazz);
        logger.setLevel(Level.toLevel(logLevel == null ? DEFAULT_LOG_LEVEL : logLevel));

        if (layout == null)
            layout = new PatternLayout(DEFAULT_LOG_FORMAT);

        logger.removeAllAppenders();

        Appender appender = null;
        if (logFile == null)
            appender = new ConsoleAppender(layout);
        else
	        try {
	            appender = new RollingFileAppender(layout, logFile);
	        } catch (IOException e) {
	            appender = new ConsoleAppender(layout);
	        }
        logger.addAppender(appender);

        return logger;
    }

}
