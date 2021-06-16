export required_paths_file=paths
export nex_paths_file=nex_paths
cat <<'EOF' | shuf | awk 'NR<=10{print > ENVIRON["required_paths_file"]} NR>10 && NR<=15{print > ENVIRON["nex_paths_file"]}'
time
person
year
way
day
thing
man
world
life
hand
part
child
eye
woman
place
work
week
case
point
government
company
number
group
problem
fact
EOF
echo "Going to test the role with following paths:" && echo --- && cat $required_paths_file && echo ---
echo "And these paths expected to 404:" && echo --- && cat $nex_paths_file && echo ---
cat -- <<EOF > playbook.yml
---

- hosts: "all"
  become: "yes"
  roles:
    - role: hello_webservice
      hello_pages: "{{ lookup('file', '$required_paths_file').split('\n') }}"
EOF
echo "Going to use the following playbook to test the role:" && cat playbook.yml
vagrant up
echo "Rebooting the VM" && vagrant ssh -c 'sudo shutdown -r now' || true;
while [[ $(vagrant ssh -c 'true') ]]; do sleep 1; done
echo "Waiting for a tiny moment until your services are [hopefully] running after reboot" && sleep 10
export VM_PORT=$(vagrant port --machine-readable  | awk -F, '$4==80{print $5}')
if [ "$VM_PORT" == "" ]; then echo "Couldn't detect port forwading, check it's enabled in your Vagrantfile"; exit -1; fi
export curl="curl --silent -S"
for page in $(cat $required_paths_file);
do
  cmd="$curl localhost:$VM_PORT/$page"
  echo "Executing: $cmd"
  result=$($cmd);
  if [ "$result" != "Hello $page!" ]
  then
    echo "Test failed since webservice returned $result != Hello $page!"
    FAILED=1
  fi
  if (( RANDOM % 2 )); then $cmd >/dev/null; fi
done
for nx_page in $(cat $nex_paths_file);
do
  cmd="$curl -o /dev/null -w "%{http_code}" localhost:$VM_PORT/$nx_page"
  echo "Executing: $cmd"
  nex_result=$($cmd)
  if [ "$nex_result" != "404" ];
  then
    echo "Test failed: didnt get 404 on the page that not supposed to exist"
    FAILED=1
  fi
done
if [ $FAILED ]; then exit -1; else echo GREAT SUCCESS; fi
