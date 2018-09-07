#!/bin/bash
tail -f -n0 /u01/app/fmw/user_projects/domains/bifoundation_domain/servers/bi_server1/logs/access.log > ${1}_BI_Access.log &
tail -f -n0 /u01/app/fmw/user_projects/domains/bifoundation_domain/servers/bi_server1/logs/bi_server1.log > ${1}_bi_server1.log &
tail -f -n0 /u01/app/instances/instance1/diagnostics/logs/OracleBIServerComponent/coreapplication_obis1/nqquery.log > ${1}_nqquery.log &
tail -f -n0 /u01/app/instances/instance1/diagnostics/logs/OracleBIPresentationServicesComponent/coreapplication_obips1/sawlog3.log > ${1}_saw.log &
exit
