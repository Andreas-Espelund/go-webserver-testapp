local argokit = import 'argokit/jsonnet/argokit.libsonnet';
local BaseApp = {
  spec: {
    port: 8080,
    image: 'go-http-server',
    replicas: 1,
  },
};

[
  BaseApp + argokit.Application('test-application') {
    metadata+: {
      namespace: 'devex',
    },
  },
]
