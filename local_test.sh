#!/usr/bin/env bash

set -e

echo "Checking if Ansible present in \$PATH"
which ansible > /dev/null || ( echo "No it's not" && exit -1 )
echo "Checking out most recent CI config"
repodir="tmp_ci_config"
if [ ! -d $repodir ]
then
  git clone git@git.vogres.tech:hse_devops_2021/ci-configurations.git $repodir
fi
cd $repodir
git checkout master
git fetch
git reset --hard origin/master

cd -
python -c "import sys, yaml; print('\n'.join(yaml.load(open('$repodir/iac_assignment_ci.yml'))['test']['script']))" \
 | grep -v "bin/activate" > test.sh

echo "==============================================================="
echo "                RUNNING TEST LOCALLY                           "
echo "==============================================================="
sleep 5
bash -e test.sh
