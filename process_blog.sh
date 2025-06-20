#!/bin/bash

BLOG_DIR=~/Daily-Blogs
INPUT_FILE="$BLOG_DIR/draft.txt"
DATE=$(date +'%Y-%m-%d')
OUTPUT_FILE="$BLOG_DIR/posts/$DATE-cat-blog.md"

# Step 1: Read from draft
CONTENT=$(cat "$INPUT_FILE")

# Step 2: Call Gemini API to format i

python3 - <<EOF
import os
import google.generativeai as genai

genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

model = genai.GenerativeModel("gemini-2.0-flash")
response = model.generate_content(f\"\"\"Convert the following into a well-formatted markdown blog. Add today's date: $DATE.

{CONTENT}
\"\"\")

with open("$OUTPUT_FILE", "w") as f:
    f.write(response.text)
EOF

# Step 3: Git commit and push
cd "$BLOG_DIR"
git add "$OUTPUT_FILE"
git commit -m "Update blog for $DATE"
git push

