#!/bin/bash

show_help() {
  echo "Usage:"
  echo "  ./newpost.sh -t \"Post Title\" [-d YYYY-MM-DD]"
  echo ""
  echo "Options:"
  echo "  -t    Post title (required)"
  echo "  -d    Custom date (format: YYYY-MM-DD)"
  echo "  -h    Show this help message"
}

# Parse arguments
while getopts "t:d:h" opt; do
  case $opt in
    t) TITLE="$OPTARG" ;;
    d) CUSTOM_DATE="$OPTARG" ;;
    h)
      show_help
      exit 0
      ;;
    *)
      show_help
      exit 1
      ;;
  esac
done

# Validate title
if [ -z "$TITLE" ]; then
  echo "Error: Title is required"
  show_help
  exit 1
fi

# Use custom date or today
if [ -n "$CUSTOM_DATE" ]; then
  # Validate format (basic check)
  if ! [[ "$CUSTOM_DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "Error: Date must be in YYYY-MM-DD format"
    exit 1
  fi
  DATE_PATH=$(date -d "$CUSTOM_DATE" +%Y/%m/%d)
else
  DATE_PATH=$(date +%Y/%m/%d)
fi

# Convert title to slug
SLUG=$(echo "$TITLE" \
  | tr '[:upper:]' '[:lower:]' \
  | tr ' ' '-' \
  | tr -cd '[:alnum:]-')

# Create Hugo bundle
hugo new blog/$DATE_PATH/$SLUG/index.md

echo "Created: blog/$DATE_PATH/$SLUG/index.md"
