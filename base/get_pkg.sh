#!/bin/bash
set -e

LIST_DIR=${1} # ${1:-./scripts} 

validate_file() {
    local file=${@:1}
    if [ ! -f "$file" ]; then
        echo "Error: File '$file' does not exist"
        exit 1
    fi
    if [ ! -s "$file" ]; then
        echo "Error: File '$file' is empty"
        exit 1
    fi
}


# whitout chroot!
download_with_retry() {
    local file_list=${@:1}
    local max_attempts=3
    local attempt=1

    # Validate the input file
    validate_file "$file_list"
    
    while [ $attempt -le $max_attempts ]; do
        echo "Attempt $attempt of $max_attempts for $file_list"
        
        # -t 5: timeout after 5 seconds
        # --spider: check existence without downloading
        # 2>/dev/null: suppress error messages

        local all_urls_valid=true
        while IFS= read -r url; do
            # Skip empty lines
            [ -z "$url" ] && continue
            if ! wget --timeout=5 --spider "$url" 2>/dev/null; then
                echo "URL check failed for $url"
                all_urls_valid=false
            fi
        done < "$file_list"

        if [ "$all_urls_valid" = true ]; then
            # If all URLs are valid, attempt the actual download
            if wget --timeout=5 -i "$file_list"; then
                echo "Download successful for $file_list"
                return 0
            fi
        else
            echo "One or more URLs in $file_list are invalid or unreachable"
        fi
        
        echo "Download failed (404 or timeout)"
        attempt=$((attempt + 1))
        
        if [ $attempt -le $max_attempts ]; then
            echo "Retrying in 5 seconds..."
            sleep 5
        fi
    done
    
    echo "Failed after $max_attempts attempts"
    exit 1  # Exit with error
}

# Download files from both lists
download_with_retry "$LIST_DIR/pkg_list" # TODO: error if no list or empty
download_with_retry "$LIST_DIR/patches_list"