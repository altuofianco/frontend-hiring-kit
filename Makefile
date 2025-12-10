.PHONY: help update start stop data-init data-refresh

# Paths
API_MOCK_DIR = api-mock
DATA_DIR = $(API_MOCK_DIR)/public/data

# Colors
GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
NC = \033[0m # No Color

help: ## Show this help message
	@echo "$(GREEN)Available commands:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'

update: ## Update CodeIgniter dependencies via Composer
	@echo "$(GREEN)Updating CodeIgniter dependencies...$(NC)"
	cd $(API_MOCK_DIR) && composer update
	@echo "$(GREEN)Dependencies updated successfully!$(NC)"

start: ## Start CodeIgniter development server
	@echo "$(GREEN)Starting CodeIgniter server on http://localhost:8080$(NC)"
	@cd $(API_MOCK_DIR) && php spark serve

stop: ## Stop CodeIgniter development server (Ctrl+C)
	@echo "$(YELLOW)To stop the server, press Ctrl+C$(NC)"

data-init: ## Copy all sample.* files to {DATABASE_NAME}.txt
	@SAMPLE_FILES=$$(find $(DATA_DIR) -maxdepth 1 -name "sample.*" -type f); \
	if [ -z "$$SAMPLE_FILES" ]; then \
		echo "$(RED)Error: No sample.* files found in $(DATA_DIR)!$(NC)"; \
		exit 1; \
	fi; \
	HAS_EXISTING=0; \
	for SAMPLE in $$SAMPLE_FILES; do \
		DB_NAME=$$(basename $$SAMPLE | sed 's/^sample\.//'); \
		TARGET=$(DATA_DIR)/$$DB_NAME.txt; \
		if [ -f $$TARGET ]; then \
			echo "$(YELLOW)Warning: $$DB_NAME.txt already exists$(NC)"; \
			HAS_EXISTING=1; \
		fi; \
	done; \
	if [ $$HAS_EXISTING -eq 1 ]; then \
		echo "$(YELLOW)Some target files already exist. Use 'make data-refresh' to overwrite.$(NC)"; \
	else \
		for SAMPLE in $$SAMPLE_FILES; do \
			DB_NAME=$$(basename $$SAMPLE | sed 's/^sample\.//'); \
			TARGET=$(DATA_DIR)/$$DB_NAME.txt; \
			cp $$SAMPLE $$TARGET; \
			echo "$(GREEN)Created $$DB_NAME.txt from sample.$$DB_NAME$(NC)"; \
		done; \
		echo "$(GREEN)All data files initialized successfully!$(NC)"; \
	fi;

data-refresh: ## Delete and recreate all {DATABASE_NAME}.txt from sample.* files
	@SAMPLE_FILES=$$(find $(DATA_DIR) -maxdepth 1 -name "sample.*" -type f); \
	if [ -z "$$SAMPLE_FILES" ]; then \
		echo "$(RED)Error: No sample.* files found in $(DATA_DIR)!$(NC)"; \
		exit 1; \
	fi; \
	for SAMPLE in $$SAMPLE_FILES; do \
		DB_NAME=$$(basename $$SAMPLE | sed 's/^sample\.//'); \
		TARGET=$(DATA_DIR)/$$DB_NAME.txt; \
		if [ -f $$TARGET ]; then \
			rm $$TARGET; \
			echo "$(YELLOW)Deleted $$DB_NAME.txt$(NC)"; \
		fi; \
		cp $$SAMPLE $$TARGET; \
		echo "$(GREEN)Recreated $$DB_NAME.txt from sample.$$DB_NAME$(NC)"; \
	done; \
	echo "$(GREEN)All data files refreshed successfully!$(NC)"
