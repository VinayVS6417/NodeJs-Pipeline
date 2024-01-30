resource "aws_instance" "jenkins_server" {
    ami = "ami-03f4878755434977f"
    instance_type = "t2.micro"
    key_name = "jenkinsK"
    vpc_security_group_ids = ["sg-0473fa28869bebeb7"]
    user_data = file("install_software.sh")
    
    # connection {
    #     type = "ssh"
    #     user = "ubuntu"
    #     private_key = "${file("C:/Users/sushr/Downloads/jenkinsK.pem")}"
    #     host = aws_instance.jenkins_server.public_ip
    #     timeout = "2m"
    # }

    # provisioner "remote-exec" {
    #     inline = [
            
    #     ]
    # }

    tags = {
        Name =  "JenkinsP_server"
    }
}

resource "null_resource" "jenPass" {

    depends_on = [aws_instance.jenkins_server]

    connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file("C:/Users/sushr/Downloads/jenkinsK.pem")}"
        host = aws_instance.jenkins_server.public_ip
        timeout = "2m"
    }

#     provisioner "file" {
#         source = "install_software.sh"
#         destination = "/tmp/install_software.sh"
#     }

#     # provisioner "remote-exec" {
#     #     inline = [
#     #         "sudo apt update -y",
#     #         "sudo apt install -y openjdk-17-jre",
#     #         "java --version",
#     #         "sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key",
#     #         "echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
#     #         "sudo apt-get update -y",
#     #         "sudo apt-get install -y jenkins",
#     #         "sudo apt-get install -y jenkins",
#     #         "sudo systemctl enable jenkins",
#     #         "sudo systemctl start jenkins",
#     #         "sudo systemctl status jenkins", 
#     #     ]
#     # }

    provisioner "remote-exec" {
        inline = [
            "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
        ]
    }
}

output "website_url" {

    # depends_on = [null_resource.jenPass]

    value = join("", ["http://", aws_instance.jenkins_server.public_dns, ":", "8080"])
}