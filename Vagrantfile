Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.provider "virtualbox"
  config.vm.network "forwarded_port", guest: 80, host: 5000, host_ip: "127.0.0.1", auto_correct: true
  config.vm.usable_port_range = 5000..5500
  config.vm.hostname = "devops"
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
    ansible.vault_password_file = ".vault_pass.txt"
  end
end