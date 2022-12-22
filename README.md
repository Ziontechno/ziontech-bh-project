# react-and-spring-data-rest

The application has a react frontend and a Spring Boot Rest API, packaged as a single module Maven application. You can build the application using maven and run it as a Spring Boot application using the flat jar generated in target (`java -jar target/*.jar`).

You can test the main API using the following curl commands (shown with its output):

---

\$ curl -v -u greg:turnquist localhost:8080/api/employees/3
{
"firstName" : "Frodo",
"lastName" : "Baggins",
"description" : "ring bearer",
"manager" : {
"name" : "greg",
"roles" : [ "ROLE_MANAGER" ]
},
"\_links" : {
"self" : {
"href" : "http://localhost:8080/api/employees/1"
}
}
}

---

To see the frontend, navigate to http://localhost:8080. You are immediately redirected to a login form. Log in as `greg/turnquist`








 STEPS TO DEPLOY AND MONITOR REACT-AND-SPRING-DATA-REST APPLICATION  

1- AWS Acccount.
2- Create an ubuntu EC2 Instnace.
   Create IAM Role With the following Policies

    - VPCFullAccess
    - EC2FullAcces
    - S3FullAccess ..etc
    - Administrator Access

 3- Install AWS CLI on the ubuntu EC2 Instnace

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install


Confirm the installation with the following command.

aws --version

 4- Install Terraform on the ubuntu EC2 Instnace
 #!/bin/bash
# install terraform in ubuntu server
sudo apt install wget unzip -y
wget https://releases.hashicorp.com/terraform/1.3.6/terraform_1.3.6_linux_amd64.zip
sudo unzip terraform_1.3.6_linux_amd64.zip -d /usr/local/bin/
#Export terraform binary path temporally
export PATH=$PATH:/usr/local/bin
#Add path permanently for current user.By Exporting path in .bashrc file at end of file.
 echo  "export PATH=$PATH:/usr/local/bin" >> ~/.bashrc
# Source .bashrc to reflect for current session
 source ~/.bashrc 
 terraform -version

 5- Install EKS CLI on the ubuntu EC2 Instnace
#!/bin/bash 
# https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html#installing-eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version


 
 6- Provision AWS EKS cluster using Terraform and run the following commands
 
terraform init
terraform plan -var-file prod.tfvars
terraform apply -var-file prod.tfvars



- copy the output (kube configuration) from the command above, vi /.kube/config  and paste the output
   and then save and quite #(This is to establish communication between the client control server and the EKS CLUSTUER)
   

- terraform destroy -var-file prod.tfvars #(this is to destroy the enfrastructure)
 
NB Check out the terraform files for the details about the resources

run the folowing commands to confirm your operation:

kubectl get all 
kubectl version short



7-Install jenkis and docker on  on the ubuntu EC2 Instnace

   #!/bin/bash
# Run this as a script
sudo apt update
sudo hostname docke
sudo apt install docker.io -y
sudo usermod -aG docker ubuntu 
# Install java as jenkins dependency
sudo apt install openjdk-11-jdk -y
# install jenkis in ubuntu:
sudo wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins -y 
sudo systemctl start jenkins
sudo usermod -aG  docker jenkins
sudo systemctl restart docker.service

sudo echo "jenkins  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/jenkins 
sudo echo "jenkins:admin" | chpasswd
sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
sudo service sshd restart

     


8- Deploy Sonarqube as a docker container by running the following command

docker run --name sonar -d -p 3000:8081 sonarqube   



9- Deploy Nexus as a docker container by running the following command
 
  docker run --name nexus -d -p 6000:9000 sonatype/nexus3


10 Create and configure helm chart for deployment in the kubernetes 
   EKS cluster.

#Installation of helm package manager
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

#creating helm chart
helm create webapp  #(webapp is the chart name)
helm template webapp # (to see the resources created)
helm show values # (to see the configuration values)
vi into values.yml and do some configurations like change the image and put the image of your application.

ls template/deployment and change the following

-application port to 8080 since it is using a tomcat base image
-liveliness probe: pass the application path zion-web-app
helm install zion-app webapp #(zion-app while webapp is the application name) this deployment command is in the jenkins file


11- Deploy theapplication to you cluster using Jenkinsfile

note: find the jenkins file in the project repository

12- Deploy  promethus and graffana using helm chart

