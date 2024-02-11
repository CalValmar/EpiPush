# EpiPush

EpiPush is a bash script that simplifies the process of adding, committing, tagging, and pushing changes to EPITA's forge.

## Usage

```sh
./push.sh <tag_name> <source_files> [-f, --format] [-m, --message] [-p, --push] [-a, --all] [-h, --help]
```

## Arguments
- tag_name: The name of the tag to be created.
- source_files: The files to be added to the commit.


## Options
[!] If no options are specified, the script will add, commit, and tag the source files.
- -f, --format: Format the source files using clang-format, adding, committing, and tagging the source files
- -m, --message: Specify the commit message, adding, committing, and tagging the source files
- -p, --push: Push the changes to the remote repository.
- -a, --all: Add, commit, tag, push and push --tags all changes in the repository.
- -h, --help: Display the help message.

### Beware
- The tag name must be unique.
- The source files must exist in the repository.
- Installing clang-format is required to use the -f option.
- You may only use one of the -f, -m, -p, -a options at a time.

## Examples
- ./push.sh tag_1 main.py -f
- ./push.sh tag_2 main.py -m "Add main function"
- ./push.sh tag_3 main.py -p
- ./push.sh tag_4 main.py -a

## Author
- Valmar (Me)