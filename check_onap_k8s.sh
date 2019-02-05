#!/bin/bash

# get the pod list
echo "List of ONAP pods"
kubectl get pods -n onap
echo "--------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------"

# show deployments
echo "Show ONAP kubernetes deployments"
kubectl get deployments -n onap
echo "--------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------"

# show SVC
echo "Show ONAP kubernetes SVC"
kubectl get svc -n onap
echo "--------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------"

# show ONAP events
echo "Show ONAP kubernetes events"
kubectl get events -n onap
echo "--------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------"

# if all pods in RUNNING state exit 0, else exit 1
nb_pods=$((`kubectl get pods -n onap | grep -v functest | wc -l` -1))
nb_pods_not_running=$((`kubectl get pods -n onap | grep -v Running | grep -v functest | wc -l`-1))

if [ $nb_pods_not_running -ne 0 ]; then
echo "$nb_pods_not_running pods (on $nb_pods) are not in Running state"
   echo "--------------------------------------------------------------------------------------"
   kubectl get pods -n onap |grep -v Running |grep -v functest
   exit 1
else
echo "all pods ($nb_pods) are running well"
   exit 0
fi
