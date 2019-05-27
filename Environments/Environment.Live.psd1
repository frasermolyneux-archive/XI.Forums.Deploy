@{
    ElasticBeanstalk  = @{
        EnvironmentName = "XtremeIdiotsForums-Live"

        OptionSettings    = @(
            ## Auto Scaling
            @{
                Namespace  = "aws:autoscaling:launchconfiguration"
                OptionName = "InstanceType"
                Value      = "t2.small"
            }
            @{
                Namespace  = "aws:autoscaling:asg"
                OptionName = "MinSize"
                Value      = "2"
            }
            @{
                Namespace  = "aws:autoscaling:asg"
                OptionName = "MaxSize"
                Value      = "2"
            }
        )
    }

    SecretAppSettings = @{
        SECSecretId = "xi-forums-live"
    }

    AppSettings       = @{
        "website_base_url" = "https://www.xtremeidiots.com/"
    }
}