#!/bin/bash
# run this from the fodler where  you have all the tf files and the plan file
terraform graph | dot -Tsvg > graph.svg