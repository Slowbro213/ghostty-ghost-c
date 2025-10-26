#include <stdio.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include "../lib/animation.h"

#define FRAME_DELAY_US 33333  // 30 FPS

int main() {
    struct winsize w;
    int i = 0;

    while (1) {
        ioctl(STDOUT_FILENO, TIOCGWINSZ, &w);
        int term_rows = w.ws_row;
        int term_cols = w.ws_col;

        int top_padding = (term_rows - FRAME_HEIGHT) / 2;

        printf("\033[H\033[J");

        for (int t = 0; t < top_padding; t++) {
            printf("\n");
        }

        for (int j = 0; j < FRAME_HEIGHT; j++) {
            int line_len = 0;
            const char* ptr = ANIMATION_DATA[i][j];
            int left_padding = (term_cols - line_len) >> 2;
            while (*ptr) {
                if (*ptr == '\033') {
                    while (*ptr && *ptr != 'm') ptr++;
                    if (*ptr) ptr++;
                    continue;
                }
                line_len++;
                ptr++;
            }
            for (int s = 0; s < left_padding; s++) printf(" ");
            printf("%s\n", ANIMATION_DATA[i][j]);
        }

        usleep(FRAME_DELAY_US);
        i = (i + 1) % NUM_FRAMES;
    }

    return 0;
}

