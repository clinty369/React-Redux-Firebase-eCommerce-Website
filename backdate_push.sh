#!/bin/bash

# CONFIGURATION
REMOTE_URL="https://github.com/clinty369/React-Redux-Firebase-eCommerce-Website.git"
START_DATE="2021-05-01"
END_DATE="2022-05-01"

# STEP 1: Initialize fresh Git repo
git init
git remote add origin "$REMOTE_URL"
git branch -M main

# STEP 2: Collect all files (exclude .git)
mapfile -t FILES < <(find . -type f ! -path "./.git/*")
TOTAL_FILES=${#FILES[@]}
INDEX=0

# STEP 3: Backdate and commit files
CURRENT_DATE="$START_DATE"
while [[ "$CURRENT_DATE" < "$END_DATE" && $INDEX -lt $TOTAL_FILES ]]; do
  # Randomly skip some days (0 = skip, 1 = commit)
  SKIP=$(( RANDOM % 3 ))
  if [[ $SKIP -eq 0 ]]; then
    echo "Skipping $CURRENT_DATE"
  else
    COMMITS=$(( (RANDOM % 3) + 1 ))  # 1 to 3 commits max
    for ((i = 1; i <= COMMITS && INDEX < TOTAL_FILES; i++)); do
      FILE="${FILES[$INDEX]}"
      CLEAN_NAME="${FILE#./}"

      echo "[$CURRENT_DATE] Committing: $CLEAN_NAME"
      export GIT_AUTHOR_DATE="$CURRENT_DATE 12:0$i:00"
      export GIT_COMMITTER_DATE="$CURRENT_DATE 12:0$i:00"

      git add -f "$FILE"
      git commit -m "$CLEAN_NAME"
      ((INDEX++))
    done
  fi

  # Advance to next day
  CURRENT_DATE=$(date -I -d "$CURRENT_DATE + 1 day")
done

# STEP 4: Push to GitHub
git push -u origin main
