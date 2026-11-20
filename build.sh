#!/bin/sh
# Build dist/: the full bundle plus one bundle per era, each with a minified copy.
# Order matters: core → classic races → modern layer → StarCraft II layer.
set -e
cd "$(dirname "$0")"
mkdir -p dist

CORE="src/core.css"
CLASSIC="src/races/terran.css src/races/zerg.css src/races/protoss.css"
MODERN="src/hd/base.css src/hd/terran.css src/hd/zerg.css src/hd/protoss.css"
SC2="src/sc2/base.css src/sc2/terran.css src/sc2/zerg.css src/sc2/protoss.css"

bundle() { # name, files...
  name=$1; shift
  cat "$@" > "dist/$name.css"
  # Minify: strip comments, collapse whitespace.
  perl -0pe 's{/\*.*?\*/}{}gs; s/\s+/ /g; s/\s*([{};,>])\s*/$1/g; s/;}/}/g' "dist/$name.css" > "dist/$name.min.css"
}

bundle starcraft         $CORE $CLASSIC $MODERN $SC2   # every theme
bundle starcraft-classic $CORE $CLASSIC                # sc-terran | sc-zerg | sc-protoss
bundle starcraft-modern  $CORE $CLASSIC $MODERN        # + sc-hd
bundle starcraft-sc2     $CORE $SC2                    # sc2 sc2-<race>

wc -c dist/*.min.css
