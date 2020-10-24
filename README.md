# Example Voting App

Example Voting App adapted for Crafteo Training

## Running the stack

### Initialize Docker Swarm

You have two hosts at your disposal: `host1` and `host2` with Docker installed. We'll create a Docker Swarm with 2 nodes.

Commands to run on `host1`:
```sh
# ssh into host1:
#
#   ssh ubuntu@ssh ubuntu@host1.traning.crafteo.io
#
# Init Docker swarm from host1
# Keep outputed token!
docker swarm init
```

Commands to run on `host2`:
```sh
# ssh into host1:
#
#   ssh ubuntu@ssh ubuntu@host2.traning.crafteo.io
#
docker swarm join [TOKEN]
```

### Run the stack

```sh
# ssh into host1:
#
#   ssh ubuntu@ssh ubuntu@host1.traning.crafteo.io
#

# Clone Voting App repo
git clone https://github.com/PierreBeucher/example-voting-app.git
cd example-voting-app

# Run the stack
docker stack up voting-app -c docker-stack.yml
```

App should be accessible (make sure to replace `host1` by your actual hostname):

- Vote: http://host1.training.crafteo.io:8080
- Result: http://host2.training.crafteo.io:8081
