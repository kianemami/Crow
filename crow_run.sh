#!/bin/bash
nohup Crow > /var/log/crow/sys_log/$(date "+%Y_%m_%d-%H_%M_%S").log 2>&1 &