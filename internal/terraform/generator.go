package terraform

import (
	"fmt"
	"log"
	"os"
	"text/template"

	"github.com/prashant-kumar-src/project0/models"
)

// Generate the Terraform
func Generate(cloud models.Cloud, outputDir string) error {
	log.Printf("Generating Terraform for %s ...", cloud.Provider.Region)

	// check if path exists if not then create it
	err := os.MkdirAll(outputDir, os.ModePerm)
	if err != nil {
		log.Fatalf("Failed to create output directory: %v", err)
	}

	// create main.tf file
	err = generateMainTF(cloud, outputDir)
	if err != nil {
		log.Fatalf("Failed to generate main.tf: %v", err)
	}

	// create outputs.tf file
	err = generateOutputsTF(cloud, outputDir)
	if err != nil {
		log.Fatalf("Failed to generate outputs.tf: %v", err)
	}

	// create variables.tf file
	err = generateVariablesTF(cloud, outputDir)
	if err != nil {
		log.Fatalf("Failed to generate variables.tf: %v", err)
	}

	// create terraform.tfvars file
	err = generateTerraformTFVars(cloud, outputDir)
	if err != nil {
		log.Fatalf("Failed to generate terraform.tfvars: %v", err)
	}

	log.Printf("Generated Terraform for %s in %s", cloud.Provider.Region, outputDir)
	return nil
}

func generateTerraformTFVars(cloud models.Cloud, outputDir string) error {
	path := fmt.Sprintf("%s/terraform.tfvars", outputDir)
	f, err := os.Create(path)
	if err != nil {
		return err
	}
	defer f.Close()
	fmt.Fprintf(f, "region = \"%s\"\n", cloud.Provider.Region)
	for _, mod := range cloud.Modules {
		for k, v := range mod.Properties {
			fmt.Fprintf(f, "%s_%s = %s\n", mod.Name, k, renderValuePlain(v))
		}
	}
	for _, res := range cloud.Resources {
		for k, v := range res.Properties {
			fmt.Fprintf(f, "%s_%s = %s\n", res.Name, k, renderValuePlain(v))
		}
	}

	return nil

}

func generateVariablesTF(cloud models.Cloud, outputDir string) error {
	path := fmt.Sprintf("%s/variables.tf", outputDir)
	f, err := os.Create(path)
	if err != nil {
		return err
	}
	defer f.Close()

	fmt.Fprintln(f, "variable \"region\" {\n  type = string\n  default = \""+cloud.Provider.Region+"\"\n  description = \"AWS region for provider\"\n}\n")
	seen := make(map[string]bool)
	for _, mod := range cloud.Modules {
		for k, v := range mod.Properties {
			vn := fmt.Sprintf("%s_%s", mod.Name, k)
			if seen[vn] {
				continue
			}
			seen[vn] = true
			typ := inferType(v)
			fmt.Fprintf(f, "variable \"%s\" {\n  type = %s\n  default = %s\n  description = \"Module %s property %s\"\n}\n\n", vn, typ, renderValuePlain(v), mod.Name, k)
		}
	}
	for _, res := range cloud.Resources {
		for k, v := range res.Properties {
			vn := fmt.Sprintf("%s_%s", res.Name, k)
			if seen[vn] {
				continue
			}
			seen[vn] = true
			typ := inferType(v)
			fmt.Fprintf(f, "variable \"%s\" {\n  type = %s\n  default = %s\n  description = \"Resource %s property %s\"\n}\n\n", vn, typ, renderValuePlain(v), res.Name, k)
		}
	}

	return nil
}

func generateOutputsTF(cloud models.Cloud, outputDir string) error {
	path := fmt.Sprintf("%s/outputs.tf", outputDir)
	f, err := os.Create(path)
	if err != nil {
		return err
	}
	defer f.Close()

	for _, res := range cloud.Resources {
		fmt.Fprintf(f, "output \"%s_id\" {\n  value = %s.%s.id\n}\n\n", res.Name, res.Type, res.Name)
	}
	for _, mod := range cloud.Modules {
		fmt.Fprintf(f, "output \"%s_output\" {\n  value = module.%s\n}\n\n", mod.Name, mod.Name)
	}

	return nil
}

func generateMainTF(cloud models.Cloud, outputDir string) error {
	path := fmt.Sprintf("%s/main.tf", outputDir)
	f, err := os.Create(path)
	if err != nil {
		return err
	}
	defer f.Close()

	_, err = fmt.Fprintf(f, "provider \"aws\" {\n  region = var.region\n}\n\n")
	if err != nil {
		log.Fatalf("Failed to write provider block: %v", err)
	}

	tmpl := template.Must(template.New("resource").Funcs(template.FuncMap{
		"renderValue": renderValue,
	}).Parse(resourceTemplate))

	for _, res := range cloud.Resources {
		err := tmpl.Execute(f, res)
		if err != nil {
			log.Fatalf("Failed to render resource %s: %v", res.Name, err)
		}
		_, _ = f.WriteString("\n")
	}

	moduleTmpl := template.Must(template.New("module").Funcs(template.FuncMap{
		"renderValue": renderValue,
	}).Parse(moduleTemplate))

	for _, mod := range cloud.Modules {
		err := moduleTmpl.Execute(f, mod)
		if err != nil {
			log.Fatalf("Failed to render module %s: %v", mod.Name, err)
		}
		_, _ = f.WriteString("\n")
	}

	return nil
}
