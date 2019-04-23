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

# show ONAP config maps
echo "Show ONAP kubernetes config maps"
echo "***************************"
kubectl get cm -n onap
echo "------------------------------------------------------------------------"

# show ONAP jobs
echo "Show ONAP kubernetes jobs"
echo "***************************"
kubectl get jobs -n onap
echo "------------------------------------------------------------------------"

# show ONAP statefulsets
echo "Show ONAP kubernetes statefulset"
echo "***************************"
kubectl get sts -n onap
echo "------------------------------------------------------------------------"

# if all pods in RUNNING state exit 0, else exit 1
nb_pods=$((`kubectl get pods -n onap | grep -v functest | wc -l` -1))
nb_pods_not_running=$((`kubectl get pods -n onap | grep -v Running | grep -v functest | wc -l`-1))
list_failed_pods=$(kubectl get pods -n onap |grep -v Running |grep -v functest |grep -v NAME |awk '{print $1}')
nice_list=$(echo $list_failed_pods |sed  -e "s/ /,/g")

# calculate estiamtion of the deployment duration (max age of Running pod)
duration_max=0
time_coeff=1
for duration in $(kubectl get pods -n onap |grep Running | awk {'print $5}');do
    duration_unit=$(echo "${duration: -1}")
    duration_time=$(echo "${duration::-1}")
    if [ "$duration_unit" = "d" ]; then
        time_coeff=86400
    elif [ "$duration_unit" = "h" ]; then
        time_coeff=3600
    elif [ "$duration_unit" = "m" ]; then
        time_coeff=60
    fi
    if [[ $(($duration_time * $time_coeff)) > $duration_max ]]; then
        duration_max=$(($duration_time * $time_coeff))
    fi
done

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
        kubectl logs --all-containers=true -n onap $i
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
echo ">>> List of Failed Pods: [$nice_list]"
echo ">>> Deployment Duration Estimation (s): $duration_max"
echo "------------------------------------------------"
echo "------------------------------------------------"
echo "------------------------------------------------"

exit $code
