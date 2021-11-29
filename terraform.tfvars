database_name           = "wordpress"             //database name
database_user           = "devops"                //database username
region                  = "eu-central-1"          //europe region
ami                     = "ami-0bd99ef9eccfee250" //ubuntu 20.04 ami
key_name                = "Frankfurt-key"         //key name for ec2, make sure it is created before terrafomr apply
instance_type           = "t2.micro"              //type pf instance
database_password       = "passwd0123"            //password for user database
