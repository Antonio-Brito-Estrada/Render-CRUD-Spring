package com.practicaswrest;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@SpringBootApplication
@ComponentScan(basePackages = "com.practicaswrest")
@EnableTransactionManagement
public class PracticaswrestApplication {

    public static void main (String[] args) {
        System.setProperty("server.port", "8096");
        SpringApplication.run(PracticaswrestApplication.class, args);
    }

}
