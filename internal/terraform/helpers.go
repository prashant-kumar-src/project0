package terraform

import (
	"fmt"
	"sort"
	"strings"
)

func renderValue(val interface{}) string {
	switch v := val.(type) {
	case string:
		return fmt.Sprintf("\"%s\"", v)
	case float64, int, int64, float32:
		return fmt.Sprintf("%v", v)
	case bool:
		return fmt.Sprintf("%t", v)
	case []interface{}:
		var parts []string
		for _, item := range v {
			parts = append(parts, renderValue(item))
		}
		return fmt.Sprintf("[%s]", strings.Join(parts, ", "))
	case map[string]interface{}:
		var lines []string
		for key, value := range v {
			lines = append(lines, fmt.Sprintf("%s = %s", key, renderValue(value)))
		}
		return fmt.Sprintf("{\n  %s\n}", strings.Join(lines, "\n  "))
	default:
		return fmt.Sprintf("\"%v\"", v)
	}
}

func renderValuePlain(v interface{}) string {
	switch val := v.(type) {
	case string:
		return fmt.Sprintf("\"%s\"", val)
	case []interface{}:
		parts := []string{}
		for _, item := range val {
			parts = append(parts, renderValuePlain(item))
		}
		return fmt.Sprintf("[%s]", strings.Join(parts, ", "))
	case map[string]interface{}:
		out := []string{"{"}
		keys := make([]string, 0, len(val))
		for k := range val {
			keys = append(keys, k)
		}
		sort.Strings(keys)
		for _, k := range keys {
			out = append(out, fmt.Sprintf("  %s = %s", k, renderValuePlain(val[k])))
		}
		out = append(out, "}")
		return strings.Join(out, "\n")
	default:
		return fmt.Sprintf("%v", val)
	}
}

func inferType(v interface{}) string {
	switch val := v.(type) {
	case string:
		return "string"
	case float64:
		return "number"
	case bool:
		return "bool"
	case []interface{}:
		if len(val) == 0 {
			return "list(any)"
		}
		return fmt.Sprintf("list(%s)", inferType(val[0]))
	case map[string]interface{}:
		if len(val) == 0 {
			return "map(any)"
		}
		keys := []string{}
		for k := range val {
			keys = append(keys, k)
		}
		sort.Strings(keys)
		inner := []string{}
		for _, k := range keys {
			inner = append(inner, fmt.Sprintf("\"%s\" = %s", k, inferType(val[k])))
		}
		return fmt.Sprintf("object({ %s })", strings.Join(inner, ", "))
	default:
		return "any"
	}
}
