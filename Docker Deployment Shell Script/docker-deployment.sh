#!/usr/bin/bash



clone_app () {
echo "clonning the code"
if [ -d "php-app" ]; then
        echo "Code is already existed - Skipping Clone"
        
else
        git clone https://github.com/alikumbhar/php-app.git || {
	echo "failed to clone the code"
	return 1
	}
fi

}

required_installation(){
	  echo "Installing dependencies..."
  	  sudo apt-get update || {
	  echo "Failed to install dependencies."
	  return 1
	 }
}

required_restart(){
	#if curl -s --unix-socket /var/run/docker.sock http/_ping 2>&1 >/dev/null
	#then
	#          echo "--"
	#else
	#	  sudo systemctl enable docker
	#fi
	#if [ -e /var/run/nginx.pid ]; then
	#	echo "--"	        
	#else
	#	  sudo systemctl enable nginx
	#fi
	echo "system getting refresh"
	sudo chown "$USER" /var/run/docker.sock && sudo chmod 777 /var/run/docker.sock || {
	echo "unable to change ownership - please try again or debug it"
	return 1
	}
	#sudo systemctl enable docker
	#sudo systemctl enable nginx
}

deploy(){
	docker build -t php-app . && docker-compose up -d || {
	echo "Deployment failed"
	return 1
	}
}

#calling all modules
echo "*************** Deployment started *********"
if ! clone_app;
then
	 cd php-app || exit 1
fi
if ! required_installation; then 
	 exit 1
fi
if ! required_restart; 
then
 	 exit 
fi
if ! deploy; 
then
	echo "failed to deploy"
	exit1
fi



echo "************* Deployment END ***************"

