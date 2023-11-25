#!/bin/bash

# Author: 
# Description: 

getVariables()
{
    echo "INFO: var1=$var1"

}

setVariables()
{
    var1=$0
    packages=("python3-pip" "flask" "flask_cors" "nodejs" "nginx")
}

# Main execution starts here
setVariables 2
getVariables



python3 --version || echo "ERROR: Looks like python is not installed on the server."

