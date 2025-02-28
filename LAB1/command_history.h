
// command_history.h
#ifndef _COMMAND_HISTORY_H_
#define _COMMAND_HISTORY_H_

#define MAX_COMMANDS 5
#define MAX_COMMAND_LENGTH 100

struct CommandHistory {
    char commands[MAX_COMMANDS][MAX_COMMAND_LENGTH]; // Buffer to store commands
    int count; // Number of commands stored
    int index; // Index for circular buffer
};

void init_command_history(struct CommandHistory *history);

#endif // _COMMAND_HISTORY_H_