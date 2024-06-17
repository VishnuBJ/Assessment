#!/bin/bash

get_value_by_key_path() {
    local object="$1"
    local key="$2"

    local jq_path=$(echo "$key" | tr '/' '.')
    local value=$(echo "$object" | jq -r ".$jq_path")

    echo "$value"
}

# Example usage:
echo "Example input format:"
echo 'object={"a":{"b":{"c":{"d":"e"}}}}'
echo 'key=a/b/c/d'
echo 'output: e'

echo 'Enter input:'
read -p 'Enter object:' object
read -p 'Enter key:' key
result=$(get_value_by_key_path "$object" "$key")

echo "output: $result"