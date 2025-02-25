#include "types.h"
#include "user.h"
#include "fcntl.h"

// List of keywords to highlight
char *keywords[] = {
    "int", "char", "if", "for", "while", "return", "void"
};
int num_keywords = sizeof(keywords) / sizeof(keywords[0]);

// Function to check if a token is a keyword
int is_keyword(char *token) {
    for (int i = 0; i < num_keywords; i++) {
        if (strcmp(token, keywords[i]) == 0) {
            return 1; // Token is a keyword
        }
    }
    return 0; // Token is not a keyword
}

// Function to highlight keywords in a line
void highlight_keywords(char *line) {
    char *token;
    int in_comment = 0; // Flag to track if we're inside a #...# block

    // Split the line into tokens using spaces as delimiters
    token = strtok(line, " ");
    while (token != NULL) {
        if (in_comment) {
            // Skip tokens inside #...#
            if (strstr(token, "#") != NULL) {
                in_comment = 0; // End of comment block
            }
            token = strtok(NULL, " ");
            continue;
        }

        if (strstr(token, "#") != NULL) {
            in_comment = 1; // Start of comment block
            token = strtok(NULL, " ");
            continue;
        }

        // Check if the token is a keyword
        if (is_keyword(token)) {
            // Print keyword in blue using ANSI escape codes
            printf(1, "\x1b[34m%s\x1b[0m ", token);
        } else {
            // Print normal text
            printf(1, "%s ", token);
        }

        // Get the next token
        token = strtok(NULL, " ");
    }
    printf(1, "\n"); // Print a newline after the line
}