#!/bin/bash
SPOTID=`aws ec2 describe-spot-instance-requests --filters Name=state,Values=active --query "SpotInstanceRequests[*].{ID:SpotInstanceRequestId}"`
INSID=`aws ec2 describe-instances --filters Name=instance-state-name,Values=running --query 'Reservations[*].Instances[*].[InstanceId]' | tr -d '\n'`
echo instanceid is $INSID

aws ec2 cancel-spot-instance-requests --spot-instance-request-ids $SPOTID
aws ec2 terminate-instances --instance-ids $INSID
INSSTATE=`aws ec2 describe-instances --filters Name=instance-id,Values=$INSID --query 'Reservations[*].Instances[*].State.Name' | tr -d '\n'`
echo $INSSTATE
while [ "$INSSTATE" != "terminated" ]; do
  sleep 15s
  INSSTATE=`aws ec2 describe-instances --filters Name=instance-id,Values=$INSID --query 'Reservations[*].Instances[*].State.Name' | tr -d '\n'`
  echo $INSSTATE
done
echo Instance has terminated
sleep 5s


OLDSNAPID=`aws ec2 describe-volumes --filters Name=status,Values=available --query "Volumes[*].{SID:SnapshotId}"`
echo Old snapshot is $OLDSNAPID
aws ec2 delete-snapshot --snapshot-id $OLDSNAPID
echo deleted old snapshot

VOLID=`aws ec2 describe-volumes --filters Name=status,Values=available --query "Volumes[*].{ID:VolumeId}"`
echo $VOLID
aws ec2 create-snapshot --volume-id $VOLID --description "This is trial six snapshot"
echo Creating Snapshot...
NEWSNAPID=`aws ec2 describe-snapshots --filters Name=volume-id,Values=$VOLID --query "Snapshots[*].{ID:SnapshotId}"`
echo $NEWSNAPID
PROG=`aws ec2 describe-snapshots --filters Name=volume-id,Values=$VOLID --query "Snapshots[*].{P:Progress}"`
echo $PROG
STATE=`aws ec2 describe-snapshots --filters Name=volume-id,Values=$VOLID --query "Snapshots[*].{S:State}"`
echo $STATE	
while [ "$STATE" != "completed" ]; do
  sleep 5s
  PROG=`aws ec2 describe-snapshots --filters Name=volume-id,Values=$VOLID --query "Snapshots[*].{P:Progress}"`
  STATE=`aws ec2 describe-snapshots --filters Name=volume-id,Values=$VOLID --query "Snapshots[*].{S:State}"`
  echo $PROG
  echo $STATE
done
echo Snapshot creation completed
aws ec2 delete-volume --volume-id $VOLID
echo Volume Deleted
sed -i -e 's/'$OLDSNAPID'/'$NEWSNAPID'/g' specification.json              ##enter correct location of specification.json file
echo 'snapshot-id replaced in specification1.json-file'
