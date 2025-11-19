#!/bin/bash

cd Security

# Array of PDFs to compress
pdfs=(
  "AppSec Australia Sydney 2022 - Client-side Security.pdf"
  "BSides Sydney 2022 - Attacking the Front-end.pdf"
  "CYBAR-2020.pdf"
  "Cyber Security Interviews and Beyond - WSU.pdf"
  "DevSecCon 2022 - Securing Our Supply Chain Using SLSA.pdf"
  "Linktree Talk - Client-side Security-2022.pdf"
  "Ruxmon Oct 2022 Talk - Client-side Security.pdf"
)

echo "Starting PDF compression..."
for file in "${pdfs[@]}"; do
  if [ -f "$file" ]; then
    original_size=$(stat -f%z "$file")
    echo "Compressing: $file ($(echo "scale=2; $original_size / 1048576" | bc) MB)"
    
    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile="/tmp/compressed_${RANDOM}.pdf" "$file"
    
    if [ -f "/tmp/compressed_${RANDOM}.pdf" ]; then
      compressed_size=$(stat -f%z "/tmp/compressed_${RANDOM}.pdf")
      reduction=$(( (original_size - compressed_size) * 100 / original_size ))
      mv "/tmp/compressed_${RANDOM}.pdf" "$file"
      printf "  ✓ Reduced to %.2f MB (Reduction: %d%%)\n" \
        $(echo "scale=2; $compressed_size / 1048576" | bc) \
        $reduction
    fi
  fi
done

echo "Compression complete!"
