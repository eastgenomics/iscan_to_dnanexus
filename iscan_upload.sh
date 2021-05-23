auth_token=$(cat /mnt/storage/data/DNAnexus/iScan/api_token)

# iScan data to be uploaded is stored locally within this dir
iscan_dir="/mnt/storage/samba/samba.ctrulab.uk/cytogenetics/iScan"

# Upload agent executable is stored locally in this dir
ua_path="/mnt/storage/apps/software/dnanexus_ua/1.5.31"


# Upload data in GS_reports dir
reports_command="${ua_path}/ua --auth-token $auth_token --recursive --project=project-G2Y0BFj4xX2f1kKp5QbP7VJX $iscan_dir/GS_reports"

echo $reports_command
eval $reports_command

reports_exit_code=$?


# Upload data in GS_projects dir
projects_command="${ua_path}/ua --auth-token $auth_token --recursive --project=project-G2Y0BFj4xX2f1kKp5QbP7VJX $iscan_dir/GS_projects"

echo $projects_command
eval $projects_command

projects_exit_code=$?

# Output results summary
printf '\n\n\n\n##### RESULT #####\n\n'

if [ $reports_exit_code -ne 0 ]; then
    echo "Upload ERROR. A problem was encountered when uploading GS_reports/. Error code: ${reports_exit_code}"
fi

if [ $projects_exit_code -ne 0 ]; then
    echo "Upload ERROR. A problem was encountered when uploading GS_projects/. Error code: ${projects_exit_code}"
fi

if [ $reports_exit_code -eq 0 ] && [ $projects_exit_code -eq 0 ]; then
    echo "Upload SUCCESSFUL"
fi

printf '\n##################\n\n'
