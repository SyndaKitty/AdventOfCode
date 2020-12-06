
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class Day4 {
    public static void solve(String puzzleInput) {
        for (int i = 0;; i++) {
            String secretKey = puzzleInput + i;
            MessageDigest messageDigest = null;
            try {
                messageDigest = MessageDigest.getInstance("MD5");
            } catch (NoSuchAlgorithmException e) {
                e.printStackTrace();
                return;
            }

            byte[] hash = messageDigest.digest(secretKey.getBytes());

            if (hash[0] == 0 && hash[1] == 0 && hash[2] == 0) {
                System.out.println(i);
                return;
            }
        }
    }
}
