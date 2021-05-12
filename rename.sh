#!/bin/sh

find . -type f -name '.gitignore' -exec sed -i 's/phoenix_starter/dashy/g' {} \;
find . -type f -regex '.*\.\(eex\|ex\|exs\|leex\|md|json|yml\)' -exec sed -i 's/phoenix_starter/dashy/g' {} \;
find . -type f -regex '.*\.\(eex\|ex\|exs\|leex\|md|json|yml\)' -exec sed -i 's/PhoenixStarter/Dashy/g' {} \;
rename  's/phoenix_starter/dashy/' **/*