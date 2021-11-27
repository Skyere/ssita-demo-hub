database_name           = "wordpress_db"          // database name
database_user           = "marti"                 //database username
shared_credentials_file = "C:/Users/Badmin/.aws"  //Access key and Secret key file location
region                  = "eu-central-1"          //sydney region
ami                     = "ami-0a49b025fffbbdac6" // ubuntu 20.04 ami
key_name                = "Frankfurt-key"         // key name for ec2, make sure it is created before terrafomr apply
instance_type           = "t2.micro"              //type pf instance
database_password       = "PassWord4-user" //password for user database