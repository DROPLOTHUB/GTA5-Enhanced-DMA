# GTA5 Enhanced — DMA tool

Windows DMA overlay for **GTA5 Enhanced** (`GTA5_Enhanced.exe`) using MemProcFS + an FPGA DMA board.

> **Not for FiveM.** Single-player / story Enhanced only.  
> You need a second PC + compatible DMA FPGA hardware.

---

## Quick start

### 1. Requirements

| What | Details |
|------|---------|
| OS | Windows 10/11 **x64** (DMA PC) |
| IDE | Visual Studio 2022 with **Desktop development with C++** |
| Hardware | FPGA DMA card + FTDI USB3 cable on the DMA PC |
| Drivers | [FTDI D3XX](https://ftdichip.com/drivers/d3xx-drivers/) |
| Game PC | GTA5 Enhanced running |

Runtime DLLs live in [`MemProcFS/`](MemProcFS/) and are **copied next to the exe on build**.

### 2. Build

1. Open `GTA5_DMA.sln` in Visual Studio  
2. Configuration: **Release** \| **x64**  
3. Build → Build Solution (`Ctrl+Shift+B`)  
4. Output: `x64\Release\GTA5_DMA.exe`

After a successful build that folder should contain:

```
GTA5_DMA.exe
Offsets.txt
vmm.dll
leechcore.dll
FTD3XX.dll
```

### 3. Offsets (no rebuild)

Edit `GTA5_DMA/Offsets.txt` (or the copy next to the exe):

```ini
# Hex — 0x optional. # starts a comment.
WorldPtr=0x434a958
GlobalPtr=0x4737178
BlipPtr=0x3debd70
```

Restart the app after editing. Use the included **Dumper** (or your own) when the game updates.

### 4. Run

1. Plug the FPGA into the **DMA PC**  
2. Start GTA5 Enhanced on the **game PC**  
3. Run `GTA5_DMA.exe` on the DMA PC  
4. Press **END** to quit  

If you see `Unable to connect to FPGA device`, the board isn’t detected — check USB cable, FTDI drivers, and that nothing else is using the device.

---

## Project layout

```
GTA5_DMA.sln          Solution
GTA5_DMA/             Source + Offsets.txt
MemProcFS/            vmm / leechcore / FTD3XX (headers + runtime)
ImGui/                UI
Dumper/               Optional offset dumper (DMA)
```

---

## Troubleshooting

| Message | Fix |
|---------|-----|
| `VMM.dll was not found` | Rebuild, or copy DLLs from `MemProcFS/` next to the exe |
| `Failed to open offsets file` | Put `Offsets.txt` next to the exe (or run from `GTA5_DMA/`) |
| `Unable to connect to FPGA` | Cable / drivers / exclusive USB access |
| `GTA5_Enhanced.exe PID is null` | Game not running, or wrong edition (must be Enhanced) |

---

## Credits

- Original source: [warrior276276 (CyNickal)](https://www.unknowncheats.me/forum/members/1428619.html) — [UC thread](https://www.unknowncheats.me/forum/grand-theft-auto-v/689945-gta5_enchanced-basic-dma-tool.html)
- Dumper: [kitsheaven](https://www.unknowncheats.me/forum/members/3410923.html) — [UC thread](https://www.unknowncheats.me/forum/grand-theft-auto-v/700169-gta5-enhanced-basic-dumper-dma.html)
- Memory framework: [MemProcFS / LeechCore](https://github.com/ufrisk/MemProcFS) (Ulf Frisk)

## License

GPL-3.0 — see [LICENSE](LICENSE).
