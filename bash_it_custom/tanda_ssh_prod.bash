#!/bin/bash

# Usage:
#   > ssh_prod.sh
#   Please use one of the available types: api app ...
#   > ssh_prod.sh app
#   ** Opens ssh console into random apac app server **
#   > ssh_prod.sh --eu app
#   ** Opens ssh console into random eu app server **

tanda_ssh_prod () {
    ROLE_REGION=apac
    BASTION_REGION=sydney

    if [[ $1 == "--eu" ]]; then
    shift
    ROLE_REGION=eu
    BASTION_REGION=frankfurt
    fi

    type=$1
    available_types=($(aws ec2 describe-instances --profile tanda-${ROLE_REGION}-operations-admin --filters "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[0].Tags[?Key=='type'].Value" | jq '[.[][0]] | unique | .[] | select(. != null)' | xargs | cut -d '"' -f 2))

    if [[ ! " ${available_types[@]} " =~ " ${type} " ]]; then
    echo "Please use one of the available types: ${available_types[@]}"
    exit 1
    fi

    ip=$(aws ec2 describe-instances --profile tanda-${ROLE_REGION}-operations-admin --filters "Name=instance-state-name,Values=running" "Name=tag:type,Values=${type}" --query 'Reservations[*].Instances[0].NetworkInterfaces[0].PrivateIpAddress' | jq '.[]' | sort -R | head -n 1 | cut -d '"' -f 2)
    ssh -A -tt ubuntu@bastion.prod.${BASTION_REGION}.adnat.co ssh -tt ubuntu@${ip}
}