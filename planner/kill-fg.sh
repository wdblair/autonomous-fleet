#!/bin/bash

kill -s SIGTERM $(cat $1.pid)
