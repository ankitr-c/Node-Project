#!/bin/bash

# Author: Ankit Raut 
# Description: 
getVariables()
{
    echo "INFO: var1=$var1"
}

setVariables()
{
    #defining directory path.
    path="/home/ubuntu/Node-Project"
    #path="/home/ankitraut0987/Node-Project"
    
    #defining nginx path
    nginx_path="/etc/nginx/sites-enabled"

    #Ports Settings
    backend_port=8000
    frontend_port=3000

}

function check_processes()
{
    local port_number
    port_number=$1
    #checking if the process already exists on given port number.
    echo "--- Checking For The Processes On Port No. $port_number ---"
    process_list=($(sudo lsof -i :$port_number | awk '{print $2}'))
    process_name=($(sudo lsof -i :$port_number | awk '{print $9}'))
    limit=${#process_list[@]}

    #if processes found
    if (( $limit > 1 ))
    then 
        echo "Following Are The Processes On Port No. $port_number::"
        for((idx=1; idx<limit; idx++))
        do
            echo "-PID: ${process_list[$idx]} | P_Name: ${process_name[$idx]}"
        done
        # requesting permission from user to kill all the permissions
        echo "### Required Permissions To Kill All Processes ###"
        read -p "Enter [Y] to agree or [Any Char] to exit the process: " ch

        if [[ "$ch" == [Yy] ]]
        then
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
            echo "--- All The Processes Terminated Successfully ---"

        else
            return 1
        fi
    else
        # no proceess running on given port
        echo "No Processes Found On Port No. $port_number"
    fi

}

function start_app()
{   local port_number
    local name
    port_number=$1
    name=$2
    echo "$port_number $name"
    # final deployment started
    status=$(check_processes "$port_number")
    if (( $status==1 ))
    then
        return 1
    fi
    if [[ "$name" == "Backend" ]]
    then
        echo i am into backend
        nohup python3 app.py & 
    elif [[ "$name" == "Frontend"  ]]
    then
        echo i am into frontend
        nohup node index.js & 
    else
        return 1
    fi
}


echo "*** Deployment Script Initiated ***"
echo "----------------------------------------------------------------------------------"

#Installing Nginx Server
# sudo apt-get install nginx -y 2>/dev/null || echo "Failed to Install Nginx Server"
sudo apt-get install nginx -y || { echo "Failed to Install Nginx Server"; exit 1; }

#Configuring Nginx Server:
sudo rm "$nginx_path/default" 2>/dev/null || echo "Default Config File Not Found"
cd "$path/Execution-Script/"
sudo cp "default" "$nginx_path/"
sudo systemctl restart nginx

#Installing Node:
sudo apt-get install nodejs -y 2>/dev/null || echo "Failed to Install NodeJs"

#Installing Python3 PIP:
sudo apt-get install python3-pip -y 2>/dev/null || echo "Failed to Install Python3 PIP"

#installing all the required Python Packages:
pip install -r requirements.txt

#Backend Deployment
echo "*** Initiated Backend Deployment ***"
#switching to Backend Dir
cd
cd "$path/Backend"
#Calling Start App Function for running the Backend.
status=$( start_app "$backend_port" "Backend" )
if (( $status==1 ))
then
    echo "*** Some Error With Backend, Exiting The Script ***"
    exit 1
else
    echo "*** Backend Program Deployed Successfully  ***"
    echo -e "\n---------------------------------------------------------------------------\n"
fi


#Frontend Deployment
echo "*** Initiated Frontend Deployment ***"
#switching to Frontend Dir
cd 
cd "$path/Frontend/template"
#Calling Start App Function for running the Frontend.
status=$( start_app "$frontend_port" "Frontend" )

if (( $status==1 ))
then
    echo "*** Some Error With Frontend, Exiting The Script ***"
    exit 1
else
    echo "*** Frontend Program Deployed Successfully  ***"
    echo -e "\n---------------------------------------------------------------------------\n"
fi
