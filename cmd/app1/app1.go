package main

import (
	"fmt"

	"github.com/kefniark/nix-go-template/internal"
)

// Replaced during build process
var BuildVersion = "dev"

func main() {
	fmt.Printf("Hello, I'm App 1 (version %s)\n", BuildVersion)
	fmt.Println(internal.World())
}
