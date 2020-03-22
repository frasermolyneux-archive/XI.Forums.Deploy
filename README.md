# XI.Forums.Deploy

These are the deployment scripts for the XtremeIdiots.com forums. They deploy the IPS Community platform to AWS.

## Build Status

[![Build Status](https://dev.azure.com/frasermolyneux/XtremeIdiots/_apis/build/status/frasermolyneux.XI.Forums?branchName=master)](https://dev.azure.com/frasermolyneux/XtremeIdiots/_build/latest?definitionId=84&branchName=master)

## Workflow

Workflow of the deployment:

* Ensures that the application exists in AWS, if not creates it
* Ensures that the environment exists and is updated, if not creates it
* Copies the ElasticBeanStalk extensions into the website directory
* Creates a new artifact archive in the working directory
* Ensures that an S3 bucket exists for artifacts
* Uploads the artifact archive to the S3 bucket

## Requirements

The AWSPowerShell module is required to be installed onto the machine running the deployment

## Useful Supporting Commands

`(Get-EBAvailableSolutionStackList).SolutionStackDetails` - This gives a list of the available solution stacks for the ElasticBeanstalk environment.
`Get-AWSRegion` - This gives a list of available regions.
