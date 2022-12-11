[
  foreach (inputs/" "
          | [.[0], (.[1] // empty | tonumber)]) as $command
  ({X: 1}; $command; .)
]
