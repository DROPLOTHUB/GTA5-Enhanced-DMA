#include "pch.h"
#include "Offsets.h"

#include <fstream>
#include <algorithm>
#include <cctype>
#include <filesystem>

namespace
{
	std::string Trim(std::string s)
	{
		auto notSpace = [](unsigned char c) { return !std::isspace(c); };
		s.erase(s.begin(), std::find_if(s.begin(), s.end(), notSpace));
		s.erase(std::find_if(s.rbegin(), s.rend(), notSpace).base(), s.end());
		return s;
	}

	bool ParseHex(const std::string& value, uintptr_t& out)
	{
		std::string v = Trim(value);
		if (v.empty())
			return false;

		try
		{
			size_t idx = 0;
			out = static_cast<uintptr_t>(std::stoull(v, &idx, 0));
			return idx == v.size();
		}
		catch (...)
		{
			return false;
		}
	}

	// Directory containing the running .exe (trailing slash)
	std::filesystem::path ExeDirectory()
	{
		char modulePath[MAX_PATH]{};
		DWORD len = GetModuleFileNameA(nullptr, modulePath, MAX_PATH);
		if (!len || len >= MAX_PATH)
			return std::filesystem::current_path();

		return std::filesystem::path(modulePath).parent_path();
	}

	std::filesystem::path ResolveOffsetsPath(const std::string& path)
	{
		std::filesystem::path p(path);
		if (p.is_absolute())
			return p;

		// Always prefer the file next to the EXE
		return ExeDirectory() / p;
	}
}

bool Offsets::Load(const std::string& path)
{
	const auto fullPath = ResolveOffsetsPath(path);
	std::ifstream file(fullPath);
	if (!file.is_open())
	{
		std::println("Failed to open offsets file: {}", fullPath.string());
		std::println("Place Offsets.txt next to GTA5_DMA.exe");
		return false;
	}

	bool gotWorld = false;
	bool gotGlobal = false;
	bool gotBlip = false;

	std::string line;
	int lineNum = 0;

	while (std::getline(file, line))
	{
		++lineNum;

		if (auto hash = line.find('#'); hash != std::string::npos)
			line = line.substr(0, hash);

		line = Trim(line);
		if (line.empty())
			continue;

		auto eq = line.find('=');
		if (eq == std::string::npos)
		{
			std::println("Offsets.txt line {}: expected Key=Value", lineNum);
			continue;
		}

		std::string key = Trim(line.substr(0, eq));
		std::string value = Trim(line.substr(eq + 1));

		uintptr_t parsed = 0;
		if (!ParseHex(value, parsed))
		{
			std::println("Offsets.txt line {}: invalid hex value '{}'", lineNum, value);
			continue;
		}

		if (key == "WorldPtr")
		{
			WorldPtr = parsed;
			gotWorld = true;
		}
		else if (key == "GlobalPtr")
		{
			GlobalPtr = parsed;
			gotGlobal = true;
		}
		else if (key == "BlipPtr")
		{
			BlipPtr = parsed;
			gotBlip = true;
		}
		else
		{
			std::println("Offsets.txt line {}: unknown key '{}'", lineNum, key);
		}
	}

	if (!gotWorld || !gotGlobal || !gotBlip)
	{
		std::println("Offsets.txt is missing required keys (need WorldPtr, GlobalPtr, BlipPtr).");
		return false;
	}

	std::println("Loaded offsets from {}:", fullPath.string());
	std::println("  WorldPtr  = 0x{:x}", WorldPtr);
	std::println("  GlobalPtr = 0x{:x}", GlobalPtr);
	std::println("  BlipPtr   = 0x{:x}", BlipPtr);

	return true;
}
