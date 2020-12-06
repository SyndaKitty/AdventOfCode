
public class Day1 {
    public static void solve(String puzzleInput) {
        int floorNumber = 0;
        boolean firstTimeNegative = true;
        int index = 1;
        for(char c : puzzleInput.toCharArray()) {
            if (c == '(') floorNumber++;
            else if (c == ')') floorNumber--;

            if (firstTimeNegative && floorNumber < 0) {
                System.out.println("First negative at index: " + index);
                firstTimeNegative = false;
            }
            index++;
        }

        System.out.println("Final floor: " + floorNumber);
    }
}
