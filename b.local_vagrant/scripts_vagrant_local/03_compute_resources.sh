#!/usr/bin/env bash

vagrant up --parallel > /dev/null

vagrant ssh master -c "echo 'Hello from' \$(hostname -s)"
