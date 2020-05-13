@{
    ElasticBeanstalk  = @{
        EnvironmentName = "XtremeIdiotsForums-Live"

        OptionSettings    = @(
            ## Auto Scaling
            @{
                Namespace  = "aws:autoscaling:launchconfiguration"
                OptionName = "InstanceType"
                Value      = "t2.medium"
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