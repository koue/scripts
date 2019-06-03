#!/usr/bin/env sh

##############################################################################
#
# Easy management of AWS instances.
#
# HOWTO:
#
#	1. $ ./aws_cli.sh create nameme
#
#	Create new AWS instance with name "${USER}_nameme", e.g. 'nkolev_nameme'.
#	The output of the command is in JSON format, examples:
#	https://docs.aws.amazon.com/cli/latest/reference/ec2/run-instances.html#examples.
#
#	2. $ ./aws_cli.sh list
#
#	List my AWS instances:
#
#	i-xxxxxxxxxxxxxxxx stopped 10.101.161.196  nikola.kolev   awstest
#
#	'i-xxxxxxxxxxxxxxxxx' is the AWS instance ID. You can use this ID to
#	control your instance, e.g. start, stop, describe, terminate.
#
#	3. $ ssh mysshuser@10.101.161.196
#
#	Use ssh to connect to your instance. Currently we are using 'xcard'
#	user to access our AWS instances. 'xcard' user has 'sudo' permissions
#	and it can execute everything as root without password.
#
#	4. $ ./aws_cli.sh stop i-xxxxxxxxxxxxxxxx
#
#	Stop running AWS instance. The instance will persist in your instances
#	list with state 'stopped'. If you want to remove it you can use 'terminate'.
#
##############################################################################

# Remote management point
: ${LHOST:="mysshuser@10.101.163.186"}
# Xcard compilehost AMI. List the available AMIs and pick your favorite
: ${AMIID:="ami-099942f3b8bf49611"}
: ${INSTANCETYPE:="t2.large"}
: ${USER:="id -un"}


# Usage
usage() {
cat << EOF

Usage: ${0} [create|describe|list|start|stop|terminate] [instance]

Examples:
	${0} create nameme
	${0} stop i-0fcb9299a6394edc3
    USER=nikola.kolev ${0} list
    AMIID=0000000randomid00000 ${0} create mynewinstance

EOF
exit 1
}

# Check for missing parameters
validate_param() {
	[ -z ${1} ] && echo "Missing parameter." && usage
}

# Create instance
create_instance() {
	validate_param ${1}
	ssh ${LHOST} "aws ec2 run-instances --count 1 \
			--image-id ${AMIID} \
            --iam-instance-profile '{ \"Arn\":\"arn:aws:iam::993435000692:instance-profile/MyAWSRole\" }' \
			--security-group-ids sg-92cdb5491d0002d13 \
            --region eu-central-1 \
			--instance-type ${INSTANCETYPE} \
			--placement AvailabilityZone=eu-central-1a \
			--tag-specification \"ResourceType=instance, \
						Tags=[{Key=User,Value=${USER}},\
						{Key=Name,Value=${USER}_${1}}]\" \
			--subnet-id subnet-0ca0910879d70d6ee"
}

# Describe instance
describe_instance() {
	validate_param ${1}
	ssh ${LHOST} "aws ec2 describe-instances --instance-ids ${1}"
}

# List instances
list_instance() {
    ssh ${LHOST} "aws ec2 describe-instances \
                    --filters \"Name=subnet-id,Values=subnet-0ca0910879d70d6ee\" \
                    --query 'Reservations[*] \
                                .Instances[*] \
                                    .[InstanceId, \
                                        State.Name, \
                                        PrivateIpAddress, \
                                        Tags[?Key==\`User\`]|[0].Value, \
                                        Tags[?Key==\`Name\`]|[0].Value]' \
                    --output text" | grep ${USER}
}

# Start instance
start_instance() {
	validate_param ${1}
	ssh ${LHOST} "aws ec2 start-instances --instance-ids ${1}"
}

# Stop instance
stop_instance() {
	validate_param ${1}
	ssh ${LHOST} "aws ec2 stop-instances --instance-ids ${1}"
}

# Terminate instance
terminate_instance() {
	validate_param ${1}
	ssh ${LHOST} "aws ec2 terminate-instances --instance-ids ${1}"
}

#
case "${1}" in
	create)
		create_instance ${2}
	;;
	describe)
		describe_instance ${2}
	;;
	list)
		list_instance
	;;
	start)
		start_instance ${2}
	;;
	stop)
		stop_instance ${2}
	;;
	terminate)
		terminate_instance ${2}
	;;
	*)
		usage
	;;
esac
