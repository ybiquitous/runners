package main

import (
	"fmt"

	"github.com/k0kubun/pp"
)

func main() {
	slice := []string{"exp1", "exp2", "exp3"}
	pp.Print(slice)
	fmt.Printf("foo", "foo")
}
