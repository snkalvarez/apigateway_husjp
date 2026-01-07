package com.hujsp.apigategay;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

@Component
public class StartupLogger {

    @Value("${app.version}")
    private String version;

    @EventListener(ApplicationReadyEvent.class)
    public void logVersion() {
        System.out.println("Running application version: v" + version);
    }
}