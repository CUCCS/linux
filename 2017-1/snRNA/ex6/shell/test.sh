#!/bin/bash 

FTP_USER=virtua1l
path=/home/${FTP_USER}

if [[ ! -d "$path" ]]; then
   echo -e " no file"
fi

echo "end"
