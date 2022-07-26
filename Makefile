NAME = ros2
DOCKERFILE = Dockerfile

# The following variables are used to control the automatic generation of the docker container
CREATED = $$(docker images -q $(NAME) 2> /dev/null)
RUNNING = $$(docker ps -q -f name=$(NAME))

# Mount points for X authorization
XSOCK = /tmp/.X11-unix
XAUTH = /tmp/.docker.xauth

# Mount point for docker socket
DOCKER_SOCK = /var/run/docker.sock

# Default rule for creating and running the container
default: dockerfile container terminal


dockerfile:
	@if [ ! $(CREATED) ]; then \
		docker build -f $(DOCKERFILE) -t $(NAME) .; \
	fi

rebuild:
	@docker build -f $(DOCKERFILE) -t $(NAME) .

xsetup:
	@touch $(XAUTH)
	@xauth nlist $(DISPLAY) | sed -e 's/^..../ffff/' | xauth -f $(XAUTH) nmerge -

container: xsetup
	@if [ ! $(RUNNING) ]; then \
		docker run -dt \
    	-p $1:8800 \
    	--rm \
		--shm-size="2g" \
    	-e XAUTHORITY=$(XAUTH) \
		-e DISPLAY=$(DISPLAY) \
    	-e QT_GRAPHICSSYSTEM=native \
		-v $(XSOCK):$(XSOCK):rw \
		-v $(XAUTH):$(XAUTH):rw \
		-v $(DOCKER_SOCK):$(DOCKER_SOCK):rw \
		-v $(PWD)/../../../dVRL_private:/root/code/dVRL_private \
		-p 19997:19997 \
    	--name $(NAME) \
    	$(NAME); \
	fi
	

terminal:
	@if [ ! $(RUNNING) ]; then \
		printf "\n$(NAME) container not running: Use <make container> to initialize.\n\n"; \
		exit 1; \
	fi
	@printf "\nEntering $(NAME) container...\n\n"
	@docker exec -it $(NAME) bash

clean:
	@if [ $(RUNNING) ]; then \
		printf "\nStopping $(NAME) container.\n"; \
		docker stop $(NAME); \
	fi

deepclean: clean
	@docker system prune -af

status:
	@printf "\n$(NAME) container status:\n"
	@printf "\tCreated: $(CREATED)\n"
	@printf "\tRunning: $(RUNNING)\n"
	@printf "\nA valid ID will be printed if the container is fully operational.\n\n"

help:
	@printf "\n"
	@printf "make		> Creates container if it does not exist, then creates a new terminal.\n"
	@printf "make rebuild	> Rebuilds the $(NAME) container. Run after editing the Dockerfile.\n"
	@printf "make container	> Creates a new $(NAME) container, and keeps it running in the background.\n"
	@printf "make terminal	> Enters the $(NAME) container from a new terminal.\n"
	@printf "make clean	> Stops and removes the $(NAME) container.\n"
	@printf "make deepclean	> Deletes old versions of the $(NAME) container. May help recover some storage.\n"
	@printf "make status	> Prints out a status message indicating whether the $(NAME) container is running.\n"
	@printf "make help	> Prints out this help message.\n"
	@printf "\n"
