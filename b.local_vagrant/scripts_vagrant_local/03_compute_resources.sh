#!/usr/bin/env bash

vagrant up

vagrant ssh master -c "echo \"Hello from \$(hostname -s)\""
