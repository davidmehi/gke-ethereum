# gke-ethereum
GKE config for deploying ethereum for the Holesky network

Execution and Consensus are in one pod

Validator is in another pod.

The service exposes the beacon API.  Get the IP of the service to use in the Validator config before deploying.  In the future: use service name instead of IP

Disclaimer: Use for development purposes only.  Not production tested


