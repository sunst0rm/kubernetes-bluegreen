### Description

This is a simple proof of concept made to understand how blue/green deployment works in Kubernetes, using Redis image.

### What is happening and how to use?

All is done with `script.sh` so make it executable first `chmod +x script.sh` and then run `./script.sh`.

What script does:

1. Launches two deployments: blue - older image version, green - newer image version, service which points to blue thanks to label `version: v1`
2. Forwards port 6379 locally
3. Shows currently used Redis image version.
4. Modifies service label to `version: v2`
5. Stops and forwards service once again
6. Shows that current image version is newer so service points to green deployment now.
7. Removes all objects and forwarding

![](https://github.com/sunst0rm/kubernetes-bluegreen/blob/master/kube.gif)

### Author

Jarosław Kozioł
[@linkedin](https://www.linkedin.com/in/jaroslaw-koziol/)
