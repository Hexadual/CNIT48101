==========================================
Lab 7: Kuberneties
==========================================

This is the documentation for the CNIT 48101 Lab 6 "Openstack" Created by Jacob Bauer & Nick Kuenning


Section 1 (Deploying a Kubernetes cluster using cloud-init) 
###############################################################
In this step we created three Kuberneties nodes. One master node and two workner nodes. We used cloud-init to deploy all three of the nodes. We first configured the `cloud-config` file that contained the configuration for the nodes. In this file contained the networking informaion as well as login details. 

This is the cloud-config file that we used that allowed us to deploy the Kuberneties nodes.

.. code-block::

    #cloud-config
    autoinstall:
    version: 1
    early-commands:
        - systemctl stop ssh
    network:
        network:
        version: 2
        ethernets:
            en0:
            match:
                name: e*
            dhcp4: false
            dhcp6: false
            addresses:
            - 44.41.10.4/24
            routes:
            - to: default
                via: 44.41.10.1
            nameservers:
                search: [cit.lcl]
                addresses: [44.2.1.44,44.2.1.45,44.2.2.44,44.2.2.45,8.8.8.8,8.8.4.4]
            renderer: networkd
    
    identity:
        hostname: worker_node2
        username: ubuntu
        password: '$6$T3oHxrL8xIXeqhmj$G268bP9EW5fqD5B5zRI9BNOroEbd/HkVA2gweTVNKpl.Fj.hVgYIcbqx.EE51hqUyFM3VG7LBUYs611CjPEUD/'

    packages:
        - apt-transport-https
        - ca-certificates
        - curl
        - gpg
        - software-properties-common
        - git
        - nfs-kernel-server
        - nfs-common
        - openssh-server

    user-data:
        disable_root: false
        write_files:
        - path: /etc/modules-load.d/containerd.conf
        content: |
            overlay
            br_netfilter

        permissions: '0644'
        owner: root:root
        - path: /etc/sysctl.d/kubernetes.conf
        content: |
            net.bridge.bridge-nf-call-ip6tables = 1
            net.bridge.bridge-nf-call-iptables = 1
            net.ipv4.ip_forward = 1

        permissions: '0644'
        owner: root:root
        - path: /home/ubuntu/addresspool.yaml
        content: |
            apiVersion: metallb.io/v1beta1
            kind: IPAddressPool
            metadata:
            name: first-pool
            namespace: metallb-system
            spec:
            addresses:
            - 44.41.10.50-44.41.10.100

        permissions: '0755'
        - path: /home/ubuntu/utils/nfs-server.sh
        content: |
            #!/bin/bash
            
            NFS_STORE="/srv/nfs/kube"
            LINE="$NFS_STORE	*(rw,sync,no_subtree_check,no_root_squash,no_all_squash)"
            FILE="/etc/exports"

            if [ ! -d $NFS_STORE ]; then
                printf '%s\n' --------------------
                printf "Creating directories...\n"
                printf '%s\n' --------------------
                sudo mkdir -p $NFS_STORE
                ls -R /srv
                printf '%s\n' --------------------
                printf "Directories created.\n"
                printf '%s\n' --------------------
            fi

            printf '%s\n' --------------------
            printf "Configuring NFS service...\n"
            printf '%s\n' --------------------
            grep -qF -- "$LINE" "$FILE" || echo $LINE | sudo tee -a $FILE
            sudo chown nobody:nogroup $NFS_STORE
            sudo exportfs -rav
            sudo exportfs -v
            printf '%s\n' --------------------
            printf "Done.\n"
            printf '%s\n' --------------------

            printf '%s\n' --------------------
            printf "Starting NFS service...\n"
            printf '%s\n' --------------------
            sudo systemctl daemon-reload
            sudo systemctl enable nfs-kernel-server
            sudo systemctl restart nfs-kernel-server.service
            sudo systemctl status nfs-kernel-server.service
            printf '%s\n' --------------------
            printf "Done.\n"
            printf '%s\n' --------------------
            
        permissions: '0755'
        - path: /home/ubuntu/utils/post-install.sh
        content: |
            #!/bin/bash
            printf '%s\n' --------------------
            printf "Starting NFS service...\n"
            printf '%s\n' --------------------
            sudo systemctl daemon-reload
            sudo systemctl enable nfs-kernel-server
            sudo systemctl restart nfs-kernel-server.service
            sudo systemctl status nfs-kernel-server.service
            printf '%s\n' --------------------
            printf "Done.\n"
            printf '%s\n' --------------------
            
        permissions: '0755'

        runcmd:
        - 'sudo apt-get update'
        - sed -i '/swap/d' /etc/fstab
        - swapoff -a
        - 'systemctl disable --now ufw >/dev/null 2>&1'
        - 'modprobe overlay'
        - 'modprobe br_netfilter'
        - 'sudo install -m 0755 -d /etc/apt/keyrings'
        - 'sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc'
        - 'sudo chmod a+r /etc/apt/keyrings/docker.asc'
        - 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null'
        - 'sudo apt-get update'
        - 'sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin'
        - 'containerd config default > /etc/containerd/config.toml'
        - sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
        - 'sudo systemctl restart containerd'
        - 'sudo systemctl enable containerd >/dev/null'
        - groupadd docker
        - usermod -aG docker ubuntu
        - newgrp docker
        - systemctl enable docker
        - systemctl daemon-reload
        - sudo systemctl restart docker
        - docker run hello-world
        - 'sudo systemctl enable docker.service'
        - 'sudo systemctl enable containerd.service'
        - 'echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list'
        - 'curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg'
        - 'sudo apt-get update'
        - 'echo "Installing kubectl..."'
        - 'sudo apt-get install -y kubelet kubeadm kubectl'
        - 'sudo apt-mark hold kubelet kubeadm kubectl'
        - 'sudo systemctl enable --now kubelet'
        - 'cd /home/ubuntu'

Section 2 (Configuring a Kubernetes cluster)
###########################################
