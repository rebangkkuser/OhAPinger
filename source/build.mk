ARCH := $(shell uname -m)
OUT := OhAPinger-1.0-$(ARCH)-UNOFFICIAL-Compiled

COMPILER := $(shell command -v clang++ 2>/dev/null || command -v g++ 2>/dev/null)

cakes:
	@if [ -z "$(COMPILER)" ]; then \
		echo "[OhAPinger] Error: no compiler available (clang++ or g++)"; \
		exit 1; \
	fi; \
	if command -v bc >/dev/null 2>&1; then \
		START_TIME=$$(date +%s.%N); \
		USE_BC=1; \
	else \
		START_TIME=$$(date +%s); \
		USE_BC=0; \
	fi; \
	$(COMPILER) ohapinger-latest.cpp -O2 -std=c++17 -o "$(OUT)"; \
	chmod a+x "$(OUT)" 2>/dev/null || chmod 755 "$(OUT)" || chmod +x "$(OUT)"; \
	echo "[OhAPinger] Build completed: $(OUT)"; \
	if [ $$USE_BC -eq 1 ]; then \
		END_TIME=$$(date +%s.%N); \
		ELAPSED=$$(echo "$$END_TIME - $$START_TIME" | bc); \
		printf "[OhAPinger] Build finished on %.4fs.\n" "$$ELAPSED"; \
	else \
		END_TIME=$$(date +%s); \
		ELAPSED=$$((END_TIME - START_TIME)); \
		printf "[OhAPinger] Build finished on %ds.\n" "$$ELAPSED"; \
	fi
