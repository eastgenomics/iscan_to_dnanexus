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
Output/error logs from upload agent

# Instructions

## Setting the config file

A config file must be written before invoking the script. The file can have any name, but must be written as follows:

```
AUTH_TOKEN_PATH=
ISCAN_DIR=
UPLOAD_AGENT_PATH=
DX_PROJECT_ID=
```

The config fields are defined as follows:

- `AUTH_TOKEN_PATH`: path to a file containing your DNANexus API token
- `ISCAN_DIR`: path to parent folder containing iScan output data
- `UPLOAD_AGENT_PATH`: path to DNANexus Upload Agent executable (see https://documentation.dnanexus.com/downloads#upload-agent)
- `DX_PROJECT_ID`: Target DNANexus project identifier

See `iscan_upload.conf.example` for a template.

## Exporting the config file

The file must then be stored as a bash variable with `export` - run the following before executing the script:

`export ISCAN_CONFIG_PATH=/path/to/your_config.conf`

## Running the script

Run the following:

`bash iscan_upload.sh`

The script will parse the config file stored in `ISCAN_CONFIG_PATH`, and begin uploading your data to DNANexus.

## Troubleshooting

### `iscan_upload.sh: line 20: $ISCAN_CONFIG_PATH: ambiguous redirect`

This means you didn't define or export `ISCAN_CONFIG_PATH`, or the path you entered doesn't point to an existing file.
