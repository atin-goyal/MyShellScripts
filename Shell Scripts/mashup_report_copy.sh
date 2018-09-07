#!/bin/bash
#set -x
catalog_dir="/bi/domain/fmw/user_projects/domains/bi/bidata/service_instances/service1-bitenant9/metadata/content/catalog"
# user where psr1,2,3 reports are created already
primary_user_no=7
start_user_no=8
end_user_no=8
for (( i=$start_user_no;i<=$end_user_no;i++ ))
do
        cp -a $catalog_dir/root/users/rpd_empl${primary_user_no}/psr* $catalog_dir/root/users/rpd_empl${i}
        sed -i 's/RPD_EMPL'${primary_user_no}'/RPD_EMPL'${i}'/g' $catalog_dir/root/users/rpd_empl${i}/psr*.atr
        sed -i 's/RPD_EMPL'${primary_user_no}'/RPD_EMPL'${i}'/g' $catalog_dir/root/users/rpd_empl${i}/psr*/*.atr
        sed -i 's/RPD_EMPL'${primary_user_no}'/RPD_EMPL'${i}'/g' $catalog_dir/root/users/rpd_empl${i}/psr*/_projectdefn
        sed -i 's/RPD_EMPL'${primary_user_no}'/RPD_EMPL'${i}'/g' $catalog_dir/root/users/rpd_empl${i}/psr*/screenshots/*.atr
done
exit