package terraform

const resourceTemplate = `resource "{{ .Type }}" "{{ .Name }}" {
	{{- range $key, $value := .Properties }}
	  {{ $key }} = var.{{ $.Name }}_{{ $key }}
	{{- end }}
	{{- if .DependsOn }}
	  depends_on = [
	  {{- range .DependsOn }}
		{{ printf "\"%s\"" . }},
	  {{- end }}
	  ]
	{{- end }}
	}`

const moduleTemplate = `module "{{ .Name }}" {
	  source = "{{ .Source }}"
	{{- range $key, $value := .Properties }}
	  {{ $key }} = var.{{ $.Name }}_{{ $key }}
	{{- end }}
	{{- if .DependsOn }}
	  depends_on = [
	  {{- range .DependsOn }}
		{{ printf "\"%s\"" . }},
	  {{- end }}
	  ]
	{{- end }}
	}`
