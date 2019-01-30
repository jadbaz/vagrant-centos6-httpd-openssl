Vagrant.configure("2") do |config|
    config.vm.define "machine" do |machine|
        machine.vm.provider "virtualbox" do |v|
            v.gui = true
            v.name = "Centos6LatestApacheOpenSSL"
            v.memory = 512
            v.cpus = 2
        end
        machine.vm.box = "centos/6"
        
        config.vm.provision "shell" do |s|
            s.path = "centos6_openssl.sh"
        end

        config.vm.provision "shell" do |s|
            s.path = "centos6_httpd.sh"
        end
        
        # https://oddessay.com/development-notes/changing-vagrants-default-ssh-port-to-prevent-collision-when-resuming-a-suspended-instance
        # machine.vm.network "forwarded_port", guest: 22, host: 2225, id: "ssh"
        machine.vm.network "forwarded_port", guest: 80, host: 10080, id: "http"
        machine.vm.network "forwarded_port", guest: 443, host: 10443, id: "https"

        # Issue with synced folder on Windows: https://github.com/hashicorp/vagrant/issues/6769#issuecomment-252151694
        # Issue with ssh keys permission too open: https://stackoverflow.com/questions/35807568/vagrant-synced-folder-permissions
        # Issue with ssh keys permission too open: https://github.com/centos7/centos7/issues/42388#issuecomment-405950940
        machine.vm.synced_folder "./", "/home/vagrant/machine", disabled: false, mount_options: ["dmode=700,fmode=700"]
    end
end
