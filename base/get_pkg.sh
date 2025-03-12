#!/bin/bash
set -e

# whitout chroot!
download_with_retry() {
    local file_list=$1
    local max_attempts=3
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        echo "Attempt $attempt of $max_attempts for $file_list"
        
        # -t 5: timeout after 5 seconds
        # --spider: check existence without downloading
        # 2>/dev/null: suppress error messages
        if wget --timeout=5 --spider -i "$file_list" 2>/dev/null; then
            # If spider check passes, do the actual download
            if wget --timeout=5 -i "$file_list"; then
                echo "Download successful"
                return 0
            fi
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
download_with_retry "pkg_list"
download_with_retry "patches_list"