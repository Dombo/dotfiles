#!/bin/bash

# Usage:
#   > tanda_ssh_env.sh
#   Please use one of the available types: api app ...
#   > tanda_ssh_env.sh app
#   ** Opens ssh console into random apac staging app server **
#   > tanda_ssh_env.sh --prod app
#   ** Opens ssh console into random apac prod app server **
#   > tanda_ssh_env.sh --prod --eu app
#   ** Opens ssh console into random eu app server **

helper_join_by() { local IFS="$1"; shift; echo "$*"; }

tanda_ssh_env () {
    ROLE_REGION=apac
    BASTION_REGION=sydney
    BASTION_ENV=staging
    PROFILE_ENV=staging

    if [[ $1 == "--prod" ]]; then
        shift
        BASTION_ENV=prod
        PROFILE_ENV=""
    fi

    if [[ $1 == "--eu" ]]; then
        shift
        ROLE_REGION=eu
        BASTION_REGION=frankfurt
    fi

    PROFILE=$(helper_join_by '-' tanda ${ROLE_REGION} ${PROFILE_ENV} operations-admin)

    echo "Querying cloud resource state using profile: ${PROFILE}"

    type=$1
    available_types=($(aws ec2 describe-instances --profile ${PROFILE} --filters "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[0].Tags[?Key=='type'].Value" | jq '[.[][0]] | unique | .[] | select(. != null)' | xargs | cut -d '"' -f 2))

    if [[ ! " ${available_types[@]} " =~ " ${type} " ]]; then
        echo "Please use one of the available types: ${available_types[@]}"
        read -p "Press any key to continue"
        return
    fi

    echo "Attempting SSH keychain authentication with the following identities."
    ssh-add -l

    ip=$(aws ec2 describe-instances --profile ${PROFILE} --filters "Name=instance-state-name,Values=running" "Name=tag:type,Values=${type}" --query 'Reservations[*].Instances[0].NetworkInterfaces[0].PrivateIpAddress' | jq '.[]' | sort -R | head -n 1 | cut -d '"' -f 2)
    ssh -A -tt ubuntu@bastion.${BASTION_ENV}.${BASTION_REGION}.adnat.co ssh -tt ubuntu@${ip}
}