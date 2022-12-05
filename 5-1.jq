def _parse_line:
  if .input == "" then .output
  else
    .input[:3] as $three_chars
    | if $three_chars == "   "
      then {
              input: .input[4:],
	      output: (.output + [null])
           } | _parse_line
      else {
             input: .input[4:],
	     output: (.output + [$three_chars[1:2]])
           } | _parse_line
      end 
  end
;

def parse_line: {input: ., output: []} | _parse_line;

def parse:
  [inputs]
  | join(",") | split(",,")  # split by empty line into stack and moves
  |{stack: [
      .[0]
      | split(",")
      | .[]
      | parse_line
    ]
  | transpose
  | [.[] | reverse]  # stackishly nulls are in the tail
  | [.[] | . - [null]],  # drop nulls 
  moves: [.[1] | split(",")[] | split(" ")
          | [.[1], .[3], .[5]] | [.[] | tonumber]]
  }
  # | .stack |= cheat_parse  # FIXME
;

def process:
  if .moves == []
    then .stack
  elif .moves[0][0] == 0
    then {
           moves: .moves[1:],
	   stack: .stack
         } | process
  else .moves[0] as $move
       | $move[0] as $count
       | $move[1] as $from
       | $move[2] as $to
       | (.stack[$from - 1] | last) as $item
       | {
           moves: ([[$count - 1, $from, $to]] + .moves[1:]),
	   stack: (.stack
	           | (.[$from - 1] |= .[:-1]
		   | .[$to - 1] |= . + [$item]))
         } | process
  end
;

def read_tops:
  [.[] | last] | join("");

parse | process | read_tops
