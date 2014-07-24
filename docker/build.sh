#!/bin/sh
pandoc -t revealjs  --template=template.html  --no-highlight --variable theme="night" --variable transition="linear" -s intro_docker.md -o intro_docker.html

perl -p -i -e 's/<li>/<li class="fragment roll-in">/g' intro_docker.html
perl -p -i -e 's/<code>/<code class="fragment roll-in">/g' intro_docker.html
