#!/bin/bash
aws ec2 request-spot-instances --spot-price "0.3" --instance-count 1 --type "one-time" --launch-specification file://specification.json  #enter location of the specification.json file

sleep 5s
MOREF=`aws ec2 describe-instances --query 'Reservations[*].Instances[*].[PublicDnsName]' | tr -d '\n'`
echo Public-DNS is $MOREF
INSSTATE=`aws ec2 describe-instances --filters Name=dns-name,Values=$MOREF --query 'Reservations[*].Instances[*].State.Name' | tr -d '\n'`
echo $INSSTATE
while [ "$INSSTATE" != "running" ]; do
  sleep 5s
  INSSTATE=`aws ec2 describe-instances --filters Name=dns-name,Values=$MOREF --query 'Reservations[*].Instances[*].State.Name' | tr -d '\n'`
  echo $INSSTATE
done

ssh -i "Rahulkey2.pem" ubuntu@$MOREF -L 8222:localhost:8888 -L 8333:localhost:6006


