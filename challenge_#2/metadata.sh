#!/bin/bash

echo "
ami-id
ami-launch-index
ami-manifest-path
ancestor-ami-ids
block-device-mapping/ami
block-device-mapping/ebsN
block-device-mapping/ephemeralN
block-device-mapping/root
block-device-mapping/swap
elastic-gpus/associations/elastic-gpu-id
elastic-inference/associations/eia-id
events/maintenance/history
events/maintenance/scheduled
events/recommendations/rebalance
hostname
iam/info
iam/security-credentials/role-name
identity-credentials/ec2/info
identity-credentials/ec2/security-credentials/ec2-instance
instance-action
instance-id
instance-life-cycle
instance-type
kernel-id
local-hostname
local-ipv4
mac
metrics/vhostmd
network/interfaces/macs/mac/device-number
network/interfaces/macs/mac/interface-id
network/interfaces/macs/mac/ipv4-associations/public-ip
network/interfaces/macs/mac/ipv6s
network/interfaces/macs/mac/local-hostname
network/interfaces/macs/mac/local-ipv4s
network/interfaces/macs/mac/mac
network/interfaces/macs/mac/network-card-index
network/interfaces/macs/mac/owner-id
network/interfaces/macs/mac/public-hostname
network/interfaces/macs/mac/public-ipv4s
network/interfaces/macs/mac/security-groups
network/interfaces/macs/mac/security-group-ids
network/interfaces/macs/mac/subnet-id
network/interfaces/macs/mac/subnet-ipv4-cidr-block
network/interfaces/macs/mac/subnet-ipv6-cidr-blocks
network/interfaces/macs/mac/vpc-id
network/interfaces/macs/mac/vpc-ipv4-cidr-block
network/interfaces/macs/mac/vpc-ipv4-cidr-blocks
network/interfaces/macs/mac/vpc-ipv6-cidr-blocks
placement/availability-zone
placement/availability-zone-id
placement/group-name
placement/host-id
placement/partition-number
placement/region
product-codes
public-hostname
public-ipv4
public-keys/0/openssh-key
ramdisk-id
reservation-id
security-groups
services/domain
services/partition
spot/instance-action
spot/termination-time


Enter the metadata value of your choice from above list [Prints all meta-data available if empty]:
"

# Retrive dynamic data and feed to user data input
mac=`curl --silent http://169.254.169.254/latest/meta-data/mac`
role_name=`curl --silent http://169.254.169.254/latest/meta-data/iam/security-credentials`
eia_id=`curl --silent http://169.254.169.254/latest/meta-data/elastic-inference/associations/eia-id`
elastic_gpu_id=`curl --silent http://169.254.169.254/latest/meta-data/elastic-gpus/associations/elastic-gpu-id`


read -p "metadata_type: " user_var

sub1="macs"
sub2="role-name"
sub3="eia-id"
sub4="elastic-gpu-id"
sub5="public-ip"


case $user_var in
  *"macs"*)
      user_var=`echo $user_var | sed -e "s@\<mac\>@$mac@g"` ;;&
   *"role-name"*)
      user_var=`echo $user_var | sed -e "s@\<role-name\>@$role_name@g"` ;;&
   *"eia-id"*)
      user_var=`echo $user_var | sed -e "s@\<eia-id\>@$eia_id@g"` ;;&
   *"elastic-gpu-id"*)
      user_var=`echo $user_var | sed -e "s@\<elastic-gpu-id\>@$elastic_gpu_id@g"` ;;&
   *"public-ip"*)
      public_ip=`curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/$mac/ipv4-associations/`
      user_var=`echo $user_var | sed -e "s@\<public-ip\>@$public_ip@g"`
    
        echo "user_var is $user_var"
    ;;
esac

result_val=`curl --silent http://169.254.169.254/latest/meta-data/$user_var | jq  -R .  | jq -s .`

echo "$result_val"

