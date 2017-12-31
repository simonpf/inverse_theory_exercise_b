#!/bin/bash

echo "Your name:"
read name
echo "Algorithm description:"
read description
echo "File to upload:"
read file

curl -c cookies.txt -b cookies.txt \
     -F "user=1" \
     -F "name=${name}" \
     -F "description=${description}" \
     -F "data=@${file}" \
     localhost:8000

