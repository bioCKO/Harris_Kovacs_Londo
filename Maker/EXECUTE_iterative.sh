#!/bin/bash

./iterative_rbh.sh | sed -e 's/\\_/_/g' | sed 's/ugh_/ugh\\_/g' > do_rbh.sh; chmod 777 do_rbh.sh
touch iterative_rbh.sqlite
