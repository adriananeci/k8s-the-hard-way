#!/usr/bin/env bash


gcp_scp_multiple()
{
    declare -a pids=()
    instances=(${1//,/ })
    shift
    for instance in ${instances[@]}; do
        gcp_scp ${instance} ${@} &
        pids+=($!)
    done

    copy_done=true

    # Wait for all child processes to finish
    for (( i=0; i<${#pids[@]}; i++ ));
    do
        if wait ${pids[$i]}; then
                echo "SCP to ${instances[$i]} success!"
        else
                echo "SCP to ${instances[$i]} failed!"
                copy_done=false
        fi
    done

    if ${copy_done}; then
        echo -e "SCP completed!"
    else
        echo -e "Some SCP was not complete!"
    fi
}

gcp_scp()
{
    instance=${1}
    shift
    gcloud compute scp ${@} ${instance}:~/
}


gcp_ssh_multiple()
{
    declare -a pids=()
    instances=(${1//,/ })
    for instance in ${instances[@]}; do
        gcp_ssh ${instance} "${2}" &
        pids+=($!)
    done

    ssh_done=true

    # Wait for all child processes to finish
    for (( i=0; i<${#pids[@]}; i++ ));
    do
        if wait ${pids[$i]}; then
                echo "SSH command on ${instances[$i]} successfully executed!"
        else
                echo "SSH command on ${instances[$i]} failed!"
                ssh_done=false
        fi
    done

    if ${copy_done}; then
        echo -e "SSH completed!"
    else
        echo -e "Some SSH was not complete!"
    fi
}

gcp_ssh()
{
    gcloud compute ssh ${1} --command "${2}"
}