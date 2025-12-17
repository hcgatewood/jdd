help: ## Print this help text
	@grep -Eh '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

installs:  ## Install dev dependencies
	brew install asciinema
	npm install -g svg-term

demo:  ## Convert the demo
	svg-term --in ./assets/demo.cast --out ./assets/demo.svg

show:  ## Show the demo
	open ./assets/demo.svg
