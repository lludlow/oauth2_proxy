NAME = madbuda/oauth2_proxy
VERSION = 2.2.0

all: build

build:
	docker build -t $(NAME):$(VERSION) .

test:
	docker run $(NAME):$(VERSION) --version

tag_latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest

release: test tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	curl -H "Content-Type: application/json" --data '{"build": true};' -X POST https://registry.hub.docker.com/u/madbuda/oauth2_proxy/trigger/afc76465-b173-48f6-81b3-a6260d24430c/
