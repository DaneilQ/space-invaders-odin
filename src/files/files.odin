package files

import json "core:encoding/json"
import "core:fmt"
import "core:os"
import "core:strings"


load_file :: proc(relative_path: string) -> []u8 {
	file_name: string
	path, path_err := os.get_absolute_path(
		strings.concatenate({relative_path, file_name}),
		context.allocator,
	)
	data, file_err := os.read_entire_file_from_path(path, context.allocator)
	return data
}

parse_json :: proc(data: []u8, structure: ^$T) {
	err := json.unmarshal(data, structure)
	if err != nil {
		fmt.println(err)
	}
}
