package com.bfh.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * GenerateWebhookResponse: Response model for webhook generation
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GenerateWebhookResponse {
    private String webhookId;
    private String status;
    private String message;
    private long timestamp;
}
