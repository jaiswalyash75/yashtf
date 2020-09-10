#!/bin/bash
sudo yum install mysql -y
mysql -h ${address} -u yash -pyashjazz yashdb <<EOF
use yashdb
create table employee(id int,name text);
insert into employee values (1,"yash");
EOF