#!/bin/bash

printf '1' | /home/claudio/Scripts/scriptActions.sh & PID=$!
sleep 5
kill $PID

#Matheus Vinicius G de Godoi
