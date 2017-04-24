source script/global_conf.sh
issue=$(cat /etc/issue)
if [[ ! $issue =~ $server_version ]]; then
  echo "Error Linux Version no match! Please use the project with Ubuntu 16.04.2"
  exit $ERROR_CODE
fi
