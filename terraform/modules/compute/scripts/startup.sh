#!/bin/bash
set -e

if [[ ! -f '/etc/systemd/system/bootstrap.service' ]]; then
	gcloud storage cp gs://mineform-data/bootstrap.service /etc/systemd/system/bootstrap.service
fi

if [[ ! -f '/root/bootstrap.sh' ]]; then
	gcloud storage cp gs://mineform-data/bootstrap.sh /root/bootstrap.sh
	chmod +x /root/bootstrap.sh	
fi

systemctl enable bootstrap.service
systemctl start bootstrap.service
