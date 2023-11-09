#!/bin/bash


function check_processes()
{
    local port_number
    port_number=$1
    #checking if the process already exists on given port number.
    echo "--- Checking For The Processes On Port No. $port_number ---"
    process_list=($(sudo lsof -i :$port_number | awk '{print $2}'))
    process_name=($(sudo lsof -i :$port_number | awk '{print $9}'))
    limit=${#process_list[@]}

    sleep 1

    #if processes found
    if (( $limit > 1 ))
    then 
        echo "Following Are The Processes On Port No. $port_number::"
        for((pid=1; pid<limit; pid++))
        do
            echo "-PID: ${process_list[$pid]} | P_Name: ${process_name[$pid]}"
        done
        # requesting permission from user to kill all the permissions
        echo "### Required Permissions To Kill All Processes ###"
        read -p "Enter [Y] to agree or [Any Char] to exit the process: " ch

        if [[ "$ch" == [Yy] ]]; then
            echo "--- Permission Granted ---"
            echo $port_number
            PIDS=$(sudo lsof -ti :$port_number)
            echo "${PIDS[@]}"
            #killing all the processes on given port number
            for pid in "${PIDS[@]}"
            do
                sudo kill -9 $pid
                echo "Killed Process with PID: $pid"
            done
            sleep 1
            echo "--- All The Processes Terminated Successfully ---"

        else
            # permissions denied by user script exits.
            echo "*** Exiting The Script ***"
            exit 0
        fi
    else
        sleep 1
        # no proceess running on given port
        echo "No Processes Found On Port No. $port_number"
    fi

}
function start_app()
{   local port_number
    # local command
    local name
    port_number=$1
    # command=$2
    name=$2
    echo "$port_number $name"
    # final deployment started
    echo "--- Deploying The $name Program  ---"
    check_processes $port_number
    if [[ "$name" == "Backend" ]]
    then
        echo i am into backend
        nohup python3 app.py & 
    elif [[ "$name" == "Frontend"  ]]
    then
        echo i am into frontend
        nohup node index.js & 
    else
        echo "*** Some Error With $name, Exiting The Script ***"
        exit 0
    fi
    sleep 1
    echo "*** $name Program Deployed Successfully  ***"
    #deployed sucessfully

}
function main()
{

    echo "*** Deployment Script for Node Application Initiated ***"
    echo "----------------------------------------------------------------------------------"

    #defining directory path.
    path="/home/ubuntu/Node-Project"

    sleep 1

    #deployment of backend
    echo "*** Initiated Backend Deployment ***"
    backend_port=8000
    # backend_command="nohup python3 app.py &"
    #switching to Backend Dir
    cd
    cd "$path/Backend"
    # start_app $backend_port $backend_command "Backend"
    start_app $backend_port "Backend"
    sleep 1

    #deployment of frontend
    echo "*** Initiated Frontend Deployment ***"
    frontend_port=3000
    # frontend_command="nohup node index.js &"
    #switching to Frontend Dir
    cd 
    cd "$path/Frontend/template"
    # start_app $frontend_port $frontend_command "Frontend"
    start_app $frontend_port "Frontend"
    sleep 1

    #application deployed sucessfully
    echo "Your Project Is Up And Running"

}

main

