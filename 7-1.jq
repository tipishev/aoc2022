def tokenize: [.[] | split(" ")];

def advance_input: . + {input: .input[1:]};
def push_dir:
  . + {working_dir: (.working_dir + [.input[0][2]])}
  | advance_input;
def pop_dir:
  . + {working_dir: .working_dir[:-1]}
  | advance_input;

def add_file:
  . as $state
  | (.input[0][0] | tonumber) as $size
  | .input[0][1] as $filename
  # | . + {output: (.output  + ({($filename): $size})) }
  | setpath(["output"] + .working_dir + [$filename]; $size)
  | advance_input
;

def _parse:
  . as $state
  | .input
  | first
  | if . == null
      then $state.output 
    elif ([.[0], .[1]] == ["$", "ls"] or .[0] == "dir")
      then $state | advance_input | _parse
    elif [.[0], .[1]] == ["$", "cd"]
      then
        if .[2] == ".." then $state | pop_dir | _parse
	else $state | push_dir | _parse
	end
    else
      $state | add_file | _parse
    end
;
def parse: {input: ., working_dir:[], output:{} } | _parse;

def size:
  [to_entries
  | .[]
  | if (.value | type) == "number"
      then .value
    elif (.value | type) == "object"
      then .value | size
    else
      error("unsizable")
    end
  ]
  | add;

def extract_dirs:
  recurse
  | if (. | type) == "object"
      then to_entries
      | .[]
      | if (.value | type) == "number"
          then empty
	elif (.value | type) == "object"
	  then [.key, .value]
	else
	  empty
	end
    else empty
    end
;


[[inputs] | tokenize | parse | extract_dirs | [.[0], (.[1] | size)] 
| select(.[1] <= 100000) | .[1] ] | add 
