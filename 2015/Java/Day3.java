
import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

public class Day3 {
    public static void solve(String puzzleInput) {
        Set<Vector2> visitedCoords = new HashSet<>();

        Vector2 currentCoordSanta = new Vector2(0, 0);
        Vector2 currentCoordRobot = new Vector2(0, 0);
        visitedCoords.add(new Vector2(0, 0));

        boolean santa = true;

        int housesVisited = 1;
        for (char c : puzzleInput.toCharArray()) {

            int dx = 0, dy = 0;
            if (c == '<') dx = -1;
            else if (c == '>') dx = 1;
            else if (c == '^') dy = 1;
            else if (c == 'v') dy = -1;

            Vector2 currentCoord;
            if (santa) currentCoord = currentCoordSanta = currentCoordSanta.add(dx, dy);
            else currentCoord = currentCoordRobot = currentCoordRobot.add(dx, dy);

            if (!visitedCoords.contains(currentCoord)) {
                housesVisited++;
            }
            visitedCoords.add(currentCoord);

            santa = !santa;
        }

        System.out.println("Unique houses visited: " + housesVisited);
    }
}

class Vector2 {
    int x;
    int y;

    public Vector2(int x, int y) {
        this.x = x;
        this.y = y;
    }

    public Vector2 add(int dx, int dy) {
        return new Vector2(x + dx, y + dy);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Vector2 vector2 = (Vector2) o;
        return x == vector2.x &&
                y == vector2.y;
    }

    @Override
    public int hashCode() {
        return Objects.hash(x, y);
    }
}
