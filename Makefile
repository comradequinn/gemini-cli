build:
	@docker build -t ghcr.io/comradequinn/gemini-cli:dev .

run: build
	@scripts/run-dev.sh