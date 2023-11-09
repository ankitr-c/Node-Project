step1: sudo apt-get update
step2: sudo apt-get install nginx
step3: sudo nano /etc/nginx/sites-enabled/default
step4:

    add this changes to the default config file

    server {

        listen 80;

        location / {
            proxy_pass http://localhost:3000;
            }

        location /api/ {
            proxy_pass http://localhost:8000;
        }

        }

step5: sudo systemctl enable nginx
step6: sudo systemctl start nginx
step7: cd /Node-Project
step8: ./Start-Script.sh