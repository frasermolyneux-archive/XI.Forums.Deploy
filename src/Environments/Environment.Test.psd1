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
        )
    }

    SecretAppSettings = @{
        SECSecretId = "xi-forums-test"
    }

    AppSettings       = @{
        "website_base_url" = "https://test.xtremeidiots.com/"
    }
}