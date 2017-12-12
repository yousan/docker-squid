#!/bin/bash

SQUID_HOME=/home/squid/local

#$SQUID_HOME/sbin/squid -N 1> $SQUID_HOME/var/logs/squid_stdout.log 2> $SQUID_HOME/var/logs/squid_stderr.log
/home/squid/local/sbin/squid -N
