#!/bin/bash

# Author: Ankit Raut 

# Description: 

getVariables()
{
    echo "Path:$path"
    echo "Nginx Path:$nginx_path"
    echo "Backend Port:$backend_port"
    echo "Frontend Port:$frontend_port"
}

setVariables()
{
    #defining directory path.
    # path="/home/ubuntu/Node-Project"
    path="/home/ankitraut0987/Node-Project"
    
    #defining nginx path
    nginx_path="/etc/nginx/sites-enabled"

    #Ports Settings
    backend_port=8000
    frontend_port=3000

}

function terminate_processes(){
    local port_number
    port_number=$1
    PIDS=$(sudo lsof -ti :$port_number)
    for pid in "${PIDS[@]}"
    do
        sudo kill -9 $pid
    done
    echo 0
}

function start_app()
{   local port_number
    local name
    port_number=$1
    name=$2
    # final deployment started
    terminate_processes "$port_number"
    if [[ "$name" == "Backend" ]]
    then
        nohup python3 app.py &
        echo 0 
    elif [[ "$name" == "Frontend"  ]]
    then
        nohup node index.js &
        echo 0 
    else
        echo 1
    fi
}

setVariables
getVariables

echo "*** Deployment Script Initiated ***"
echo "----------------------------------------------------------------------------------"

#Installing Nginx Server
# sudo apt-get install nginx -y 2>/dev/null || echo "Failed to Install Nginx Server"
sudo apt-get install nginx -y || { echo "Failed to Install Nginx Server"; exit 1; }

#Configuring Nginx Server:
sudo rm "$nginx_path/default" || echo "Default Config File Not Found"
cd "$path/Execution-Script/"
sudo cp "default" "$nginx_path/"
sudo systemctl restart nginx

#Installing Node:
sudo apt-get install nodejs -y || echo "Failed to Install NodeJs"

#Installing Python3 PIP:
sudo apt-get install python3-pip -y || echo "Failed to Install Python3 PIP"

#installing all the required Python Packages:
pip install -r requirements.txt

#Backend Deployment
echo "*** Initiated Backend Deployment ***"
#switching to Backend Dir
cd
cd "$path/Backend"
#Calling Start App Function for running the Backend.
start_app "$backend_port" "Backend"
echo "*** Backend Program Deployed Successfully  ***"
echo -e "\n---------------------------------------------------------------------------\n"


#Frontend Deployment
echo "*** Initiated Frontend Deployment ***"
#switching to Frontend Dir
cd 
cd "$path/Frontend/template"
#Calling Start App Function for running the Frontend.
start_app "$frontend_port" "Frontend"
echo "*** Frontend Program Deployed Successfully  ***"
echo -e "\n---------------------------------------------------------------------------\n"

