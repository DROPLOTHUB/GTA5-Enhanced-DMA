# MemProcFS / LeechCore runtime

These files must sit next to `GTA5_DMA.exe` at runtime.  
**Building the project copies them automatically** from this folder into `x64\Release\` (or your active config output).

| File | Required | Notes |
|------|----------|--------|
| `vmm.dll` | Yes | MemProcFS |
| `vmm.lib` | Build only | Linked at compile time |
| `vmmdll.h` / `leechcore.h` | Build only | Headers |
| `leechcore.dll` | Yes | Memory acquisition |
| `FTD3XX.dll` | Yes (FPGA) | FTDI USB3 — required for most DMA FPGA boards |

## If DLLs are missing

1. Download a recent **MemProcFS** Windows release:  
   https://github.com/ufrisk/MemProcFS/releases  
   Copy `vmm.dll`, `leechcore.dll`, and `vmm.lib` here.
2. Download **FTDI D3XX**:  
   https://ftdichip.com/drivers/d3xx-drivers/  
   Copy `FTD3XX.dll` (x64) here.

MemProcFS is © Ulf Frisk — see upstream license/docs:  
https://github.com/ufrisk/MemProcFS
