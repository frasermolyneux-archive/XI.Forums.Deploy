@{
    ElasticBeanstalk  = @{
        ApplicationName   = "XtremeIdiotsForums"
        SolutionStackName = "64bit Amazon Linux 2018.03 v2.9.4 running PHP 7.3"
        TierType          = "Standard"
        TierName          = "WebServer"

        OptionSettings    = @(
            ## Auto Scaling
            @{
                Namespace  = "aws:autoscaling:launchconfiguration"
                OptionName = "IamInstanceProfile"
                Value      = "aws-elasticbeanstalk-ec2-role"
            }

            ## Load Balancer
            @{
                Namespace  = "aws:elasticbeanstalk:environment"
                OptionName = "LoadBalancerType"
                Value      = "application"
            }

            ## Load Balancer - 80
            @{
                Namespace  = "aws:elasticbeanstalk:environment:process:default"
                OptionName = "StickinessEnabled"
                Value      = "true"
            }
            @{
                Namespace  = "aws:elasticbeanstalk:environment:process:default"
                OptionName = "StickinessLBCookieDuration"
                Value      = "900"
            }
            @{
                Namespace  = "aws:elasticbeanstalk:environment:process:default"
                OptionName = "MatcherHTTPCode"
                Value      = "301" # Redirect in this case is 'healthy' - TODO: put in a health check page
            }

            ## Load Balancer - 443
            @{
                Namespace  = "aws:elbv2:listener:443"
                OptionName = "DefaultProcess"
                Value      = "default"
            }
            @{
                Namespace  = "aws:elbv2:listener:443"
                OptionName = "ListenerEnabled"
                Value      = "true"
            }
            @{
                Namespace  = "aws:elbv2:listener:443"
                OptionName = "Protocol"
                Value      = "HTTPS"
            }
            @{
                Namespace  = "aws:elbv2:listener:443"
                OptionName = "SSLCertificateArns"
                Value      = "arn:aws:acm:us-east-2:779496319502:certificate/92d6b75b-1327-4db6-9272-4b36997ab41a"
            }
            @{
                Namespace  = "aws:elbv2:listener:443"
                OptionName = "SSLPolicy"
                Value      = "ELBSecurityPolicy-TLS-1-2-2017-01"
            }

            ## Reporting
            @{
                Namespace  = "aws:elasticbeanstalk:healthreporting:system"
                OptionName = "SystemType"
                Value      = "enhanced"
            }

            ## Deployment Policy
            @{
                Namespace  = "aws:elasticbeanstalk:command"
                OptionName = "DeploymentPolicy"
                Value      = "Immutable"
            }
            @{
                Namespace  = "aws:autoscaling:updatepolicy"
                OptionName = "RollingUpdate"
                Value      = "Immutable"
            }
            @{
                Namespace  = "aws:elasticbeanstalk:command"
                OptionName = "HealthCheckSuccessThreshold"
                Value      = "Warning"
            }
            @{
                Namespace  = "aws:elasticbeanstalk:command"
                OptionName = "Timeout"
                Value      = "900"
            }
        )
    }

    ArtifactS3Bucket  = @{
        BucketName = "ips-application-artifacts"
    }

    SecretAppSettings = @{
        SecretKeys = @(
            "dbusername"
            "dbpassword"
            "dbserver"
            "dbname"
        )
    }

    AppSettings       = @{
        "dbport"       = "3306"
        "guest_group"  = "2"
        "member_group" = "82"
        "admin_group"  = "61"
    }

    FilesToTokenise   = @(
        "conf_global.php"
        "constants.php"
    )
}