#!/bin/bash

# --------------------------------------------------
# terminal todo manager (hacker style)
# toggle key: c
# --------------------------------------------------

TODO_FILE="$HOME/.todo_list.txt"
touch "$TODO_FILE"

# terminal control
clear_screen() { printf "\033[2J\033[H"; }
hide_cursor() { printf "\033[?25l"; }
show_cursor() { printf "\033[?25h"; }
move_cursor() { printf "\033[%d;%dH" "$1" "$2"; }

# colors (muted)
DIM="\033[2m"
CYAN="\033[36m"
RESET="\033[0m"

selected=1
total_tasks=0
tasks=()

cleanup() {
    show_cursor
    clear_screen
    exit 0
}
trap cleanup EXIT INT TERM

read_tasks() {
    mapfile -t tasks < "$TODO_FILE"
    total_tasks=${#tasks[@]}
    (( total_tasks == 0 )) && selected=1
    (( selected > total_tasks )) && selected=$total_tasks
    (( selected < 1 )) && selected=1
}

draw_interface() {
    clear_screen
    move_cursor 1 1

    printf "${CYAN}┌────────────────────────────────────────────────────────────────────────────┐${RESET}\n"
    printf "${CYAN}│${RESET} todoctl v1.2                                                             ${CYAN}│${RESET}\n"
    printf "${CYAN}├────────────────────────────────────────────────────────────────────────────┤${RESET}\n"

    if (( total_tasks == 0 )); then
        printf "${CYAN}│${RESET} ${DIM}no tasks${RESET}                                                                  ${CYAN}│${RESET}\n"
    else
        for i in "${!tasks[@]}"; do
            num=$((i + 1))
            line="${tasks[i]}"

            status="${line:0:3}"
            text="${line:4}"

            cursor="  "
            (( num == selected )) && cursor="► "

            printf "${CYAN}│${RESET} ${cursor}%s %s" "$status" "$text"

            pad=$((74 - ${#text}))
            printf "%*s" "$pad" ""
            printf "${CYAN}│${RESET}\n"
        done
    fi

    printf "${CYAN}├────────────────────────────────────────────────────────────────────────────┤${RESET}\n"
    printf "${CYAN}│${RESET} controls: ↑/k ↓/j  c check  a add  d delete  q quit                         ${CYAN}│${RESET}\n"
    printf "${CYAN}└────────────────────────────────────────────────────────────────────────────┘${RESET}\n"
}

add_task() {
    move_cursor $((total_tasks + 7)) 3
    printf "new task > "
    show_cursor
    read -r task
    hide_cursor
    [[ -n "$task" ]] && echo "[ ] $task" >> "$TODO_FILE"
}

toggle_task() {
    (( total_tasks == 0 )) && return

    line=$(sed -n "${selected}p" "$TODO_FILE")

    if [[ "$line" == "[ ]"* ]]; then
        sed -i "${selected}s/^\[ \]/[x]/" "$TODO_FILE"
    elif [[ "$line" == "[x]"* ]]; then
        sed -i "${selected}s/^\[x\]/[ ]/" "$TODO_FILE"
    fi
}

delete_task() {
    (( total_tasks == 0 )) && return
    sed -i "${selected}d" "$TODO_FILE"
    (( selected > 1 )) && ((selected--))
}

main() {
    hide_cursor

    while true; do
        read_tasks
        draw_interface

        read -rsn1 key
        case "$key" in
            q) break ;;
            k) (( selected > 1 )) && ((selected--)) ;;
            j) (( selected < total_tasks )) && ((selected++)) ;;
            c) toggle_task ;;
            a) add_task ;;
            d) delete_task ;;
            $'\033')
                read -rsn2 key
                [[ "$key" == "[A" ]] && (( selected > 1 )) && ((selected--))
                [[ "$key" == "[B" ]] && (( selected < total_tasks )) && ((selected++))
                ;;
        esac
    done
}

# cli mode
if [[ $# -eq 0 ]]; then
    main
else
    case "$1" in
        add)
            shift
            [[ -z "$*" ]] && { echo "usage: todoctl add \"task\""; exit 1; }
            echo "[ ] $*" >> "$TODO_FILE"
            ;;
        list)
            nl -w2 -s'. ' "$TODO_FILE"
            ;;
        done)
            [[ -z "$2" ]] && { echo "usage: todoctl done <number>"; exit 1; }
            sed -i "${2}s/^\[ \]/[x]/" "$TODO_FILE"
            ;;
        *)
            echo "usage: todoctl [add|list|done]"
            ;;
    esac
fi
