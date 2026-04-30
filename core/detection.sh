#!/usr/bin/env bash

detect_os() {
    case "$(uname -s)" in
        Linux*)
            if [[ -d "/data/data/com.termux" ]]; then
                echo "android"
            else
                echo "linux"
            fi
            ;;
        Darwin*) echo "darwin" ;;
        *) echo "unknown" ;;
    esac
}

get_package_manager() {
    case "$(detect_os)" in
        android) echo "pkg" ;;
        linux)   echo "apt" ;;
        darwin)  echo "brew" ;;
        *)       echo "unknown" ;;
    esac
}