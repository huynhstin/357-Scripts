#!/bin/bash
exec $(find //home/kmammen/357/${PWD##*/} -type f -executable) $@
