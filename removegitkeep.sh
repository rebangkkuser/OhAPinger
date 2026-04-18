#!/bin/sh

echo "Enter the directory where you want to remove all .gitkeep files:"
read target_dir

if [ ! -d "$target_dir" ]; then
    echo "Error: Directory does not exist."
        exit 1
        fi

        gitkeep_files=$(find "$target_dir" -type f -name ".gitkeep")

        if [ -z "$gitkeep_files" ]; then
            echo "No .gitkeep files found in '$target_dir'."
                exit 0
                fi

                echo "Found the following .gitkeep files:"
                echo "$gitkeep_files"

                echo "Are you sure you want to delete ALL of them? (y/N):"
                read confirm

                case "$confirm" in
                  [Yy]* )
                      for file in $gitkeep_files; do
                            rm -v "$file"
                                done
                                    echo "All .gitkeep files deleted successfully."
                                        ;;
                                          * )
                                              echo "Operation cancelled."
                                                  ;;
                                                  esac
