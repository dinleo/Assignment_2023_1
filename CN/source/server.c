#include <stdio.h>
#include <arpa/inet.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/wait.h>
#include <signal.h>
#include <unistd.h>
#include <fcntl.h>

#define BACKLOG 10
#define BUF_SIZE 1024
#define FILE_NAME 100
#define MAX_CLIENTS 100

int serverSocket;
// File headers
char htmlHeader[] = "HTTP/1.1 200 Ok\r\n" "Content-Type: text/html\r\n\r\n";
char badHtml[] =  "HTTP/1.1 404 Not Found\r\n"
                      "Content-Type: text/html; charset=UTF-8\r\n\r\n"
                      "<!DOCTYPE html>\r\n"
                      "<html><head><title>Bad Request</title>\r\n"
                      "<body>No File.</body>"
                      "</html>";

// Signal handler for Ctrl+C
void handleInterruptSignal(int signal) {
    close(serverSocket);
    exit(0);
}

void sendResponse(int clientSocket, const char* response, size_t responseSize) {
    write(clientSocket, response, responseSize);
}

void sendFileContents(int clientSocket, int fileD, const char* filename) {
    char fileBuffer[BUF_SIZE];
    ssize_t bytesRead;

    while ((bytesRead = read(fileD, fileBuffer, BUF_SIZE)) > 0)
        write(clientSocket, fileBuffer, bytesRead);

    close(fileD);
}

int main(int argc, char *argv[])
{
    // Socket
    int clientSockets[MAX_CLIENTS], clientSocket;
    struct sockaddr_in serverAddress;
    struct sockaddr_in clientAddress;

    // I/O mux
    fd_set readFds, allFds;
    int maxFd, activity;

    // Buffer
    char buffer[BUF_SIZE];
    int bytesRead, fileSize;

    if (argc != 3) {
        // printf("Usage ./server <port> <rootDir>.\n");
        exit(0);
    }

    // signal close
    signal(SIGINT, handleInterruptSignal);

    int PORT = atoi(argv[1]);
    char ROOT[100];
    strcpy(ROOT, argv[2]);

    // Create socket
    // IPv4
    if ((serverSocket = socket(PF_INET, SOCK_STREAM, 0)) == -1) {
        // perror("Socket error");
        exit(0);
    }

    // Create serverAddress
    memset(&serverAddress, 0, sizeof(serverAddress)); // reset
    serverAddress.sin_family = AF_INET; // IPv4
    serverAddress.sin_port = htons(PORT); // PORT set
    serverAddress.sin_addr.s_addr = htonl(INADDR_ANY); // allow any addr

    // Bind serverSocket & serverAddress
    if (bind(serverSocket, (struct sockaddr *)&serverAddress, sizeof(struct sockaddr)) == -1) {
        // perror("Bind error");
        exit(0);
    }

    // Listen
    if (listen(serverSocket, BACKLOG) == -1) {
        // perror("Listen error");
        exit(0);
    }

    int clientAddressSize = sizeof(struct sockaddr_in);

    // Initialize clientSockets array
    for (int i = 0; i < MAX_CLIENTS; i++) {
        clientSockets[i] = 0;
    }

    // Set serverSocket to readFds and maxFd
    FD_ZERO(&readFds);
    FD_SET(serverSocket, &readFds);
    maxFd = serverSocket;

    while (1) {

        allFds = readFds;

        // Wait for activity on any socket
        activity = select(maxFd + 1, &allFds, NULL, NULL, NULL);
        if (activity == -1) {
            // perror("Select error");
            exit(0);
        }

        // New client connection
        if (FD_ISSET(serverSocket, &allFds)) {
            // Accept the new client connection
            if ((clientSocket = accept(serverSocket, (struct sockaddr *)&clientAddress, &clientAddressSize)) == -1) {
                // perror("Failed to accept");
                continue;
            }

            // Add the new clientSocket to the clientSockets array
            for (int i = 0; i < MAX_CLIENTS; i++) {
                if (clientSockets[i] == 0) {
                    clientSockets[i] = clientSocket;
                    break;
                }
            }

            // Add the new clientSocket to readFds
            FD_SET(clientSocket, &readFds);

            // Update the maxFd if necessary
            if (clientSocket > maxFd) {
                maxFd = clientSocket;
            }
        }

        // Check for I/O activity on client sockets
        for (int i = 0; i < MAX_CLIENTS; i++) {
            int sd = clientSockets[i];
            if (FD_ISSET(sd, &allFds)) {
                // Read request
                bzero(buffer, BUF_SIZE);
                bytesRead = read(sd, buffer, BUF_SIZE);
                if (bytesRead < 0)
                    // perror("Reading error");
                    continue;

                // Find filename
                char *startPtr; // Declaration added here
                startPtr = strstr(buffer, "GET /");
                if (startPtr == NULL) {
                    // Invalid request format
                    continue;
                }

                startPtr += 5;  // Move pointer to the beginning of the filename
                char *endPtr;
                endPtr = strchr(startPtr, ' ');
                if (endPtr == NULL) {
                    // Invalid request format
                    continue;
                }

                size_t filenameLength = endPtr - startPtr;
                if (filenameLength >= FILE_NAME) {
                    // File name too long
                    continue;
                }

                char filename[FILE_NAME];
                memcpy(filename, startPtr, filenameLength);
                filename[filenameLength] = '\0';


                // File path
                char path[BUF_SIZE];
                char path_root[BUF_SIZE];
                char path_index[BUF_SIZE];

                getcwd(path_root, BUF_SIZE);

                strcat(path_root, "/");
                strcat(path_root, ROOT);
                strcat(path_root, "/");

                strcpy(path, path_root);
                strcat(path, filename);

                strcpy(path_index, path_root);
                strcat(path_index, "index.html");

                int fd;

                // home
                if (strcmp(filename, "") == 0) {
                    int index_fd = open(path_index, O_RDONLY);
                    sendResponse(sd, htmlHeader, sizeof(htmlHeader) - 1);
                    sendFileContents(sd, index_fd, "index.html");
                }
                // File not exist
                else if ((fd = open(path, O_RDONLY)) == -1) {
                    sendResponse(sd, badHtml, sizeof(badHtml) - 1);
                }
                // File exist
                else {
                    sendResponse(sd, htmlHeader, sizeof(htmlHeader) - 1);
                    sendFileContents(sd, fd, filename);
                }

                close(sd);
                FD_CLR(sd, &readFds);
                clientSockets[i] = 0;
            }
        }
    }

    return 0;
}