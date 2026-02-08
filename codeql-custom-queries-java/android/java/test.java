package com.example;

import android.webkit.WebSettings;

public class WebViewTest {
    public void configure(WebSettings settings) {
        // Cas détecté par la règle (ligne 8)
        settings.setJavaScriptEnabled(true); 

        // Cas ignoré par la règle (ligne 11)
        settings.setJavaScriptEnabled(false);
    }
}
