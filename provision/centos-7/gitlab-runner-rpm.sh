#!/bin/bash
echo "Phase: gitlab-runner-rpm.sh"

curl -q -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh 2>/dev/null | sudo bash
sudo yum install -y gitlab-runner
sudo usermod -aG docker gitlab-runner
sudo systemctl restart gitlab-runner

PROVIDER=$(virt-what)
if [ "$PROVIDER" != "" ]; then
GITLABCI_TAGS+=",provider_${PROVIDER}"
fi

# for debug
# echo GITLABCI_URL=$GITLABCI_URL
# echo GITLABCI_TOKEN=$GITLABCI_TOKEN
# echo GITLABCI_EXECUTOR=$GITLABCI_EXECUTOR
# echo GITLABCI_TAGS=$GITLABCI_TAGS

sudo gitlab-runner register \
	--non-interactive \
	--name "$GITLABCI_NAME" \
	--url "$GITLABCI_URL" \
	--registration-token "$GITLABCI_TOKEN" \
	--executor "$GITLABCI_EXECUTOR" \
	--tag-list "$GITLABCI_TAGS" \
	--docker-image ubuntu

# for more options see gitlab-runner register --help
