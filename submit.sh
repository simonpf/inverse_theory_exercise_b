#!/bin/bash

echo "Your name:"
read name
echo "Algorithm description:"
read description
echo "File to upload:"
read file

curl -F "user=1" \
     -F "name=${name}" \
     -F "description=${description}" \
     -F "data=@${file}" \
     129.16.35.117:8000/board/

