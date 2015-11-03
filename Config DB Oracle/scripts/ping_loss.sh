#!/bin/bash
#================================================================================
#
#  Programa :  ping_loss.sh
#
#  Objetivo :  Informa se existe perda de pacotes em ambientes RAC.
#
#================================================================================

COUNT=$1
ADDRESS=$2
RESULT=$(ping -c $COUNT ${ADDRESS} 2> /dev/null| grep "packet loss" | awk -F, '{print $3}' | awk -F\% '{print $1}' ) 
echo $RESULT
