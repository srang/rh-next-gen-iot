# Electrical Submersible Pump Condition Monitoring and Forecasting
## Next Gen Technologies at Scale

Using cutting edge technologies, we will be building an IOT edge computing solution that will monitor health of ESP
to identify system stress and optimize hardware longevity.

## Intro

More than 90% of producing oil wells require some form of artificial lift to bring oil or gas to the surface. This is 
common for mature fields when the reservoir pressure has been depleted through production. ESP (Electrical Submersible 
Pump) is the  second-most common artificial lift method worldwide with more than 100k ESPs in operation. ESP operate in 
a hostile environment and face  challenges like high-gas volume wells, produced solids, and high-temperature and 
corrosive environments.

Monitoring vital statistics of ESP helps reduce the risk of debilitating problems that lower life its  expectancy. 
Real-time monitoring of ESP can help increase the ROI of the multi-billion dollar investment in a well; e.g. for a 1000 
pumps producing ~200 BOE/day (barrel of oil equivalent), could cost ~$20M/year in lost production. Real time pump 
surveillance can not only monitor how ESP is behaving but also find well problems that are unrelated to the pump itself.

Basic ESP system comprises of an electric motor, a protector, gas separator, multi-stage centrifugal-pump,  power cable,
motor controller, transformers and a power source. Sensors in downhole transmit streams of data on pressure, 
temperature, vibration, current and voltage back to the supervisory control and data acquisition (SCADA) systems.

The key to successful monitoring is to know which parameters to measure and how to effectively interpret this data. The 
complex interactions between the wellbore and an ESP can be analyzed using trend plots to tell story of pump or Gradient 
Traverse plot analysis to highlight the hierarchy of measured parameters and show how these parameters can be used to 
validate well and ESP performance.

Vibration and temperature are two of the many parameters available to assist with the diagnosis of ESP systems in order 
to optimise runlife. Like any other variable, these should always be used in conjunction with other downhole and surface 
measurements in order to obtain a complete picture of the pump and well performance.

Downhole rotating systems, such as ESPs, are complex systems where vibration can be introduced in many ways. 
In the case of an ESP, vibration can be induced due to imbalance in the pump or motor, wear in the pump diffusers or 
impellers, manufacturing problems, electrical power instability or as result of the fluids being produced through the 
pump.

For this lab, we’ll use simple rules on vibration and temperature data to establish leading indicators of failure and 
prevent the pump from operating in an undesirable condition.

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
