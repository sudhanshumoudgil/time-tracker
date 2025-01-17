!/bin/bash
set -x
clear
red=`echo -en "\e[31m"`
normal=`echo -en "\e[0m"`
green=`echo -en "\e[42m"`;
export DEBIAN_FRONTEND=noninteractive
#----------------------------
echo ""
PS3=${red}'Please enter your choice: '${normal}
echo 'Select your WebServer: '
options=(${green}"apache2"${normal} ${green}"nginx"${normal})
select opt in "${options[@]}"
do
  echo "${opt}"
  sudo apt-get update
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 5BA31D57EF5975CA
  sudo apt-get install ${opt} -y
  sudo systemctl restart ${opt}
  break
done
#----------------------------
echo ""
PS3='Please enter your choice: '
echo 'Select your PHP versions: '
options=("8.1" "7.4")
select php_ver in "${options[@]}"
do
    echo "php${php_ver}"
    sudo apt update -y
    sudo apt install software-properties-common ca-certificates lsb-release apt-transport-https -y
    LC_ALL=C.UTF-8 sudo add-apt-repository ppa:ondrej/php -y
    sudo apt update
    sudo apt install php${php_ver} -y
    break
done
echo ""
PS3='Please enter your choice: '
echo 'Select your Database: '
options=("MySQL" "mariaDB" "Quit")
select opt in "${options[@]}"
do
  case $opt in
    "MySQL")
      PS3='Please enter your choice: '
      echo 'Select your MySQL version: '
      mysql_versions=("8.0" "5.7")
      select mysql_ver in "${mysql_versions[@]}"
      do
        case $mysql_ver in
          "8.0")
            echo "mySQL${mysql_ver}"
            sudo apt-get update
            sudo apt install mysql-client -sudo systemctl unmask mysql.service
            sudo systemctl restart mysql
            sudo systemctl status mysql
            break;;
          "5.7")
            sudo apt update
            sudo apt install wget -y
            wget https://dev.mysql.com/get/mysql-apt-config_0.8.12-1_all.deb
            sudo dpkg -i mysql-apt-config_0.8.12-1_all.deb
            sudo apt-get update
            sudo apt-cache policy mysql-server
            sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 467B942D3A79BD29
            sudo apt update
            sudo apt install -f mysql-client=5.7* mysql-community-server=5.7* mysql-server=5.7*
            sudo systemctl status mysql
            break;;
        esac
        mysql -V
      done
      break;;
    "mariaDB")
      PS3='Please enter your choice: '
      echo 'Select your mariaDB version: '
      mariadb_versions=("11.0" "10.11" "10.10")
      select maria_ver in ${mariadb_versions[@]}
        do
          echo "mariaDB${maria_ver}"
          sudo apt-get update  -y
          sudo apt install wget -y
          sudo wget https://mirrors.aliyun.com/mariadb/mariadb-${maria_ver}.*/bintar-linux-systemd-x86_64/mariadb-${maria_ver}.*-linux-systemd-x86_64.tar.gz
          groupadd mysql
          useradd -g mysql mysql
          current_path=$pwd
          cd /usr/local
          tar -zxvpf ${current_path}/mariadb-11.0.1-linux-systemd-x86_64.tar.gz
          ln -s mariadb-11.0.1-linux-systemd-x86_64.tar.gz
          cd mysql
          ./scripts/mysql_install_db --user=mysql
          chown -R root .
          chown -R mysql data
          sudo apt-get install libncurses5
          break
        done
        break;;
    "Quit")
        break;;
    *) echo "invalid option $REPLY";;
  esac
done
#----------------- END -----------------#


            
