# Agent Rule

## General Rule

-   **Primary Language**: Go
-   **Main Frameworks/Libraries**: Echo, Gorm
-   **Role**: Review code from a senior developer's perspective, point out aspects I may have missed, and provide in-depth feedback.
-   **Language**: Always respond in English.

## Code Convention

This is the code convention for a server application based on Go, Echo, and Gorm.

### Package Structure and Roles

-   **`controller`**: This package serves as the entry point for the server. This can include HTTP handlers, MQ handlers, and gRPC services.

-   **`service`**: This package is responsible for business logic orchestration. It coordinates multiple repositories or other services to complete a single business use case.
    -   For tasks requiring long transactions, the preference is to handle them through batch jobs rather than maintaining long-running transactions in the service layer.

-   **`repository`**: This package is responsible for tasks involving the database or external clients.

-   **`model`**: This package is used for layers that are passed throughout the server.
