---@class RustboltProfiling
local Profiling = {};

--- Returns the overall performance metrics of the addon. Quite expensive.
function Profiling.GetOverallPerformanceMetrics()
    local time = GetTimePreciseSec();

    UpdateAddOnMemoryUsage();
    UpdateAddOnCPUUsage();

    local memUsage = GetAddOnMemoryUsage("Rustbolt") / 1000; -- converting from kb to mb
    local cpuUsage = GetAddOnCPUUsage("Rustbolt");

    local sessionAvg = C_AddOnProfiler.GetAddOnMetric("Rustbolt", Enum.AddOnProfilerMetric.SessionAverageTime);
    local recentAvg = C_AddOnProfiler.GetAddOnMetric("Rustbolt", Enum.AddOnProfilerMetric.RecentAverageTime);
    local peakTime = C_AddOnProfiler.GetAddOnMetric("Rustbolt", Enum.AddOnProfilerMetric.PeakTime);
    local lastTime = C_AddOnProfiler.GetAddOnMetric("Rustbolt", Enum.AddOnProfilerMetric.LastTime);

    return {
        Time = time,
        MemoryUsage = memUsage,
        CPUUsage = cpuUsage,
        SessionAverageTime = sessionAvg,
        RecentAverageTime = recentAvg,
        PeakTime = peakTime,
        LastTime = lastTime,
    };
end

------------

Rustbolt.Profiling = Profiling;