# Detect all Flutter packages (exclude build + example dirs)
PACKAGES := $(shell find . -name "pubspec.yaml" -not -path "./build/*" -exec dirname {} \; | grep -v "example")

.PHONY: test

test_all:
	@echo "🚀 Running all Flutter tests..."
	@PASSED=""; FAILED=""; \
	for dir in $(PACKAGES); do \
		if [ -d "$$dir/test" ]; then \
			echo "\n📦 Running tests in $$dir..."; \
			if cd $$dir && flutter test; then \
				PASSED="$$PASSED\n✅ $$dir"; \
			else \
				FAILED="$$FAILED\n❌ $$dir"; \
			fi; \
			cd - > /dev/null; \
		else \
			echo "\n⚪ Skipping $$dir (no test directory)"; \
		fi \
	done; \
	echo "\n📋 Test Summary:"; \
	if [ -n "$$PASSED" ]; then echo "$$PASSED"; fi; \
	if [ -n "$$FAILED" ]; then echo "$$FAILED"; fi; \
	if [ -n "$$FAILED" ]; then \
		echo "\n❌ Some tests failed."; exit 1; \
	else \
		echo "\n✅ All tests passed!"; \
	fi
