function f = lane_density(trajectories, timeStamp, lane)
    numVeh = size(trajectories);
    count = 0;
    for i = 1: numVeh(2)
        timeId = find(timeStamp == [trajectories(i).t]);
        if ~isempty(timeId)
            index = find(trajectories(i).lanes(timeId) == lane);
            if ~isempty(index)
                count = count+1;
            end
        end
    end
    f = count;
end