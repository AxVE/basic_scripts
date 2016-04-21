#!/usr/bin/bash

VERSION="1.0.0"

#Tmux window name
s_name="monitoring"

#Specials commands
watcher=watch -t -c "echo 'USERS:' && users && echo 'JOURNALCTL:' && journalctl --nopager -n 10"

#Launch session
tmux new -s ${s_name} -d

#Set panels
tmux split-window -v -t ${s_name}
tmux split-window -h -t ${s_name}:0.1

tmux send-keys -t ${s_name}:0.0 'htop' C-m
tmux send-keys -t ${s_name}:0.1 'watch -t -c "echo 'USERS:' && users && echo 'JOURNALCTL:' && journalctl --no-pager -n 10"' C-m
tmux send-keys -t ${s_name}:0.2 'dstat' C-m



#Get session
tmux attach -t ${s_name}
