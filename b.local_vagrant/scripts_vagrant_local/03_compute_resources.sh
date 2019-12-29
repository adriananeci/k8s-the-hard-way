#!/usr/bin/env bash

vagrant up --parallel

vagrant ssh master -c "echo 'Hello from' \$(hostname -s)"
