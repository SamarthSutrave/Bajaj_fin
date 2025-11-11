package com.bfh;

import com.bfh.model.GenerateWebhookResponse;
import com.bfh.service.AssignmentService;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@RequiredArgsConstructor
public class AssignmentApplication implements CommandLineRunner {

    private final AssignmentService assignmentService;

    public static void main(String[] args) {
        SpringApplication.run(AssignmentApplication.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        assignmentService.execute();
    }
}
