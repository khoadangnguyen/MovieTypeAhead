#!/bin/bash

string=""

echo "Type any character to search (Press Esc to exit, Enter to reset)..."

while true; do
  IFS= read -rsn1 char

  if [[ $char == $'\e' ]]; then
    echo -e "\nEscape key is pressed. Exiting..."
    break
  elif [[ $char == '' ]]; then
    echo -e "\nEnter key is pressed. Reset..."
    string=""
  elif [[ $char == ' ' ]]; then
    string+=" "
  elif [[ "$char" = $'\x7f' || "$char" = $'\x08' ]]; then
    if [[ ${#string} -gt 0 ]]; then
      # Remove last character
      string="${string%${string: -1}}"
    fi
  else
    string+="${char}"
  fi

  if [[ ${#string} -gt 0 ]]; then
    echo -e "\r\033[KSuggestions for: $string"
    response=$(curl -H "Content-Type: application/json" --silent --request GET 'http://localhost:9200/autocomplete/_search' \
     --data-raw '{
         "size": 15,
         "query": {
             "multi_match": {
                 "query": "'"$string"'",
                 "type": "bool_prefix",
                 "fields": [
                     "title",
                     "title._2gram",
                     "title._3gram"
                 ]
             }
         }
     }')
     result_count=$(echo "$response" | jq '.hits.hits | length')
     if [[ ${result_count} -gt 1 ]]; then
       echo "$result_count results"
     else
       echo "$result_count result"
     fi
     echo "$response" | jq .hits.hits[]._source.title | sed "s/^/   /" | sed "s/$string/\x1b[31m&\x1b[0m/g" #| grep --color=always "$string" #| grep -i "$string"
  fi

  # Clear the current line and reset the cursor to the beginning
  echo -ne "\r\033[K$string"

done