
IMAGE=garethr/app
BUILD=docker build --target
RUN=docker run --rm -it
DOCS_PORT=8000
APP_PORT=5000
TESTS=structure-tests.yaml

all: verify dev

verify: lint test validate check

lint:
	type Dockerfile | docker run --rm -i hadolint/hadolint

test:
	$(BUILD) test -t $(IMAGE) .

check:
	$(BUILD) check -t $(IMAGE) .

shell:
	$(BUILD) shell -t $(IMAGE) .
	$(RUN) $(IMAGE)

docs:
	$(BUILD) docs -t $(IMAGE) .
	$(RUN) -p $(DOCS_PORT):8000 $(IMAGE)

dev:
	$(BUILD) dev -t $(IMAGE) .
	$(RUN) -p $(APP_PORT):5000 $(IMAGE)

prod:
	$(BUILD) prod -t $(IMAGE) .
	$(RUN) -p $(APP_PORT):5000 $(IMAGE)

validate:
	$(BUILD) prod -t $(IMAGE) .
	$(RUN) -v /var/run/docker.sock:/var/run/docker.sock -v $(CURDIR)/$(TESTS):/tmp/tests.yaml gcr.io/gcp-runtimes/container-structure-test test --image $(IMAGE) --config /tmp/tests.yaml


.PHONY: all verify lint test check shell dev prod validate
