public class NestedIfTest {

    public void validate(int x, int y) {
        // Cas positif : détecté par la requête
        if (x > 0) {
            System.out.println("X est positif");
            if (y > 0) { 
                System.out.println("X et Y sont positifs");
            }
        }

        // Cas négatif : non détecté (conditions successives)
        if (x < 0) {
            System.out.println("X est négatif");
        }
        if (y < 0) {
            System.out.println("Y est négatif");
        }
    }
}
