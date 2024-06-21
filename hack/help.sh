#!/bin/bash

banner="
        __   __   __               __  
       /  \` /  \ |__)  /\  |    | /  \ 
       \__, \__/ |  \ /~~\ |___ | \__/ "
      
echo ""
echo "⎈ Welcome to CORALIO-CLUSTER-TEMPLATE ⎈"
echo "${banner}"
echo -e "\n\e[1mUsage:\e[0m"
echo ""
echo -e "  \e[37mtask\e[0m \e[94mhelp\e[0m            -> \e[94mDisplay this message\e[0m"
echo -e "  \e[37mtask\e[0m \e[94menv\e[0m\e[37m:\e[0m\e[94mprepare\e[0m     -> \e[94mPrepare the environment for the project\e[0m"
echo -e "  \e[37mtask\e[0m \e[94menv\e[0m\e[37m:\e[0m\e[94minstall\e[0m     -> \e[94mInstall project dependencies\e[0m"
echo -e "  \e[37mtask\e[0m \e[94mcluster\e[0m\e[37m:\e[0m\e[94minit\e[0m    -> \e[94mProvision the Kubernetes cluster\e[0m"
echo -e "  \e[37mtask\e[0m \e[94mcluster\e[0m\e[37m:\e[0m\e[94mreset\e[0m   -> \e[94mReset the Kubernetes cluster\e[0m"
echo -e "  \e[37mtask\e[0m \e[94mcluster\e[0m\e[37m:\e[0m\e[94mupgrade\e[0m -> \e[94mUpgrade the Kubernetes cluster\e[0m"
echo -e "  \e[37mtask\e[0m \e[94mcluster\e[0m\e[37m:\e[0m\e[94mbackup\e[0m  -> \e[94mCreate cluster Backup\e[0m"
echo -e "  \e[37mtask\e[0m \e[94mnodes\e[0m\e[37m:\e[0m\e[94mcheck\e[0m     -> \e[94mVerify Cluster Nodes Connectivity\e[0m"
echo -e "  \e[37mtask\e[0m \e[94mnodes\e[0m\e[37m:\e[0m\e[94mlist\e[0m      -> \e[94mDisplay Ansible Inventory\e[0m"
echo -e "  \e[37mtask\e[0m \e[94mnodes\e[0m\e[37m:\e[0m\e[94mreboot\e[0m    -> \e[94mReboot Cluster nodes\e[0m"
echo -e "  \e[37mtask\e[0m \e[94mpolicy\e[0m\e[37m:\e[0m\e[94menable\e[0m   -> \e[94mEnable kyverno Policies\e[0m"
echo -e "  \e[37mtask\e[0m \e[94mpolicy\e[0m\e[37m:\e[0m\e[94mdisable\e[0m  -> \e[94mDisable kyverno Policies\e[0m"
echo ""