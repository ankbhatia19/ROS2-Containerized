NAME = ros2

# The following variables are used to control the automatic generation of the docker container
CREATED = $$(docker images -q $(NAME) 2> /dev/null)
RUNNING = $$(docker ps -q -f name=$(NAME))
EXISTS = $$(docker ps -aq -f name=$(NAME))

# Mount points for X authorization
XSOCK = /tmp/.X11-unix
XAUTH = /tmp/.docker.xauth

# Default rule for creating and running the container
default:
	@if [ ! $(CREATED) ]; then \
		$(MAKE) dockerfile; \
	fi
	@if [ ! $(RUNNING) ]; then \
		$(MAKE) container; \
	fi
	@$(MAKE) terminal


dockerfile:
	docker build -t $(NAME) .

xsetup:
	@touch $(XAUTH)
	@xauth nlist $(DISPLAY) | sed -e 's/^..../ffff/' | xauth -f $(XAUTH) nmerge -

container: clean xsetup
	@if [ $(RUNNING) ]; then \
		printf "\n$(NAME) container already running: Use <make terminal> to enter container.\n\n"; \
		exit 1; \
	fi
	@docker run -dt \
		--privileged \
    		-p $1:8800 \
    		--rm \
		--shm-size="2g" \
    		-e XAUTHORITY=$(XAUTH) \
		-e DISPLAY=$(DISPLAY) \
    		-e QT_GRAPHICSSYSTEM=native \
		-v $(XSOCK):$(XSOCK):rw \
		-v $(XAUTH):$(XAUTH):rw \
		-v $(PWD)/workspaces:/root/workspaces \
    		-v /tmp/.gazebo:/root/.gazebo \
		--net host \
    		--name $(NAME) \
    		$(NAME)
	@printf "\n$(NAME) container running: Use <make terminal> to enter container.\n\n"

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
	@if [ $(EXISTS) ]; then \
		printf "\nDeleting $(NAME) container.\n"; \
		docker rm $(NAME); \
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
	@printf "make dockerfile	> Builds the $(NAME) container. Run after editing the Dockerfile.\n"
	@printf "make container	> Creates a new $(NAME) container, and keeps it running in the background.\n"
	@printf "make terminal	> Enters the $(NAME) container from a new terminal.\n"
	@printf "make clean	> Stops and removes the $(NAME) container.\n"
	@printf "make deepclean	> Deletes old versions of the $(NAME) container. May help recover some storage.\n"
	@printf "make status	> Prints out a status message indicating whether the $(NAME) container is running.\n"
	@printf "make help	> Prints out this help message.\n"
	@printf "\n"
