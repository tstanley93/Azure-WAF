# Azure-WAF
Deploy F5 WAF Solution in Azure  

This will create a new resource group, and inside this new resource group it will configure the following;

* Availability Set
* Azure Load Balancer
* Network Security Group
* Storage Container
* Public IP Address
* NIC objects for the F5 WAF devices.
* F5 WAF Virtual Machine

The F5 WAF's will be fully configured with the base Security Blocking template that you chose, as well as being configured infront of the application you told setup about.  When completed the WAF's will pass traffic through the newly created Public IP address.  After some testing to make sure everything is working, you will want to complete the configuration by changing the DNS entry for your applicaiton to point at the newly created Public IP Address, and then locking down the Network Security Group ACL's to prevent any traffic from reaching your application except through the F5 WAF's.


<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Ftstanley93%2FAzure-WAF%2FMulti-WAF%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>


