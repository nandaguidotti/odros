#!/bin/bash

printf '1' | /home/claudio/Scripts/scriptActions.sh & PID=$!
sleep 5
kill $PID
printf '5' | /home/claudio/Scripts/scriptActions.sh & PID=$!
sleep 40
kill $PID

#Matheus Vinicius G de Godoi
