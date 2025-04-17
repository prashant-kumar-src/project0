package models

type Cloud struct {
	Provider struct {
		Region string `json:"region"`
	} `json:"provider"`
	Resources []Resource `json:"resources"`
	Modules   []Module   `json:"modules"`
}
type Config struct {
	Apps      []App  `json:"apps"`
	Cloud     Cloud  `json:"cloud"`
	OutputDir string `json:"output_dir"`
}

type Resource struct {
	Type       string                 `json:"type"`
	Name       string                 `json:"name"`
	Properties map[string]interface{} `json:"properties"`
	DependsOn  []string               `json:"depends_on,omitempty"`
}

type Module struct {
	Name       string                 `json:"name"`
	Source     string                 `json:"source"`
	Properties map[string]interface{} `json:"properties"`
	DependsOn  []string               `json:"depends_on,omitempty"`
}

type App struct {
	Name       string                 `json:"name"`
	Framework  string                 `json:"framework"`
	Properties map[string]interface{} `json:"properties"`
}
