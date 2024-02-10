#!/bin/bash

# Define color codes
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# oooooooooooo ooooooooo.   ooooo      ooooooooo.   ooooo     ooo  .oooooo..o ooooo   ooooo 
# `888'     `8 `888   `Y88. `888'      `888   `Y88. `888'     `8' d8P'    `Y8 `888'   `888' 
#  888          888   .d88'  888        888   .d88'  888       8  Y88bo.       888     888  
#  888oooo8     888ooo88P'   888        888ooo88P'   888       8   `"Y8888o.   888ooooo888  
#  888    "     888          888        888          888       8       `"Y88b  888     888  
#  888       o  888          888        888          `88.    .8'  oo     .d8P  888     888  
# o888ooooood8 o888o        o888o      o888o           `YbodP'    8""88888P'  o888o   o888o 
#
# Author: Valmar
# Github: github.com/calvalmar                                                                                        
#
# This script is used to add, commit, tag, and push changes to a Git repository.                                                          
#
# Usage: ./push.sh <tag_name> <source_files> [-f, --format] [-m, --message] [-p, --push] [-a, --all] [-h, --help]

# ====================================================================================================== #


# Function to generate a random number
generate_random_number()
{
    od -N3 -An -i /dev/urandom
}

# Function to display an error message and exit the program
exit_with_error()
{
    echo "Error: $1"
    exit 1
}

# Function to display help
display_help()
{
    echo -e "${GREEN}Usage: $0 <tag_name> <source_files> [-f, --format] [-m, --message] [-p, --push] [-a, --all] [-h, --help]${NC}"
    echo ""
    echo "Options:"
    echo "-f, --format    Format the source code with clang-format"
    echo "-m, --message   Specify the commit message"
    echo "-p, --push      Push the changes to the remote repository"
    echo "-a, --all       Perform all operations (add, commit, tag, push, and push --tags)"
    echo "-h, --help      Display this help message"
    echo ""
    echo "Examples:"
    echo "$0 tag test.py -f" 
    echo "$0 tag test.py -m \"Initial commit\""
    echo "$0 tag test.py -p"
    echo "$0 tag test.py -a"
    echo "$0 tag test.py -f -m \"Initial commit\" -p"
    exit 0
}

# Initialize variables
format_code=false
push_changes=false
commit_message="Code formatting"
do_all=false

# Check arguments
for arg in "$@"
do
    case $arg in
        -h|--help)
            display_help
            ;;
        -f|--format)
            format_code=true
            shift
            ;;
        -m|--message)
            commit_message="$2"
            shift
            shift
            ;;
        -p|--push)
            push_changes=true
            shift
            ;;
        -a|--all)
            do_all=true
            shift
            ;;
        *)
            ;;
    esac
done

if [ "$#" -lt 2 ]; then
    exit_with_error "Usage: $0 <tag_name> <source_files> [-f, --format] [-m, --message] [-p, --push] [-a, --all] [-h, --help]"
fi

# Generate a random number
random_number=$(generate_random_number)

# Format the source code with clang-format if the option is enabled
if [ "$format_code" = true ]; then
    if ! clang-format -i "$2"; then
        exit_with_error "[-] Failed to format the source code."
    fi
fi

# Get the directory of the source file
source_dir=$(dirname '$2')

# Delete object files (.o)
find "$source_dir" -name "*.o" -type f -delete

# Delete temporary editor files (*.swp)
find "$source_dir" -name ".*.swp" -type f -delete

# ====================================================================================================== #

# Add modified files to Git tracking
if [ "$push_changes" = false ] || [ "$do_all" = true ]; then
    git add -f * || exit_with_error "[-] Failed to add files to git."

    # Commit with an explicit message
    git commit -m "$commit_message" || exit_with_error "[-] Failed to commit changes."

    # Create a Git tag with the given name and the random number as a message
    git tag -a $1 -m "$random_number" || exit_with_error "[-] Failed to create a git tag."
    echo -e "${GREEN}Git tag created: $1${NC}"
fi

# Push the changes and tags if the push option is enabled or if the all option is enabled
if [ "$push_changes" = true ] || [ "$do_all" = true ]; then
    git push || exit_with_error "[-] Failed to push changes."
    git push --follow-tags || exit_with_error "[-] Failed to push tags."
fi

# ====================================================================================================== #

clear

echo -e "${GREEN}Git log:${NC}"
git log | head -3
echo ""
echo -e "${GREEN}Done !${NC}"
echo ""
