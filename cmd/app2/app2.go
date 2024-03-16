package main

import (
	"fmt"

	"github.com/kefniark/nix-go-template/internal"
	"github.com/kefniark/nix-go-template/internal/app2"
)

// Replaced during build process
var BuildVersion = "dev"

func main() {
	fmt.Printf("Hello, I'm App 2 (version %s)\n", BuildVersion)
	fmt.Println(internal.World())

	app2.Run()
}
