AWS Spot Instances - launch, stop and store snapshots -bash script

The scripts in this repo can be used for one step launch and one step terminate and save the spot instances.
Description of scripts is given in respective folders.

`$ git clone https://github.com/ruc98/AWS-Spot-Instances---launch-stop-and-store-snapshots--bash-script.git`

The Amazon Machine Image given below is available in the US-West-2c(oregon) region and is one of the best dockers available as community AMI. 
`ami-f88f1780  -  deep-learning-for-computer-vision-python-v1.2`

Before you start using AWS Command Line Interface, follow below steps.

Launching AWS Spot Instances using Command Line:
ONE TIME SETUP STEPS:
1) Install:
`$ sudo pip install awscli --upgrade --user`


2) Configure:
`$ aws configure`

output:

`AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-west-2
Default output format [None]: text`

To get the access key ID and secret access key for an IAM user:

Open the IAM console.

In the navigation pane of the console, choose Users.

Choose your IAM user name (not the check box).

Choose the Security credentials tab and then choose Create access key.

To see the new access key, choose Show. Your credentials will look something like this:

    Access key ID: AKIAIOSFODNN7EXAMPLE

    Secret access key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

To download the key pair, choose Download .csv file. Store the keys in a secure location.
Refer: `https://docs.aws.amazon.com/cli/latest/userguide/installing.html` for more information.

One time setup is complete.

Open the `specification.json` file and fill the "KeyName", "SecurityGroupIds" and "SnapshotId" information.
(Note: For the first time create a snapshot manually from the console and enter its SnapshotId)

Run the bash script below to launch a spot instance and ssh to the remote system.
`$ bash spot_launch.sh`
(Note: Enter location of the specification.json file in the first line of the bash code)

For the AMI coded in the script "ami-f88f1780" all the required packages for deep learning are stored in a virtual environment called dl4cv. To enter
`$ workon dl4cv`

To save your work, terminate instance and cancel spot request run this bash script
`$ bash spot_stop.sh`
(Note: Enter location of the specification.json file in the last line of the bash code)

This will automatically save your work in a snapshot of the volume in use and delete the volume itself. It will replace the "SnapshotId" in the specification.json file.

