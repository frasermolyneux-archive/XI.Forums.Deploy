@{
    ElasticBeanstalk  = @{
        EnvironmentName = "XtremeIdiotsForums-Live"
    }

    SecretAppSettings = @{
        SECSecretId = "xi-forums-live"
    }

    AppSettings       = @{
        #"website_base_url" = "https://www.xtremeidiots.com/"
        "website_base_url" = "https://XtremeIdiotsForums-Live.pcdqwmijaj.us-east-2.elasticbeanstalk.com/"
    }
}