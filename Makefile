PROJECT=
USERNAME=
IMAGE=$(USERNAME)/$(PROJECT)
DOCKER=sudo docker

default: dist

dist: dist/$(PROJECT).tar

refs/latest: Dockerfile
	mkdir -p refs
	latest=$$($(DOCKER) build -t $(IMAGE) . |tee /dev/stderr |sed -rn 's/Successfully built (.+)$$/\1/p'); [ -z "$$latest" ] && exit 1; echo "$$latest" >$@;

dist/$(PROJECT).tar: refs/latest
	mkdir -p dist
	sudo docker save $$(cat refs/latest) >dist/$(PROJECT).tar

clean:
	rm -rf refs/*

dist-clean: clean
	rm -rf dist/*

.PHONY: clean dist-clean dist default
