#!/bin/bash

# Function to display manual page
display_manual() {
  cat <<EOF
internsctl(1)                   User Commands                  internsctl(1)

NAME
  internsctl - Custom Linux command for operations

SYNOPSIS
  internsctl [OPTION]... [COMMAND]...

DESCRIPTION
  internsctl is a custom Linux command that provides various functionalities
  for system information and user management.

OPTIONS
  --help            display help information
  --version         display command version

COMMANDS
  cpu getinfo       get CPU information
  memory getinfo    get memory information
  user create       create a new user
  user list         list all regular users
  user list --sudo-only   list users with sudo permissions
  file getinfo      get information about a file

EOF
}

# Function to display help information
display_help() {
  cat <<EOF
Usage: internsctl [OPTION]... [COMMAND]...

OPTIONS
  --help            display this help and exit
  --version         output version information and exit

COMMANDS
  cpu getinfo       get CPU information
  memory getinfo    get memory information
  user create       create a new user
  user list         list all regular users
  user list --sudo-only   list users with sudo permissions
  file getinfo      get information about a file

EXAMPLES
  internsctl cpu getinfo
  internsctl memory getinfo
  internsctl user create <username>
  internsctl user list
  internsctl user list --sudo-only
  internsctl file getinfo [--size|--permissions|--owner|--last-modified] <file-name>
EOF
}

# Function to display version information
display_version() {
  echo "internsctl v0.1.0"
}

# Function to get CPU information
get_cpu_info() {
  lscpu
}

# Function to get memory information
get_memory_info() {
  free
}

# Function to create a new user
create_user() {
  if [ -z "$1" ]; then
    echo "Error: Username not provided."
    exit 1
  fi

  sudo useradd -m "$1"
}

# Function to list users
list_users() {
  if [ "$1" == "--sudo-only" ]; then
    getent passwd | cut -d: -f1,3,7 | awk -F: '$2 >= 1000 {print $1 "\t" $3}' | grep -vE "\t0$"
  else
    getent passwd | cut -d: -f1
  fi
}

# Function to get file information
get_file_info() {
  if [ -z "$2" ]; then
    echo "Error: File name not provided."
    exit 1
  fi

  file="$2"

  case "$1" in
    --size|-s)
      stat -c%s "$file"
      ;;
    --permissions|-p)
      stat -c%a "$file"
      ;;
    --owner|-o)
      stat -c%U "$file"
      ;;
    --last-modified|-m)
      stat -c%y "$file"
      ;;
    *)
      echo "Error: Invalid option."
      exit 1
      ;;
  esac
}

# Main script
case "$1" in
  --help)
    display_help
    ;;
  --version)
    display_version
    ;;
  cpu)
    case "$2" in
      getinfo)
        get_cpu_info
        ;;
      *)
        echo "Error: Invalid CPU command."
        exit 1
        ;;
    esac
    ;;
  memory)
    case "$2" in
      getinfo)
        get_memory_info
        ;;
      *)
        echo "Error: Invalid memory command."
        exit 1
        ;;
    esac
    ;;
  user)
    case "$2" in
      create)
        create_user "$3"
        ;;
      list)
        list_users "$3"
        ;;
      *)
        echo "Error: Invalid user command."
        exit 1
        ;;
    esac
    ;;
  file)
    case "$2" in
      getinfo)
        get_file_info "$3" "$4"
        ;;
      *)
        echo "Error: Invalid file command."
        exit 1
        ;;
    esac
    ;;
  *)
    echo "Error: Invalid command."
    exit 1
    ;;
esac

