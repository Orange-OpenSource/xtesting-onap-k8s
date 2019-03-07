#!/bin/bash

echo "------------------------------------------------------------------------"
echo "--------------------  ONAP Check kubernetes ----------------------------"
echo "------------------------------------------------------------------------"

code=0

# get the pod list
echo "List of ONAP pods"
echo "*****************"
kubectl get pods -n onap

# show deployments
echo "Show ONAP kubernetes deployments"
echo "********************************"
kubectl get deployments -n onap
echo "------------------------------------------------------------------------"

# show SVC
echo "Show ONAP kubernetes SVC"
echo "************************"
kubectl get svc -n onap
echo "------------------------------------------------------------------------"

# show ONAP events
echo "Show ONAP kubernetes events"
echo "***************************"
kubectl get events -n onap
echo "------------------------------------------------------------------------"

# if all pods in RUNNING state exit 0, else exit 1
nb_pods=$((`kubectl get pods -n onap | grep -v functest | wc -l` -1))
nb_pods_not_running=$((`kubectl get pods -n onap | grep -v Running | grep -v functest | wc -l`-1))

if [ $nb_pods_not_running -ne 0 ]; then
echo "$nb_pods_not_running pods (on $nb_pods) are not in Running state"
echo "---------------------------------------------------------------------"
    kubectl get pods -n onap |grep -v Running |grep -v functest
    echo "--------------------------------------------------------------------"
    echo "Describe non running pods"
    echo "*************************"
    for i in $(kubectl get pods -n onap |grep -v Running |grep onap |awk '{print $1}');do
        echo "****************************************************************"
        kubectl describe pod $i -n onap
    done
    code=1
else
    echo "all pods ($nb_pods) are running well"
fi

echo "------------------------------------------------"
echo "------- ONAP kubernetes tests ------------------"
echo "------------------------------------------------"
echo ">>> Nb Pods: $nb_pods"
echo ">>> Nb Failed Pods: $nb_pods_not_running"
echo "------------------------------------------------"
echo "------------------------------------------------"
echo "------------------------------------------------"

exit $code
