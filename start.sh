#!/bin/bash
###########################################################################
##       ffff55555                                                       ##
##     ffffffff555555                                                    ##
##   fff      f5    55         Deployment Script Version 0.0.1           ##
##  ff    fffff     555                                                  ##
##  ff    fffff f555555                                                  ##
## fff       f  f5555555             Written By: EIS Consulting          ##
## f        ff  f5555555                                                 ##
## fff   ffff       f555             Date Created: 12/02/2015            ##
## fff    fff5555    555             Last Updated: 12/02/2015            ##
##  ff    fff 55555  55                                                  ##
##   f    fff  555   5       This script will start the pre-configured   ##
##   f    fff       55       WAF configuration.                          ##
##    ffffffff5555555                                                    ##
##       fffffff55                                                       ##
###########################################################################
###########################################################################
##                              Change Log                               ##
###########################################################################
## Version #     Name       #                    NOTES                   ##
###########################################################################
## 11/23/15#  Thomas Stanley#    Created base functionality              ##
###########################################################################

### Parameter Legend  ###
## devicearr=0 #hostname of this device
## devicearr=1 #IP address of this device
## devicearr=2 #login password for the WAF
## devicearr=3 #BYOL License key
## devicearr=4 #the name of the application
## vipportarr=0 #port numbers of the BIG-IP VIP semicolon delimited (80;443;8080)
## protocolarr=0 #protocol for the VIP like http or https semicolon delimited
## hostarr=0 #ip address of the application servers, or fqdn of applicaiton
## hostarr=1 #region or location of the URL (westus, eastus)
## appportarr=0 #the port of the application (80;443;8080)
## asmarr=0 # linux or windows
## asmarr=1 #blocking level, high medium low
## asmarr=2 #fqdn for the application
## asmarr=3 #secure string of SSL certificate file
## asmarr=4 #secure string of SSL key file
## asmarr=5 #secure string of SSL chain file

## Build the arrays based on the semicolon delimited command line argument passed from json template.
#devicearr=(${1//;/ })
#vipportarr=(${2//;/ })
#protocolarr=(${3//;/ })
#hostarr=(${4//;/ })
#appportarr=(${5//;/ })
#asmarr=(${6//;/ })
echo $1 > /config/blackbox_out
echo $2 >> /config/blackbox_out
echo $3 >> /config/blackbox_out
echo $4 >> /config/blackbox_out
echo $5 >> /config/blackbox_out
echo $6 >> /config/blackbox_out


IFS=';' read -ra devicearr <<< "$1"
for i in "${devicearr[@]}"
do
	echo "$i" >> /config/blackbox_out_2
done
IFS=';' read -ra vipportarr <<< "$2"
for i in "${vipportarr[@]}"
do
	echo "$i" >> /config/blackbox_out_2
done
IFS=';' read -ra protocolarr <<< "$3"
for i in "${protocolarr[@]}"
do
	echo "$i" >> /config/blackbox_out_2
done
IFS=';' read -ra hostarr <<< "$4"
for i in "${hostarr[@]}"
do
	echo "$i" >> /config/blackbox_out_2
done
IFS=';' read -ra appportarr <<< "$5"
for i in "${appportarr[@]}"
do
	echo "$i" >> /config/blackbox_out_2
done
IFS=';' read -ra asmarr <<< "$6"
for i in "${asmarr[@]}"
do
	echo "$i" >> /config/blackbox_out_2
done

## Construct the blackbox.conf file using the arrays.
row1='"1":["'${vipportarr[0]}'","'${protocolarr[0]}'",["'${hostarr[0]}':'${appportarr[0]}'"],"","","","","","'${asmarr[0]}'","'${asmarr[1]}'","yes","yes","yes","wanlan","'${asmarr[2]}'","yes","","","","",""]'
row2='"2":["'${vipportarr[1]}'","'${protocolarr[1]}'",["'${hostarr[0]}':'${appportarr[1]}'"],"","","","","","'${asmarr[0]}'","'${asmarr[1]}'","yes","yes","yes","wanlan","'${asmarr[2]}'","yes","","","'${asmarr[3]}'","'${asmarr[4]}'","'${asmarr[5]}'"]'

deployment1='"deployment_'${devicearr[4]}'.'${hostarr[1]}'.cloudapp.azure.com":{"traffic-group":"none","strict-updates":"disabled","variables":{"configuration__saskey":''"tAjn8Xuzelj9ps4HzRsHXqXznAIiHPFIzlSC08De2Zk=","configuration__saskeyname":"sharing-is-caring","configuration__eventhub":"event-horizon",''"configuration__eventhub_namespace":"event-horizon-ns","configuration__applianceid":"8A3ED335-F734-449F-A8FB-335B48FE3B50",''"configuration__logginglevel":"Alert","configuration__loggingtemplate":"CEF"},"tables":{"configuration__destination":{"column-names":[''"port","mode","backendmembers","monitoruser","monitorpass","monitoruri","monitorexpect","asmtemplate","asmapptype","asmlevel","l7ddos",''"ipintel","caching","tcpoptmode","fqdns","oneconnect","sslpkcs12","sslpassphrase","sslcert","sslkey","sslchain"],"rows":{'$row1','$row2'}}}}'

jsonfile='{"loadbalance":{"is_master":"true","master_hostname":"","master_address":"","master_password":"'${devicearr[2]}'"'',"device_hostname":"'${devicearr[0]}'","device_address":"'${devicearr[1]}'","device_password":"'${devicearr[2]}'"},"bigip":{"application_name":"Azure Security F5 WAF"'',"ntp_servers":"1.pool.ntp.org 2.pool.ntp.org","ssh_key_inject":"false","change_passwords":"false","license":{"basekey":"'${devicearr[3]}'"},''"modules":{"auto_provision":"true","ltm":"nominal","afm":"none","asm":"nominal"},"redundancy":{"provision":"false"},"network"'':{"provision":"false"},"iappconfig":{"f5.rome_waf":{"template_location":''"http://cdn-prod-ore-f5.s3-website-us-west-2.amazonaws.com/product/blackbox/staging/azure/f5.rome_waf.tmpl","deployments":{'$deployment1'}}}}}'

echo $jsonfile > /config/blackbox.conf



## Move the files and run them.
mv ./blackboxstartup.sh /config/blackboxstartup.sh
chmod u+x /config/blackboxstartup.sh
#bash /config/blackboxstartup.sh
