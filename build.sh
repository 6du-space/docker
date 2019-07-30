#!/usr/bin/env bash

cd $(dirname "$0")

sudo docker build -t dev .
