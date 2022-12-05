def cheat_parse:
[
  ["B", "Q", "C"],
  ["R", "Q", "W", "Z"],
  ["B", "M", "R", "L", "V"],
  ["C", "Z", "H", "V", "T", "W"],
  ["D", "Z", "H", "B", "N", "V", "G"], ["H", "N", "P", "C", "J", "F", "V", "Q"],
  ["D", "G", "T", "R", "W", "Z", "S"],
  ["C", "G", "M", "N", "B", "W", "Z", "P"],
  ["N", "J", "B", "M", "W", "Q", "F", "P"]
]
;

def parse:
  [inputs]
  | join(",") | split(",,")  # split by empty line into stack and moves
  |{stack: [
      (.[0]
      | split(",")
      [:-1]                   # drop the stack labels row
      | .[]
      | gsub("   "; "."))       # use dot as a placeholder for empty
      | gsub("\\[|\\]| "; "")   # lose the brackets and spaces
      | split("")               # string to list
      | [.[] | if . == "."
         then null else . end]  # replace dots with nulls
    ]
  | transpose
  | [.[] | reverse]  # stackishly nulls are in the tail
  | [.[] | . - [null]],  # drop nulls 
  moves: [.[1] | split(",")[] | split(" ")
          | [.[1], .[3], .[5]] | [.[] | tonumber]]
  }
  | .stack |= cheat_parse  # FIXME
;

def process:
  if .moves == []
    then .stack
  else .moves[0] as $move
       | $move[0] as $count
       | $move[1] as $from
       | $move[2] as $to
       | (.stack[$from - 1][-$count:]) as $items
       | {
           moves: (.moves[1:]),
	   stack: (.stack
	           | (.[$from - 1] |= .[:-$count]
		   | .[$to - 1] |= . + $items))
         } | process
  end
;

def read_tops:
  [.[] | last] | join("");

parse | process | read_tops
