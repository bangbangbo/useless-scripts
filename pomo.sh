#!/bin/bash

# advanced pomodoro timer
# interactive timer with big ascii display

# terminal control
clear_screen() { printf "\033[2J\033[H"; }
hide_cursor() { printf "\033[?25l"; }
show_cursor() { printf "\033[?25h"; }
move_cursor() { printf "\033[%d;%dH" "$1" "$2"; }

# colors
CYAN="\033[36m"
WHITE="\033[37m"
DIM="\033[2m"
RESET="\033[0m"

# state
WORK_TIME=${1:-25}
current_seconds=0

# cleanup
cleanup() {
    show_cursor
    clear_screen
    exit 0
}
trap cleanup EXIT INT TERM

# big ascii numbers
draw_digit() {
    local digit=$1
    local row=$2
    
    case $digit in
        0)
            case $row in
                1) echo ":::::'#####:::" ;;
                2) echo "::::'##.. ##::" ;;
                3) echo ":::'##:::: ##:" ;;
                4) echo "::: ##:::: ##:" ;;
                5) echo "::: ##:::: ##:" ;;
                6) echo ":::. ##:: ##::" ;;
                7) echo "::::. #####:::" ;;
                8) echo ":::::.....::::" ;;
            esac ;;
        1)
            case $row in
                1) echo "::::::'##:::" ;;
                2) echo "::::'####:::" ;;
                3) echo "::::.. ##:::" ;;
                4) echo ":::::: ##:::" ;;
                5) echo ":::::: ##:::" ;;
                6) echo ":::::: ##:::";;
                7) echo "::::'######:" ;;
                8) echo "::::......::" ;;
            esac ;;
        2)
            case $row in
                1) echo ":'#######::" ;;
                2) echo "'##.... ##:" ;;
                3) echo "..::::: ##:" ;;
                4) echo ":'#######::" ;;
                5) echo "'##::::::::" ;;
                6) echo " ##::::::::" ;;
                7) echo " #########:" ;;
                8) echo ".........::" ;;
            esac ;;
        3)
            case $row in
                1) echo ":'#######::" ;;
                2) echo "'##.... ##:" ;;
                3) echo "..::::: ##:" ;;
                4) echo ":'#######::" ;;
                5) echo ":...... ##:" ;;
                6) echo "'##:::: ##:" ;;
                7) echo ". #######::" ;;
                8) echo ":.......:::" ;;
            esac ;;
        4)
            case $row in
                1) echo ":::'##::::'##:" ;;
                2) echo ":::'##::::'##:" ;;
                3) echo ":::'##::::'##:" ;;
                4) echo ":::. ########:" ;;
                5) echo ":::......::'##" ;;
                6) echo ":::......::'##" ;;
                7) echo ":::......::'##" ;;
                8) echo "::::......::::" ;;
            esac ;;
        5)
            case $row in
                1) echo ":::'########::" ;;
                2) echo ":::'##....::::" ;;
                3) echo ":::'##::::::::" ;;
                4) echo ":::'#######:::" ;;
                5) echo ":::......:'##:" ;;
                6) echo ":::'##::::'##:" ;;
                7) echo ":::. #######::" ;;
                8) echo "::::......::::" ;;
            esac ;;
        6)
            case $row in
                1) echo ":::'########::" ;;
                2) echo ":::'##::::::::" ;;
                3) echo ":::'##::::::::" ;;
                4) echo ":::'#######:::" ;;
                5) echo ":::'##::::'##:" ;;
                6) echo ":::'##::::'##:" ;;
                7) echo ":::. #######::" ;;
                8) echo "::::......::::" ;;
            esac ;;
        7)
            case $row in
                1) echo ":::. ########:" ;;
                2) echo ":::......::'##" ;;
                3) echo ":::.....::'##:" ;;
                4) echo ":::....::'##::" ;;
                5) echo ":::...::'##:::" ;;
                6) echo ":::...::'##:::" ;;
                7) echo ":::...::'##:::" ;;
                8) echo "::::......::::" ;;
            esac ;;
        8)
            case $row in
                1) echo "::::'#######::" ;;
                2) echo ":::'##::::'##:" ;;
                3) echo ":::'##::::'##:" ;;
                4) echo ":::. #######::" ;;
                5) echo ":::'##::::'##:" ;;
                6) echo ":::'##::::'##:" ;;
                7) echo ":::. #######::" ;;
                8) echo "::::......::::" ;;
            esac ;;
        9)
            case $row in
                1) echo "::::'#######::" ;;
                2) echo ":::'##::::'##:" ;;
                3) echo ":::'##::::'##:" ;;
                4) echo ":::. ########:" ;;
                5) echo ":::......:'##:" ;;
                6) echo ":::......:'##:" ;;
                7) echo ":::. #######::" ;;
                8) echo "::::......::::" ;;
            esac ;;
        :)
            case $row in
                1) echo "::::::::::::" ;;
                2) echo "::::'##:::::" ;;
                3) echo "::::::::::::" ;;
                4) echo "::::::::::::" ;;
                5) echo "::::'##:::::" ;;
                6) echo "::::::::::::" ;;
                7) echo "::pomov1.0::" ;;
                8) echo "::::......::" ;;
            esac ;;
    esac
}

# draw title
draw_title() {
    move_cursor 3 35
}

# draw time display
draw_time() {
    local minutes=$((current_seconds / 60))
    local seconds=$((current_seconds % 60))
    
    local m1=$((minutes / 10))
    local m2=$((minutes % 10))
    local s1=$((seconds / 10))
    local s2=$((seconds % 10))
    
    for row in {1..8}; do
        move_cursor $((6 + row)) 10
        printf "${CYAN}%s %s %s %s %s${RESET}" \
            "$(draw_digit $m1 $row)" \
            "$(draw_digit $m2 $row)" \
            "$(draw_digit : $row)" \
            "$(draw_digit $s1 $row)" \
            "$(draw_digit $s2 $row)"
    done
}

# draw interface
draw_interface() {
    clear_screen
    draw_title
    draw_time
}

# notification
notify() {
    local message=$1
    if command -v notify-send &> /dev/null; then
        notify-send "pomo" "$message"
    fi
}

# timer logic
run_timer() {
    local total_time=$((WORK_TIME * 60))
    current_seconds=$total_time
    
    while [ $current_seconds -gt 0 ]; do
        draw_interface
        sleep 1
        ((current_seconds--))
    done
    
    # session complete
    current_seconds=0
    draw_interface
    move_cursor 16 35
    printf "${WHITE}session complete${RESET}"
    notify "work session complete"
    sleep 2
}

# main
main() {
    hide_cursor
    run_timer
    cleanup
}

main