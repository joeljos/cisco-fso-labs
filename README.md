# cisco-fso-labs
cisco-fso-lab

This lab demonstrates simple integration with a variety of common APIs that perform standard operational standard stack functions:
- vault & artifactory placeholder- lastpass
- kubernetes - ci tool
- kubernetes - sample java apps
- aws - cloud provider
- python, shell, bash
- docker
- Appdynamics
- ThousandEyes
- github/gitlab
- cisco csr1000v
- IOX XE

Instructors of this lab should have hands on skills with the following:
- git branching and github/gitlab - managing repos and branches, understand git flow and developer processes using git to rapidly - - iterate on code
- advanced json and yaml file format understanding
- advanced cisco networking
- advanced docker
- advanced aws and cloud networking
- Advanced knowledge and experience with SDLC, rapid iteration and current develops rapid iteration concepts
- Green/Red rapid iteration development cycle and code testing concepts
- The importance of ensuring all cloud based infrastructure is managed as code - Infra as Code

Students of this lab require at least basic experience and skills with:
- git flow, creating branches, updating code etc.
- ssh keys - generating and using
-linux command line, shell, bash
- basic python

# Lab Setup

1. Clone the git repo at https://github.com/devops-ontap/cisco-fso-labs
   - In your home directory on the Lab Computer use the command below from a shell
    ```
    git clone git@github.com:devops-ontap/cisco-fso-labs.git
    ```

2. Create a Branch - each lab user will create their own branch
   - In this lab we will not be doing a git merge. Students will work from their own branches
    ```
    git checkout -b yourname
    git status
    git fetch --all
    ```

3. Setup your IAM account with Admin/FullEC2 and ability to generate VPCs and add the key in lastpass vault secure note
 In this lab - using lastpass as it is free and fast/simple to set up an account. Add the key to lastpass in a note in the AWS csv format
   - Create a secure note named: **aws_cred**
   - The contents of the secure note: (Use formatting below exactly, use your AWS key and secret)
    ```
    User Name,Access key ID,Secret access key
    default,your_AWS_Key,your_AWS_secret
    ```  
   - We will be using lastpass as our vault for now. Subsequent iterations will use Hashicorp Vault and AD

4. Login to the ci tool concourse (you will be provided with a credential - the credential is assigned to a Team called Nterone).
   Everyone in your Team has access to the same pipelines. Access to pipe-lines is by Team.
   - Download the fly too from http://ci.devops-ontap.com:8080
   **Commands to enter after fly file has been downloaded (Mac instructions only)**

    ```
    sudo mkdir -p /usr/local/bin
    sudo mv ~/Downloads/fly /usr/local/bin
    sudo chmod 0755 /usr/local/bin/fly
    ```

5. From within your git repo directory - update your lab_vars.py file with the name you want to use for your lab. For simplicity, keep the the name the same as your branch name (instructor in exampe below).  Also comment/uncomment so the desired regions is set (default shows "us-east-1")

    **Example lab_vars.py file:** 

    ```
    name = "instructor"
    region = "us-east-1"
    az = "us-east-1a"
    #az = "us-east-2a"
    #az = "us-west-1a"
    #az = "us-west-2a"
    ubuntu_ami_id = "ami-0b359b42108ad6fd2"  #us-east-1
    #ubuntu_ami_id = "ami-093ab2ee72248accb"  #us-east-2
    #ubuntu_ami_id = "ami-014723d9d9c12a060"  #us-west-1
    #ubuntu_ami_id = "ami-0ed08ddf96d9628f3"  #us-west-2
    csr_ami_id = "ami-067c66abd840abc24"  #us-east-1
    #csr_ami_id = "ami-0d43ca842a14ff342"  #us-east-2
    #csr_ami_id = "ami-07dde80b3b3ccfb2f"  #us-west-1
    #csr_ami_id = "ami-0453b3bb1d98a0102"  #us-west-2
    ```

    **NOTE:** In AWS the AMI names for images are different per region  - the file has 4 AMIs set for each image.  3 of each should be commented out or deleted by the student.
    You can have 4 azs to a region, so you can have 4 isolated labs to a region. The instructor will need to assign each set of 4 students to a unique region.  (this will support up to 16 students)
    

6. Create a params directory OUTSIDE of the git repo, and copy out the sample-params.yml file into that directory.
  
    ```mkdir params```
  
7. Update the master pipeline file parameters file with your branch name, private key, the github username and email address ( are only required when the lab repo is private)
    **Example params file:**
    ```
    lpass-username: your_last_pass_email_here
    lpass-password: your_last_pass_password_here
    git-branch: your_branch_name_here 
    git-uri: git@github.com:devops-ontap/cisco-fso-labs.git
    Username: your_github_username_here (if private)
    email: your_associated_github_email_here (if private)
    image-repo-name: sconrod
    registry-username:
    registry-password:
    private_key: |
    -----BEGIN OPENSSH PRIVATE KEY----- (remove this line before pasting, leave the | above with a carriage return)
    your private ssh key here(this can be a lab computer where students work)
    ssh-keygen
    cat ~/.ssh/rsa_id
    pbcopy < ~/.ssh/id_rsa
    then paste contents here
    -----END OPENSSH PRIVATE KEY----- (remove this line before pasting, ensure no trailing spaces)
    ```

