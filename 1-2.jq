def group:
if .input == [] then .
elif .input[0] != "" then
{input: .input[1:],
acc: (.acc + [.input[0] | tonumber]), groups: .groups}
     | group
     else {input: .input[1:],
	     acc: [],
	     groups: (.groups + [.acc])} | group
	     end
;

def split_by_empty:
  {input: ., acc: [], groups: []} | group | .groups;                                                                                                                                                    
[[inputs] | split_by_empty[] | add] | sort | reverse | .[:3] | add
