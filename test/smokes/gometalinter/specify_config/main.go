package main

import (
	"fmt"
	"os/exec"
)

// Warning for Go lint
const Id = 10

func main() {
	// Warning for go vet
	fmt.Printf("%d", "ichi")

	// Warning for gosec
	exec.Command("go")
}

// Warning for Go lint
func NoDocFunc() int {
	return 1
}