8. Target the Concourse ci tool using fly and set your pipeline

    **Example Fly token transfer:**
   - Login to Concourse in a browser at: http://ci.devops-ontap.com:8080
   - Enter the following command on your the lab desktops shell
    ```
    fly --target=ci login --concourse-url=http://ci.devops-ontap.com:8080 --username=your_username_here -n nterone\n
    ```
  Then paste the URL into a browser and login if requested (it may transfer the token automatically)


9. Set the pipeline and keep the pipeline suffix name the same as your lab name and your branch name for consistency, example:
    ```
    fly -t ci set-pipeline -c pipeline-your_branch_name_here.yml -p cisco-your_branch_name_here -l /path_to_the params_directory/params/params-instructor.yml
    fly -t ci unpause-pipeline -p cisco-instructor
    ```
    - The pipeline can be destroyed at any time during the class with this command and then recreated with the commands above
    ```
    fly -t ci destroy-pipeline -p cisco-instructor
    ```

----------------------------------------
Update the lab_vars.py file accordingly
git add  lab_vars.py
git commit - "updated lab vars file"
git push

As soon as a git push is done to the branch, the first step in the pipeline
automatically starts. This step:

Grabs the AWS Auth Key from the lastpass vault,
Grabs the resources to be used in the pipeline:
Pulls the docker container and uses it as the pipeline worker container image
Pulls the git branch and dumps it onto the build container
Authenticates to AWS and Creates the SSH key that will be used subsequently to deploy the EC2 images and AWS resources

Start the build of the AWS Env. This will create the resources in the name you set in the vars file:
VPC
Subnets
Route Tables
Routes
Internet Gateway
Security Group
Ingress Rules to allow SSH into lab

Once the Deploy AWS Env job turns green, start the Deploy Cisco CSR1000V job
This job takes the longest, as before much of the code can execute it must wait on the
instance to fully initialize, so there is polling set up in the job.

All configuration in this lab will be done via code - we will only use the GUI to view the changes we make via code. In reality the GUI is not even required
however, we use it only as a visual familiar representation of our changes as it is most familiar to the students in the lab.

The Instructor and the students will be constantly doing git updates throughout the lab to their branch as the Instructure steps them through the lab
This repetition, will enforce the green/red rapid iteration of code which is an important skill that requires repitition and practise much like playing a musical instrument.

We are not only teaching our students new ways of working with cisco apis, we are teaching them a new modern way of working with network infrastructure as code
in a modern SDLC. This way of working has been used for Software Developers for over 20 years, and by Devops Engineers for over 10 years,  but it is relatively new to Network Administrators.

Traditional on site data centers have established a specific work methodology among the vast population of network administrators - however, due to cloud integrations this way of working no longer can be used
to successfully manage hybrid cloud and cloud networking environments.

To ensure stability of our infrastructure, it is required to manage it via code using the SDLC and Industrial Pipelines.

As soon as a git push is complete, the lab prep job in the pipeline automatically starts

### CSR1000 Known Issue and Workaround
openssl rsa -outform der -in private.pem -out private.key

Common Error when trying to SSH to the CSR1000v:
Unable to negotiate with 18.220.247.107 port 22: no matching key exchange method found. Their offer: diffie-hellman-group-exchange-sha1,diffie-hellman-group14-sha1

Add the following to the /etc/ssh/ssh_config
KexAlgorithms diffie-hellman-group1-sha1,curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1

AWS Ref Docs:
https://docs.aws.amazon.com/cli/latest/reference/ec2/
To see what is possible with an AWS Cli command run this:
aws ec2 create-vpc --generate-cli-skeleton

BASIC LAB CONFIG
One instance of this pipeline creates a pop up lab in aws that contains:
vpc01 with CIDR 10.10.0.0/16

Create Two Subnets for vpc01:

router
lan - associated to lan subnet and default route goes to the csr1000v so all traffic going out of AWS passes through our router
internet gateway
default route table for vpc has 0.0.0.0/0 to destination our internet gateway

Creates a Security Group in the az and region that has an ingress allowing inbound on port 22
to enable the lab users to SSH to the instances that are provisioned

Creates an SSH key - one for each instance of the lab

---------

After the LAB BASE is deployed, the FSO stack is deployed along with one more more test apps
for which agents will be configured and deployed in the lab via the pipeline.

Thousand Eyes
Intersight
AppDynamics

