## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

Network Diagram for ELK STACK & Red Team
![](/Diagrams/My-Cloud+ELKSTACK%20final.png)
https://drive.google.com/file/d/1nCvn065KrBHIQ22663Ss4PT41UFS1_lk/view?usp=sharing

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the playbook file may be used to install only certain pieces of it, such as Filebeat.

```
   elk-stack-playbook.yml :
     
---
- name: Configure Elk VM with Docker
  hosts: elk
  remote_user: "changeRemoteUser"
  become: true
  tasks:
    # Use apt module
    - name: Install docker.io
      apt:
        update_cache: yes
        force_apt_get: yes
        name: docker.io
        state: present

      # Use apt module
    - name: Install python3-pip
      apt:
        force_apt_get: yes
        name: python3-pip
        state: present

      # Use pip module (It will default to pip3)
    - name: Install Docker module
      pip:
        name: docker
        state: present

      # Use command module
    - name: Increase virtual memory
      command: sysctl -w vm.max_map_count=262144

      # Use sysctl module
    - name: Use more memory
      sysctl:
        name: vm.max_map_count
        value: 262144
        state: present
        reload: yes

      # Use docker_container module
    - name: download and launch a docker elk container
      docker_container:
        name: elk
        image: sebp/elk:761
        state: started
        restart_policy: always
        # Please list the ports that ELK runs on
        published_ports:
          -  5601:5601
          -  9200:9200
          -  5044:5044

      # Use systemd module
    - name: Enable service docker on boot
      systemd:
        name: docker
        enabled: yes
```
```
       filebeat-playbook.yml:
---
- name: installing and launching filebeat
  hosts: webservers
  become: yes
  tasks:
  - name: download filebeat deb
    command: curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.6.1-amd64.deb
  - name: install filebeat deb
    command: dpkg -i filebeat-7.6.1-amd64.deb
  - name: drop in filebeat.yml
    copy:
      src: /etc/ansible/filebeat-config.yml
      dest: /etc/filebeat/filebeat.yml
  - name: Enable and Configure System Module
    command: filebeat modules enable system
  - name: setup filebeat
    command: filebeat setup
  - name: start filebeat service
    command: service filebeat start
  - name: enable service filebeat on boot
    systemd:
      name: filebeat
      enabled: yes
```
```  
           metricbeat-playbook.yml:
---
- name: Install metric beat
  hosts: webservers
  become: true
  tasks:
    # Use command module
  - name: Download metricbeat
    command: curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.6.1-amd64.deb

    # Use command module
  - name: install metricbeat
    command: dpkg -i metricbeat-7.6.1-amd64.deb

    # Use copy module
  - name: drop in metricbeat config
    copy:
      src: /etc/ansible/metricbeat-config.yml
      dest: /etc/metricbeat/metricbeat.yml

    # Use command module
  - name: enable and configure docker module for metric beat
    command: sudo metricbeat modules enable docker

    # Use command module
  - name: setup metric beat
    command: sudo metricbeat setup

    # Use command module
  - name: start metric beat
    command: sudo service metricbeat start

    # Use systemd module
  - name: enable service metricbeat on boot
    systemd:
      name: metricbeat
      enabled: yes 
```



This document contains the following details:
- Description of the Topology
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build


### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly reliable/redundent, in addition to restricting traffic to the network.

load balancers can defend agaisnt a DDos attack by ensuring that if Web1 machine/server goes down it will route network traffic to the other Web machine/server(web2) giving you a redundent system you can relay on.
a Jumpbox is a VM that it fans in all traffic to 1 spot meaning that you can manage other systems within the network or in the computer through the jumpbox vm . it is the source and it is secure, allowing entry only upon reading your encryption key.

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the logs and system traffic.
- filebeat records lightweight logs & monitors the log files or locations that you specify
- metricbeat records the metrics and statistics from the OS and also services

The configuration details of each machine may be found below.

| Name     | Function | IP Address | Operating System |
|----------|----------|------------|------------------|
| Jump Box | Gateway  | 10.0.0.1   | Linux            |
| Web1     |DvwaServer| 10.0.0.5   | Linux            |
| Web2     |DvwaServer| 10.0.0.6   | Linux            |
| ElkVM    |ELKSTACK  | 10.1.0.4   | Linux            |

### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the Jumpbox machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses:

- MYpersonalIpAdress

Machines within the network can only be accessed by ansible container inside the jumpbox.
theJumpbox VM has access to the ELK VM only through ansiable container. the IP of the Jumpbox VM is 10.0.0.4

A summary of the access policies in place can be found in the table below.

| Name     | Publicly Accessible | Allowed IP Addresses |
|----------|---------------------|----------------------|
| Jump Box | No                  | MyPersonalIP         |
| Web1     | No                  | 10.0.0.4             |
| Web2     | No                  | 10.0.0.4             |
| ELK      | no                  | 10.0.0.4             |
### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because...
The advantages of automating configuration is saving time, for example you could set up many machines using the same apps or services easliy with the same playbook as long as the IPs are loadded to the ansible config file!.

The playbook implements the following tasks:
- Install docker
- installing python-pip3
- Install Docker module
- Increase virtual memory (vm.max_map_count 262144)
- download and launch a docker elk container


The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

https://drive.google.com/file/d/1T0rgtMaekvnq0KCKbPzhB1DDUR_q27T-/view?usp=sharing

### Target Machines & Beats
This ELK server is configured to monitor the following machines:
Web-1 - 10.0.0.5 
Web-2 - 10.0.0.6

We have installed the following Beats on these machines:
- filebeat 
- metricbeat

These Beats allow us to collect the following information from each machine:

- filebeat monitors the log files that you choose, then we use the data filebeat provided us to see what changes or messeges the logs recivied 
- metricbeat monitors and records the metrics/statistics from the OS which we could use to see how much CPU/RAM usage was used.

### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the ansible.cfg file to /etc/ansible.
- Update the Config file to include an IP or multiple IPs then add: "ansible_python_interpreter=/usr/bin/python3" to the end of a line, for example:

[webservers]

```10.0.0.5 ansible_python_interpreter=/usr/bin/python3"```

- Run the playbook, and navigate to Kibana(http://IPADDRESSOFVM:5601/app/kibana) to check that the installation worked as expected.

"Which file is the playbook? Where do you copy it?"
-  the playbook is called elk-stack-playbook.yml and copy it into /etc/ansible using the cp command

"Which file do you update to make Ansible run the playbook on a specific machine? How do I specify which machine to install the ELK server on versus which to install Filebeat on?" 
- you will need to edit it in the host file in /etc/ansiable nano the host file and add the IPs to [webservers] or you could add it as a different name just use the [] to enclose it

"Which URL do you navigate to in order to check that the ELK server is running?" 
- to check the ELK server is running you would navigate to this URL: http://IPADDRESS:5601/app/kibana
