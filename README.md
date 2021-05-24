<!-- dx-header -->

# iscan_to_dnanexus
Upload data from local server to DNAnexus

## What does this tool do?
Identifies iScan data stored on local server an uploads to specific DNAnexus project using upload agent

## What are typical use cases for this tool?
Usually run once a week by Duty Bioinformatician to push new iScan data to DNAnexus

## What data are required for this app to run?
iScan data and api token must be available (with appropriate permissions) on the local server

## What does this tool output?
Outputs to STDOUT. 
A SUCCESS/ERROR outcome is displayed within the RESULTS section at the end of the STDOUT.

Exit code 0 indicates successful upload of all files

Non-zero exit codes indicate unsuccessful upload of files, and should be investigated and resolved
