#!/usr/bin/python
# coding:utf-8

__author__ = 'Frank'
__version__ = '1.0.1'

from fabric.api import lcd, local, cd, hosts, task, settings, env
from fabric.operations import run, put
from fabric.contrib.project import rsync_project


@task
def build(platform='ios'):
    local('flutter packages pub run build_runner build --delete-conflicting-outputs')

    if (platform == 'ios'):
        local('flutter build ios')
        local('echo "请用xcode继续打包ipa文件"')
    else:
        local('flutter build apk --split-per-abi')

