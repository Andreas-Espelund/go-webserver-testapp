IMAGE_NAME = go-http-server
KIND_CLUSTER = skiperator

.PHONY: all build-image run-image load-image convert-json remove-array apply

# 1. Build image if main.go or Dockerfile changes
go-http-server: main.go Dockerfile
	docker build -t $(IMAGE_NAME) .

# 2. Load image into kind if image is rebuilt
loaded-image: go-http-server
	kind load docker-image $(IMAGE_NAME) --name $(KIND_CLUSTER)
	touch loaded-image  # Mark as up-to-date

# 3. Convert Jsonnet to JSON
app.json: app.jsonnet
	jsonnet app.jsonnet > app.json

# 4. Remove array
app.single.json: app.json
	jq '.[0]' app.json > app.single.json

# 5. Apply everything if main.go (or anything upstream) changes
apply: loaded-image app.single.json
	kubectl apply -f app.single.json

# Utility targets
run-image:
	docker run -p 8080:8080 $(IMAGE_NAME)

# Clean up generated files
clean:
	rm -f go-http-server loaded-image app.json app.single.json
