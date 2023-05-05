package main

import (
	"fmt"
	"log"
	"os"

	"golang.org/x/mod/modfile"
)

func main() {
	// Turn go.mod into array of bytes
	data, err := os.ReadFile("dummy/go.mod")
	if err != nil {
		log.Fatalf("failed to read file: %s", err)
	}
	fmt.Printf("Contents of go.mod file:\n%s\n", string(data))

	// Parse modfile
	modFile, err := modfile.Parse("", data, nil)
	if err != nil {
		log.Fatalf("failed to parse modfile: %s", err)
	}

	// TODO: remove this
	fmt.Println("MODFILE", modFile.Module.Mod.Path)

	// Iterate through requires in modfile
	for _, require := range modFile.Require {
		// For each require, print the comment suffix
		// fmt.Println("Require: %s", string(require.Syntax.Comments.Suffix)) // TODO: figure out how to convert require.Syntax.Comments.Suffix (variable of type []modfile.Comment) to type string
	}
}