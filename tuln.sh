#!/bin/bash

#tuln - TCP, UDP, lisening ports, numerical addrs

# Case 1: Verifying that the web server is listening on port 80/443 
# and the database server is listening on port 3306
netstat -tuln | grep -E '(:80|:443|:3306)'


# Case 2: Checking if an SSH service is listening on port 22 when users cannot SSH into a server.
netstat -tuln | grep ':22'


# Case 3: Listing all open ports to verify against the organization’s security policy.
netstat -tuln


# Case 4: Checking the number of connections to a load balancer.
netstat -tuln | grep LISTEN | wc -l


# Case 5: Detecting unusual services that are listening on high-numbered ports
netstat -tuln | grep -E ':([3-9][0-9]{3,4}|[1-6][0-9]{4,5})'


# Case 6: Confirming that only ports 80 and 443 are open on a web server.
netstat -tuln | grep LISTEN
