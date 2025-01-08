local jobCount = {}

local function updateJobCount(job, increment)
    local currentCount = jobCount[job.name] or 0
    local newCount = currentCount + increment
    if newCount < 0 then newCount = 0 end
    jobCount[job.name] = newCount
    GlobalState[job.name] = newCount
end

local function playerLoaded(_, xPlayer)
    local data = {
        name = xPlayer.job.name,
        onDuty = xPlayer.job.onDuty == nil or xPlayer.job.onDuty,
    }
    ESX.Players[xPlayer.source] = data

    if data.onDuty then updateJobCount(data, 1) end
end

for _, player in ipairs(ESX.Players) do
    playerLoaded(_, player)
end

AddEventHandler('esx:playerLoaded', playerLoaded)

AddEventHandler('esx:setJob', function(playerId, job)
    local newJobData = {
        name = job.name,
        onDuty = job.onDuty == nil or job.onDuty,
    }
    local lastJobData = ESX.Players[playerId]
    ESX.Players[playerId] = newJobData

    if newJobData.name ~= lastJobData.name then
        if newJobData.onDuty then updateJobCount(newJobData, 1) end
        if lastJobData.onDuty then updateJobCount(lastJobData, -1) end
    elseif newJobData.onDuty ~= lastJobData.onDuty then
        if newJobData.onDuty then
            updateJobCount(newJobData, 1)
        else
            updateJobCount(lastJobData, -1)
        end
    end
end)

AddEventHandler('esx:playerDropped', function(playerId)
    local lastJobData = ESX.Players[playerId]
    ESX.Players[playerId] = nil
    if lastJobData and lastJobData.onDuty then
        updateJobCount(lastJobData, -1)
    end
end)

exports('getMembers', function(filter)
    local response = {}
    local filterType = type(filter)

    if filterType == 'string' then
        for playerId, job in pairs(ESX.Players) do
            if job.name == filter and job.onDuty then
                response[playerId] = job
            end
        end
    elseif filterType == 'table' then
        for playerId, job in pairs(ESX.Players) do
            local match = filter[job.name]
            if (match == true or match == nil) and job.onDuty then
                response[playerId] = job
            elseif match == false then
                response[playerId] = job
            end
        end
    end

    return response
end)
