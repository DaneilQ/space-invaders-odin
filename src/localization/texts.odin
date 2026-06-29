package localization
import files "../files"
import "core:strings"

Texts :: struct {
	locale:       Locale,
	translations: string,
}

Translations :: struct {
	window: string,
	level:  string,
}

load_file :: proc(locale: Locale) -> []u8 {
	file_name: string
	switch locale {
	case Locale.En:
		file_name = "en.json"
	case Locale.Es:
		file_name = "es.json"
	}
	data := files.load_file(strings.concatenate({"../assets/translations/", file_name}))
	return data
}

load_translations :: proc(locale: Locale) -> Translations {
	data := load_file(locale)
	translations: Translations
	files.parse_json(data, &translations)
	defer delete(data)
	return translations
}
