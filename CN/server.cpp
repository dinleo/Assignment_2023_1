#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/time.h>

#define MAX_CLIENTS 10
#define MAX_BUFFER 1024

int main() {
    int server_socket, client_socket;
    struct sockaddr_in server_addr, client_addr;
    socklen_t client_len;
    char buffer[MAX_BUFFER];

    // Create server socket
    server_socket = socket(AF_INET, SOCK_STREAM, 0);
    if (server_socket < 0) {
        perror("Failed to create socket");
        exit(EXIT_FAILURE);
    }

    // Set server address
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(8080);

    // Bind server socket
    if (bind(server_socket, (struct sockaddr*)&server_addr, sizeof(server_addr)) < 0) {
        perror("Failed to bind socket");
        exit(EXIT_FAILURE);
    }

    // Listen for incoming connections
    if (listen(server_socket, 5) < 0) {
        perror("Failed to listen on socket");
        exit(EXIT_FAILURE);
    }

    printf("Server started. Waiting for connections...\n");

    fd_set read_fds;
    int max_fd, activity, i;
    int client_sockets[MAX_CLIENTS] = {0};

    while (1) {
        // Clear the socket set and add server socket
        FD_ZERO(&read_fds);
        FD_SET(server_socket, &read_fds);
        max_fd = server_socket;

        // Add client sockets to the socket set
        for (i = 0; i < MAX_CLIENTS; i++) {
            client_socket = client_sockets[i];
            if (client_socket > 0) {
                FD_SET(client_socket, &read_fds);
            }
            if (client_socket > max_fd) {
                max_fd = client_socket;
            }
        }

        // Wait for activity on any of the sockets
        activity = select(max_fd + 1, &read_fds, NULL, NULL, NULL);
        if ((activity < 0) && (errno != EINTR)) {
            printf("Select error");
        }

        // Check for new connection
        if (FD_ISSET(server_socket, &read_fds)) {
            client_len = sizeof(client_addr);
            client_socket = accept(server_socket, (struct sockaddr*)&client_addr, &client_len);
            if (client_socket < 0) {
                perror("Failed to accept connection");
                exit(EXIT_FAILURE);
            }

            // Add new client socket to the array
            for (i = 0; i < MAX_CLIENTS; i++) {
                if (client_sockets[i] == 0) {
                    client_sockets[i] = client_socket;
                    break;
                }
            }
        }

        // Check for I/O activity on client sockets
        for (i = 0; i < MAX_CLIENTS; i++) {
            client_socket = client_sockets[i];
            if (FD_ISSET(client_socket, &read_fds)) {
                memset(buffer, 0, MAX_BUFFER);

                // Receive request from client
                ssize_t read_size = recv(client_socket, buffer, MAX_BUFFER, 0);
                if (read_size == 0) {
                    // Connection closed by client
                    close(client_socket);
                    client_sockets[i] = 0;
                } else if (read_size < 0) {
                    perror("Failed to receive data from client");
                } else {
                    // Process the received request
                    // Assume the request is a GET request
                    if (strncmp(buffer, "GET", 3) == 0) {
                        // Send HTTP response to client
                        char response[] = "HTTP/1.1 200 OK\r\n"
                                          "Content-Type: text/plain\r\n"
                                          "\r\n"
                                          "Hello, World!";
                        if (send(client_socket, response, strlen(response), 0) < 0) {
                            perror("Failed to send response to client");
                        }
                    }
                }
            }
        }
    }

    // Close server socket
    close(server_socket);

    return 0;
}

