
import java.io.FileReader;
import java.io.IOException;
import java.util.Properties;

/**
 * Include a config class just as a self test.. unnecessarily complicated :)
 */
public class Config {

    final String[] expectedKeys = { "fileLocation", "fileType" };

    Properties properties;

    public Config() throws Exception {
        try (FileReader reader = new FileReader("config")) {
            properties = new Properties();
            properties.load(reader);

            for(String key : expectedKeys) {
                if (!properties.containsKey(key)) {
                    throw new Exception("Expected key \"" + key + "\" in config file");
                }
            }
        }
    }

    public String fileLocation() {
        return properties.getProperty("fileLocation");
    }

    public String fileType() {
        return properties.getProperty("fileType");
    }
}
