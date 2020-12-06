
import java.util.ArrayList;
import java.util.List;

public class Day2 {
    public static void solve(String puzzleInput) {
        List<Integer> dimensions = new ArrayList<Integer>();

        // Parse file
        StringBuilder currentToken = new StringBuilder();
        for(char c : puzzleInput.toCharArray()) {
            if (c == '\r') continue;
            if (c == 'x' || c == '\n') {
                dimensions.add(Integer.parseInt(currentToken.toString()));
                currentToken.delete(0, currentToken.length());
            }
            else currentToken.append(c);
        }

        // Calculate surface areas
        int totalWrappingPaper = 0;
        int totalRibbon = 0;

        for (int i = 0; i < dimensions.size(); i+=3) {
            int length = dimensions.get(i);
            int width = dimensions.get(i + 1);
            int height = dimensions.get(i + 2);

            int lwArea = length * width;
            int lhArea = length * height;
            int whArea = width * height;

            int surfaceArea = 2 * lwArea + 2 * lhArea + 2 * whArea;
            totalWrappingPaper += surfaceArea + min(lwArea, lhArea, whArea);

            int lwPerim = (length + width) * 2;
            int lhPerim = (length + height) * 2;
            int whPerim = (width + height) * 2;
            int smallestPerimeter = min(lwPerim, lhPerim, whPerim);

            int cubicVolume = length * width * height;

            totalRibbon += smallestPerimeter + cubicVolume;
        }

        System.out.println("Total wrapping paper: " + totalWrappingPaper + " sq ft");
        System.out.println("Total ribbon: " + totalRibbon + " ft");
    }

    public static int min(int a, int b, int c)  {
        int res = a;
        if (b < res) res = b;
        if (c < res) res = c;

        return res;
    }
}
