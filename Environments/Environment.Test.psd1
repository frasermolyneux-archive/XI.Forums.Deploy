@{
    ElasticBeanstalk  = @{
        EnvironmentName = "XtremeIdiotsForums-Test"

        OptionSettings    = @(
            ## Auto Scaling
            @{
                Namespace  = "aws:autoscaling:launchconfiguration"
                OptionName = "InstanceType"
                Value      = "t2.micro"
            }
            @{
                Namespace  = "aws:autoscaling:asg"
                OptionName = "MinSize"
                Value      = "1"
            }
            @{
                Namespace  = "aws:autoscaling:asg"
                OptionName = "MaxSize"
                Value      = "1"
            }
        )
    }

    SecretAppSettings = @{
        SECSecretId = "xi-forums-test"
    }

    AppSettings       = @{
        "website_base_url" = "https://test.xtremeidiots.com/"
    }
}