package main

import (
	"encoding/json"
	"log"
	"os"

	"github.com/prashant-kumar-src/project0/internal/apps"
	"github.com/prashant-kumar-src/project0/internal/terraform"
	"github.com/prashant-kumar-src/project0/models"
)

func main() {
	if len(os.Args) != 2 {
		log.Fatalf("Usage: %s <config.json>", os.Args[0])
	}

	cfgPath := os.Args[1]
	file, err := os.ReadFile(cfgPath)
	if err != nil {
		log.Fatalf("Failed to read config file: %v", err)
	}

	var config models.Config

	err = json.Unmarshal(file, &config)
	if err != nil {
		log.Fatalf("Failed to parse config: %v", err)
	}

	err = terraform.Generate(config.Cloud, config.OutputDir)
	if err != nil {
		log.Fatalf("Failed to generate Terraform: %v", err)
	}

	err = apps.Generate(config.Apps, config.OutputDir)
	if err != nil {
		log.Fatalf("Failed to generate apps: %v", err)
	}
}
