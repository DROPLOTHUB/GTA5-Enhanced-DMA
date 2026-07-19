#pragma once
#include <cstdint>
#include <string>

namespace Offsets
{
	inline uintptr_t WorldPtr = 0;
	inline uintptr_t GlobalPtr = 0;
	inline uintptr_t BlipPtr = 0;

	// Loads WorldPtr / GlobalPtr / BlipPtr from Offsets.txt next to the EXE.
	// Format (hex, 0x optional, # comments allowed):
	//   WorldPtr=0x43dbc98
	//   GlobalPtr=0x47c87a8
	//   BlipPtr=0x3e7bf50
	bool Load(const std::string& path = "Offsets.txt");
}
