# for all
TOPNAME=top
TOP_DIR:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# verilator
VERILATOR=verilator
VERILATOR_CFLAGS += -MMD --build -cc -O3 --x-assign fast --x-initial fast --noassert
CFLAGS+=-DTOP_NAME=V$(TOPNAME)
CSRC_PATH=$(TOP_DIR)csrc
VSRC_PATH=$(TOP_DIR)vsrc
V_DIR=$(foreach dir,$(VSRC_PATH),$(wildcard $(dir)/*.v))
CPP_INC_PATH=$(CSRC_PATH)/INC
CPP_SRC_PATH=$(CSRC_PATH)/SRC
CPP_SRC_DIR=$(foreach dir,$(CPP_SRC_PATH),$(wildcard $(dir)/*.cpp))
BUILD_PATH=$(TOP_DIR)build
OBJ_PATH=$(BUILD_PATH)/temp
BIN_PATH=$(BUILD_PATH)/bin
BIN=$(BIN_PATH)/$(TOPNAME)
WAVE_DIR=$(BIN_PATH)/wave.vcd

# nvboard
NV_VERILATOR=verilator
NV_VERILATOR_CFLAGS += -MMD --build -cc -O3 --x-assign fast --x-initial fast --noassert
NV_BUILD_PATH=$(TOP_DIR)nv_build
NV_OBJ_PATH=$(NV_BUILD_PATH)/temp
NV_BIN_PATH=$(NV_BUILD_PATH)/bin
NV_V_DIR=$(foreach dir,$(NV_VSRC_PATH),$(wildcard $(dir)/*.v))
NV_CSRC_PATH=$(TOP_DIR)nv_csrc
NV_VSRC_PATH=$(TOP_DIR)vsrc
NV_CPP_INC_PATH=$(NV_CSRC_PATH)/INC
NV_CPP_INC_PATH+=$(INC_PATH)
NV_CPP_SRC_PATH=$(NV_CSRC_PATH)/SRC
NV_CPP_SRC_DIR=$(foreach dir,$(NV_CPP_SRC_PATH),$(wildcard $(dir)/*.cpp))
NV_CPP_SRC_DIR+=$(NV_SRC_AUTO_BIND)
NV_BIN=$(NV_BIN_PATH)/$(TOPNAME)
NV_CONSTR=$(TOP_DIR)constr
NV_NXDC=$(wildcard $(NV_CONSTR)/*.nxdc)
NV_SRC_AUTO_BIND=$(NV_OBJ_PATH)/auto_bind.cpp
NV_INCFLAGS=$(addprefix -I,$(NV_CPP_INC_PATH))
NV_CFLAGS=$(NV_INCFLAGS) -DTOP_NAME=V$(TOPNAME)
NV_LDFLAGS+=-lSDL2 -lSDL2_image

# verilator
all: build_prepare $(BIN)

$(WAVE_DIR): $(BIN)
	@cd $(BIN_PATH) && ./$(TOPNAME)

run:$(WAVE_DIR)
	@echo "> RUN $^"

sim: $(WAVE_DIR)
	@echo "> SIM $^"
	@gtkwave $^

$(BIN): $(V_DIR) $(CPP_SRC_DIR)
	@rm -rf $(OBJ_PATH)
	$(foreach vfile, $(V_DIR), $(info + V $(vfile)))
	$(foreach cppfile, $(CPP_SRC_DIR), $(info + CPP $(cppfile)))
	@$(VERILATOR) $(VERILATOR_CFLAGS) \
	--top-module $(TOPNAME) \
	$^ -I$(CPP_INC_PATH) $(CFLAGS) \
	--Mdir $(OBJ_PATH) --trace --exe \
	-o $(BIN)

# nvboard
include $(NVBOARD_HOME)/scripts/nvboard.mk

nv: build_prepare $(NV_BIN)

nvrun: $(NV_BIN)
	@echo "> RUN $^"
	@$^

$(NV_BIN): $(NV_V_DIR) $(NV_CPP_SRC_DIR) $(NVBOARD_ARCHIVE) $(NV_SRC_AUTO_BIND)
	@rm -rf $(NV_OBJ_PATH)/V*
	$(foreach vfile, $(V_DNV_V_DIRIR), $(info + V $(vfile)))
	$(foreach cppfile, $(NV_CPP_SRC_DIR), $(info + CPP $(cppfile)))
	$(NV_VERILATOR) $(NV_VERILATOR_CFLAGS) \
	--top-module $(TOPNAME) \
	$^ $(addprefix -CFLAGS , $(NV_CFLAGS)) $(addprefix -LDFLAGS , $(NV_LDFLAGS)) \
	--Mdir $(NV_OBJ_PATH) --trace --exe \
	-o $(NV_BIN)

$(NV_SRC_AUTO_BIND): $(NV_NXDC)
	@echo "+ PY $^"
	@python3 $(NVBOARD_HOME)/scripts/auto_pin_bind.py $^ $@

# for all
.PHONY: all run sim build_prepare clean

build_prepare:
	@if [ ! -d $(BUILD_PATH) ]; then \
	mkdir -p $(OBJ_PATH); \
	mkdir -p $(BIN_PATH); \
	fi
	@if [ ! -d $(NV_BUILD_PATH) ]; then \
	mkdir -p $(NV_OBJ_PATH); \
	mkdir -p $(NV_BIN_PATH); \
	fi

clean:
	@echo "- RM $(BUILD_PATH)"
	@rm -rf $(BUILD_PATH)
	@echo "- RM $(NV_BUILD_PATH)"
	@rm -rf $(NV_BUILD_PATH)

