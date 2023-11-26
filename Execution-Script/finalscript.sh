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
    return 0
}

function start_app()
{   local port_number
    local name
    port_number=$1
    name=$2
    # final deployment started
    status=$(delete_processes "$port_number")
    if (( $status!=0 ))
    then
        return 1
    fi
    if [[ "$name" == "Backend" ]]
    then
        nohup python3 app.py &
        return 0 
    elif [[ "$name" == "Frontend"  ]]
    then
        nohup node index.js &
        return 0 
    else
        return 1
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
