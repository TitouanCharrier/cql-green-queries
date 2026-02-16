package android.view;

class WindowManager {
    public static class LayoutParams {
        public static final int FLAG_KEEP_SCREEN_ON = 128;
    }
}

public class Test {
    void success() {
        int x = WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON;
    }
}
