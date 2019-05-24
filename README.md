# Feature Flags in Kubernetes Applications

Feature flags are used to change the behavior of a program at runtime without forcing a 
restart. 

Although they are essential in a native cloud environment, they cannot be implemented 
without significant effort on some platforms. **Kubernetes has made this trivial.** Here 
we will **implement them through labels and annotations**, but you can also implement 
them by connecting directly to the Kubernetes API Server.

![teaser](images/teaser.gif)

In Kubernetes, labels are part of the identity of a resource and can be used through 
selectors. Annotations are similar, but do not participate in the identity of a resource and 
cannot be used to select resources. Nevertheless, they can still be used as feature flags 
to enable/disable application logic. 

## Possible Use Cases

 - turn on/off a specific instance
 - turn on/off profiling of a specific instance
 - change the logging level, to capture detailed logs during a specific event
 - change caching strategy at runtime
 - change timeouts in production
 - toggle on/off some special verification


## How does this work
We’ll use the Kubernetes downward-api to expose labels and annotations directly to our application. We’ll 
end up with two files (`labels` and `annotations`) in `/etc/podinfo`. ( see [here](https://kubernetes.io/docs/tasks/inject-data-application/downward-api-volume-expose-pod-information/#the-downward-api) )

First we add the downward api to spec.volumes. Note that we’re adding both labels and annotations into the same volume. 

## Wrangling labels and annotations from the shell.

```bash 
# Add a label
$ kubectl label pod my-pod-name a-label=foo

# Show labels
$ kubectl get pods --show-labels

# If you only want to show specific labels, use -L=<label1>,<label2>

# Update a label
$ kubectl label pod my-pod-name a-label=bar --override

# Delete a label .Remember the "-" at the end of the line. Required to remove a label
$ kubectl label pod my-pod-name a-label-

# Add an annotation
$ kubectl annotatate pod my-pod-name an-annotation=foo

# Show annotations
$ kubectl describe pod my-pod-name

# Update an annotation
$ kubectl annotation pod my-pod-name an-annotation=foo --override

# Delete an annotation. Remember the "-" at the end of the line. Required to remove a annotation
$ kubectl annotation pod my-pod-name an-annotation-

```
