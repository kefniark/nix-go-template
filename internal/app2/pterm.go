package app2

import (
	"time"

	"github.com/pterm/pterm"
	"github.com/pterm/pterm/putils"
)

// Placeholder with PTerm to use external dependencies
func Run() {
	pterm.Info.Println("The previous text will stay in place, while the area updates.")
	pterm.Print("\n\n")

	area, _ := pterm.DefaultArea.WithCenter().Start()
	for i := 0; i < 10; i++ {
		str, _ := pterm.DefaultBigText.WithLetters(putils.LettersFromString(time.Now().Format("15:04:05"))).Srender()
		area.Update(str)
		time.Sleep(time.Second)
	}

	area.Stop()
}
