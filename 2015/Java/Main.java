
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.nio.file.Files;
import java.nio.file.NoSuchFileException;
import java.nio.file.Paths;
import java.util.Properties;
import java.util.Scanner;

public class Main {

    public static void main(String[] args) {
        Config config = null;
        try {
            config = new Config();
        } catch (Exception exception) {
            exception.printStackTrace();
            return;
        }

        Scanner scanner = new Scanner(System.in);
        while (true) {
            System.out.print("Puzzle day to solve: ");
            String userInput = scanner.nextLine();

            if (userInput.equalsIgnoreCase("exit") ||
                userInput.equalsIgnoreCase("stop"))  {
                return;
            }

            try {
                int dayNumber = Integer.parseInt(userInput);
                String inputFileName = String.format("%02d", dayNumber) + config.fileType();
                String inputFileLocation = Paths.get(config.fileLocation(), inputFileName).toString();
                runPuzzle(dayNumber, inputFileLocation);

            } catch (NumberFormatException ex) {
                System.out.println("Please enter a valid day number");
            }
        }
    }

    public static void runPuzzle(int index, String inputFileLocation) {
        try {
            String inputText = new String(Files.readAllBytes(Paths.get(inputFileLocation)));

            switch (index) {
                case 1:
                    Day1.solve(inputText);
                    break;
                case 2:
                    Day2.solve(inputText);
                    break;
                case 3:
                    Day3.solve(inputText);
                    break;
                case 4:
                    Day4.solve(inputText);
                    break;
                case 5:
                    Day5.solve(inputText);
                    break;
                default:
                    System.out.println("Day not implemented");
            }

        } catch (NoSuchFileException fileNotFoundException) {
            System.out.println("Please provide an input file at " + inputFileLocation);
            return;
        } catch (Exception ex) {
            ex.printStackTrace();
            return;
        }

    }

    public static Properties readConfig() throws Exception {
        try (FileReader reader = new FileReader("config")) {
            Properties properties = new Properties();
            properties.load(reader);

            return properties;
        }
    }
}
