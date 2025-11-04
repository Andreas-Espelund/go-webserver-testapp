local argokit = import '../argokit/v2/jsonnet/argokit.libsonnet';
local app = argokit.appAndObjects.application;

app.new(name='test-application', port=8080, image='go-http-server')
