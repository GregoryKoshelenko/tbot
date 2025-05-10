package cmd

import (
	"fmt"
	"github.com/spf13/cobra"
	telebot "gopkg.in/telebot.v3"
	"log"
	"os"
	"time"
)

var (
	TeleToken = os.Getenv("TELEGRAM_TOKEN")
	TeleChat  = os.Getenv("TELEGRAM_CHAT")
)


var tbotCmd = &cobra.Command{
	Use:   "tbot",
	Aliases: []string{"start"},
	Short: "Telegram bot",
	Long: `Telegram bot for sending messages
	This bot is used to send messages to a telegram chat
	and do some other stuff.`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("tbot %s started\n", appVersion)
		tbot, err := telebot.NewBot(telebot.Settings{
			URL:    "",
			Token:  TeleToken,
			Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
		})
		if err != nil {
			fmt.Println("Error creating bot: ", err)
			return
		}

		tbot.Handle(telebot.OnText, func(c telebot.Context) error {
			log.Print(c.Message().Payload, c.Text())
			return err
		})

		tbot.Start()
	},
}


func init() {
	rootCmd.AddCommand(tbotCmd)
}