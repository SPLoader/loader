

#
# BIOS Bootstrap binary targets
#

BIOS_BOOTSTRAP_OBJ = bios/bootstrap.o
BIOS_BOOTSTRAP_OBJ := $(addprefix $(BUILD_DIR)/$(PLATFORMDIR)/,$(BIOS_BOOTSTRAP_OBJ))

BIOS_BOOTSTRAP_FINAL_OBJ = bios/bootstrap.final.o
BIOS_BOOTSTRAP_FINAL_OBJ := $(addprefix $(BUILD_DIR)/$(PLATFORMDIR)/,$(BIOS_BOOTSTRAP_FINAL_OBJ))

BIOS_BOOTSTRAP_BIN = bootstrap.bin
BIOS_BOOTSTRAP_BIN := $(addprefix $(BUILD_DIR)/,$(BIOS_BOOTSTRAP_BIN))

#
# loader_early (aka loader16) binary targets
#

# early is first since it's the entry point
LOADER_EARLY_OBJ = early/early.o \
                   early/a20gate.o \
                   early/memmap.o
LOADER_EARLY_OBJ := $(addprefix $(BUILD_DIR)/$(PLATFORMDIR)/,$(LOADER_EARLY_OBJ))

LOADER_EARLY_FINAL_OBJ = early/loader_early.final.o
LOADER_EARLY_FINAL_OBJ := $(addprefix $(BUILD_DIR)/$(PLATFORMDIR)/,$(LOADER_EARLY_FINAL_OBJ))

LOADER_EARLY_BIN = loader16.bin
LOADER_EARLY_BIN := $(addprefix $(BUILD_DIR)/,$(LOADER_EARLY_BIN))

# linker script for loader_early.bin
LOADER_EARLY_LDS := $(PLATFORMDIR)/early/loader_early.lds

#
# Platform-specific object files
#

LOADER_ENTRY_OBJ = startup.o

LOADER_ENTRY_OBJ := $(addprefix $(BUILD_DIR)/$(PLATFORMDIR)/,$(LOADER_ENTRY_OBJ))

LOADER_PLAT_OBJ = c_io.o \
                  mem/map.o

LOADER_PLAT_OBJ := $(addprefix $(BUILD_DIR)/$(PLATFORMDIR)/,$(LOADER_PLAT_OBJ))



$(BIOS_BOOTSTRAP_FINAL_OBJ): $(BIOS_BOOTSTRAP_OBJ) $(MARKER)
	$(LD_V) $(LDFLAGS) -Ttext 0x0 -e begtext -o $@ $(BIOS_BOOTSTRAP_OBJ)

$(BIOS_BOOTSTRAP_BIN): $(BIOS_BOOTSTRAP_FINAL_OBJ) $(MARKER)
	$(LD_V) $(LDFLAGS) -Ttext 0x0 -s --oformat binary -e begtext -o $@ $<

$(LOADER_EARLY_FINAL_OBJ): $(LOADER_EARLY_OBJ) $(BIOS_BOOTSTRAP_FINAL_OBJ) $(MARKER)
	$(LD_V) $(LDFLAGS) -R $(BIOS_BOOTSTRAP_FINAL_OBJ) -T $(LOADER_EARLY_LDS) -o $@ $(LOADER_EARLY_OBJ)

$(LOADER_EARLY_BIN): $(LOADER_EARLY_FINAL_OBJ) $(MARKER)
	$(LD_V) $(LDFLAGS) -T $(LOADER_EARLY_LDS) -s --oformat binary -o $@ $<


#
# PHONY targets
#

.PHONY: bootstrap.bin loader_early.bin

bootstrap.bin: $(BIOS_BOOTSTRAP_BIN)

loader16.bin: $(LOADER_EARLY_BIN)

-include $(BIOS_BOOTSTRAP_OBJ:.o=.d)
-include $(LOADER_EARLY_OBJ:.o=.d)

