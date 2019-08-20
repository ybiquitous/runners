package main

import (
	"fmt"

	"github.com/k0kubun/pp"
	plib "github.com/sideci/go_private_library"
)

func main() {
	slice := []string{"exp1", "exp2", "exp3"}
	pp.Print(slice)
	fmt.Printf("foo", "foo")
	fmt.Print(plib.Fibo(1))
}
