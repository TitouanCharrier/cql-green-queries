class Test {
    void testMethod(boolean a, boolean b) {
        // Cas positif : if imbriqué
        if (a)
            if (b) {
                System.out.println("imbrique");
            }

        // Cas négatif : if successifs
        if (a) {
            System.out.println("Premier");
        }
        if (b) {
            System.out.println("Second");
        }
    }
}
