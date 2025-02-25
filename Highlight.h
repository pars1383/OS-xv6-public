#include "types.h"
#include "fcntl.h"
#include "user.h"

// Define NULL manually for system programming purposes
#define NULL ((void*)0)

// List of keywords to highlight
char *keywords[] = {
    "int", "char", "if", "for", "while", "return", "void"
};
int num_keywords = sizeof(keywords) / sizeof(keywords[0]);
char* strchr_custom(const char* str, int c);
int strcmp_custom(const char *s1, const char *s2);
char* strtok_custom(char* str, const char* delim);
char* strstr_custom(const char *haystack, const char *needle);

// Custom strcmp implementation (compares two strings)
int strcmp_custom(const char *s1, const char *s2) {
    while (*s1 && *s1 == *s2) {
        s1++;
        s2++;
    }
    return (unsigned char)*s1 - (unsigned char)*s2;
}

// Custom strtok implementation (splits the string by spaces)
char* strtok_custom(char* str, const char* delim) {
    static char *last;
    if (str == NULL) str = last;
    
    // Skip any leading delimiters
    while (*str && strchr_custom(delim, *str)) str++;

    if (*str == '\0') return NULL;

    char *start = str;
    // Find the next delimiter
    while (*str && !strchr_custom(delim, *str)) str++;
    
    if (*str) {
        *str = '\0';
        last = str + 1;
    } else {
        last = str;
    }
    return start;
}

// Custom strstr implementation (finds a substring)
char* strstr_custom(const char *haystack, const char *needle) {
    if (!*needle) return (char*)haystack;
    
    while (*haystack) {
        const char *h = haystack;
        const char *n = needle;
        
        while (*h && *n && *h == *n) {
            h++;
            n++;
        }
        
        if (!*n) return (char*)haystack; // Found the substring
        haystack++;
    }
    return NULL;
}

// Custom strchr implementation (finds a character in a string)
char* strchr_custom(const char* str, int c) {
    while (*str) {
        if (*str == (char)c)
            return (char*)str;
        str++;
    }
    return NULL;
}

// Function to check if a token is a keyword
int is_keyword(char *token) {
    for (int i = 0; i < num_keywords; i++) {
        if (strcmp_custom(token, keywords[i]) == 0) {
            return 1; // Token is a keyword
        }
    }
    return 0; // Token is not a keyword
}

// Function to highlight keywords in a line
void highlight_keywords(char *line) {
    char *token;
    int in_comment = 0; // Flag to track if we're inside a #...# block

    // Make a copy of the line to avoid modifying the original
    char line_copy[512]; // Adjust size based on the expected length of the line
    int i = 0;
    while (line[i] != '\0' && i < 512) {
        line_copy[i] = line[i];
        i++;
    }
    line_copy[i] = '\0'; // Null-terminate the copied string

    // Split the line into tokens using spaces as delimiters
    token = strtok_custom(line_copy, " ");
    while (token != NULL) {
        if (in_comment) {
            // Skip tokens inside #...#
            if (strchr_custom(token, '#') != NULL) {
                in_comment = 0; // End of comment block
            }
            token = strtok_custom(NULL, " ");
            continue;
        }

        if (strchr_custom(token, '#') != NULL) {
            in_comment = 1; // Start of comment block
            token = strtok_custom(NULL, " ");
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
        token = strtok_custom(NULL, " ");
    }
    printf(1, "\n"); // Print a newline after the line
}
