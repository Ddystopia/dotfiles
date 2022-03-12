function proxy_on() {
  function export_proxy() {
    export http_proxy="$1" \
           https_proxy=$1 \
           ftp_proxy=$1 \
           rsync_proxy=$1 \
           all_proxy=$1 \
           HTTP_PROXY=$1 \
           HTTPS_PROXY=$1 \
           FTP_PROXY=$1 \
           RSYNC_PROXY=$1
           ALL_PROXY=$1
  }
  export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"

  if (( $# > 0 )); then
      valid=$(echo $@ | sed -n -E 's/([0-9]{1,3}.?){4}:([0-9]+)|localhost/&/p')
      if [[ $valid != $@ ]]; then
          >&2 echo "Invalid address"
          return 1
      fi
      export_proxy $1
      echo "Proxy environment variable set."
      return 0
  fi

echo -n "username: "; read username
  if [[ $username != "" ]]; then
      echo -n "password: "
      read -es password
      local pre="$username:$password@"
  fi

  echo -n "server: "; read server
  echo -n "port: "; read port
  export_proxy $pre$server:$port
}

function proxy_off(){
  unset http_proxy https_proxy ftp_proxy rsync_proxy \
        HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY
  echo -e "Proxy environment variable removed."
}
