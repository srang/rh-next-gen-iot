# Electrical Submersible Pump Condition Monitoring and Forecasting
## Next Gen Technologies at Scale

Using cutting edge technologies, we will be building an IOT edge computing solution that will monitor health of ESP sensors
to identify system stress and optimize hardware longevity.

## Initial Seeding

Resources (both cluster and local) can be seeded using the script `./bin/system-int.sh`

To get started with the lab, let's deploy the prepared resources to our cluster:

```
$ ./bin/start.sh
```

This will import the necessary imagestreams, bootstrap our cluster and local environment, build our source code, stage 
our OpenShift application manifests, and start building our images.

## Rules

Rules are deployed on the KIE Server, and can be authored in an IDE or in the web-based Decision Central Workbench.
Helper scripts have been provided for deploying the prepared rules (included already by running `./bin/start.sh`) at 
`./bin/deploy-rules.sh`, and the authoring environment can be bootstrapped by running `./bin/deploy-author.sh`.

## Routes

[Camel-K](https://github.com/apache/camel-k) is an integration framework for running lightweight Camel routes on Kubernetes
or OpenShift. A helper script for deploying changes to the `./message-ingestion/Streams-Reader.java` camel route to the
cluster has been provided in `./bin/deploy-routes.sh`
