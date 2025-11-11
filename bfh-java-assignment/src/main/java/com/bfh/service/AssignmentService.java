package com.bfh.service;

import com.bfh.config.AppProps;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

/**
 * AssignmentService: Main service for the Bajaj Finserv Health assignment
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AssignmentService {
    
    private final AppProps appProps;
    
    /**
     * Execute the assignment logic
     */
    public void execute() {
        log.info("Starting AssignmentService execution...");
        log.info("App Name: {}", appProps.getName());
        log.info("Registration No: {}", appProps.getRegNo());
        log.info("Email: {}", appProps.getEmail());
        log.info("Output Directory: {}", appProps.getOutputDir());
        log.info("Auto Submit: {}", appProps.isAutoSubmit());
        
        if (appProps.getFinalQuery() != null && !appProps.getFinalQuery().isEmpty()) {
            log.info("Using provided SQL query from configuration");
            log.debug("Query: {}", appProps.getFinalQuery());
        } else {
            log.info("Attempting to read SQL query from ./solution.sql file");
        }
        
        log.info("AssignmentService execution completed successfully!");
    }
}
