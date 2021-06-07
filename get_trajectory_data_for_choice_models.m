function f = get_trajectory_data_for_choice_models(id, trajectories, trajectories_lf, lanes, count)
    data = trajectories(id);
    index = [];

    for i = 1:length(data.t)
        if rem(data.t(i),0.5) == 0
            index = [index; i];
        end
    end

    local_id = data.id*ones(size(index,1),1);
    local_time = data.t(index);
    reset_time = local_time - local_time(1);
    local_veh_length = data.l*ones(size(index,1),1);
    smoothed_v = speed_filter(data.x_sm, data.v_cal);
    local_veh_speed = smoothed_v(index)';
    smoothed_a = acceleration_filter(smoothed_v, data.a_cal);
    local_veh_acc = smoothed_a(index)';
%     local_veh_speed = data.v_cal(index);
%     local_veh_acc = data.a_cal(index);
    local_lead_gap = trajectories_lf(id).lead_s_nett(index,2);
    local_lag_gap = trajectories_lf(id).foll_s_nett(index,2);
    local_left_lag_gap = trajectories_lf(id).foll_s_nett(index,1);
    local_left_lead_gap = trajectories_lf(id).lead_s_nett(index,1);
    local_right_lag_gap = trajectories_lf(id).foll_s_nett(index,3);
    local_right_lead_gap = trajectories_lf(id).lead_s_nett(index,3);
    local_left_lead_veh = trajectories_lf(id).leader(index,1);
    local_right_lead_veh = trajectories_lf(id).leader(index,3);
    local_left_lag_veh = trajectories_lf(id).follower(index,1);
    local_right_lag_veh = trajectories_lf(id).follower(index,3);
    local_current_lead = trajectories_lf(id).leader(index,2);
     local_current_lag = trajectories_lf(id).follower(index,2);
    local_current_lead_veh_length = [];
    local_veh_lanes = data.lanes(index);
    local_left_lag_speed = [];
    local_left_lead_speed = [];
    local_right_lag_speed = [];
    local_right_lead_speed = [];
    local_current_lead_speed = [];
    local_current_lag_speed = [];
    local_lane_density = [];
    local_left_lane_density = [];
    local_right_lane_density = [];

    for j = 1:length(local_time)
        local_left_lag_speed = [local_left_lag_speed; match_speed(local_left_lag_veh(j), local_time(j), trajectories)];
        local_left_lead_speed = [local_left_lead_speed; match_speed(local_left_lead_veh(j), local_time(j), trajectories)];
        local_right_lag_speed = [local_right_lag_speed; match_speed(local_right_lag_veh(j), local_time(j), trajectories)];
        local_right_lead_speed = [local_right_lead_speed; match_speed(local_right_lead_veh(j), local_time(j), trajectories)];
        local_lane_density = [local_lane_density; lane_density(trajectories, local_time(j), local_veh_lanes(j))];
        local_left_lane_density = [local_left_lane_density; lane_density(trajectories, local_time(j), local_veh_lanes(j)+1)];
        local_right_lane_density = [local_right_lane_density; lane_density(trajectories, local_time(j), local_veh_lanes(j)-1)];
        local_current_lead_veh_length = [local_current_lead_veh_length; lead_veh_length(local_current_lead(j), trajectories)];
        local_current_lead_speed = [local_current_lead_speed; match_speed(local_current_lead(j), local_time(j), trajectories)];
        local_current_lag_speed = [local_current_lag_speed; match_speed(local_current_lag(j), local_time(j), trajectories)];
    end
    
    cat = [];
    if strcmp(lanes.category, 'weaving section')
        cat = 1;
    elseif strcmp(lanes.category, 'off-ramp')
        cat = 2;
    else
        cat = 3;
    end
        
    site_topology = cat*ones(size(index,1),1);
    site_lanes = lanes.NumOfLanes*ones(size(index,1),1);
    site_length = lanes.ramp_length*ones(size(index,1),1);
    
    driver_id = count*ones(size(index,1),1);
    
    idx = find(local_veh_lanes==-1);
    local_veh_lanes(idx) = 1;
    
%     y_variable = [0; diff(local_veh_lanes)];
    y_variable = [diff(local_veh_lanes); 0];

    f = [local_id, driver_id, local_time,reset_time, local_veh_length, local_veh_speed, local_veh_acc, local_lead_gap, ...
        local_lag_gap, local_left_lag_gap, local_left_lead_gap,...
        local_right_lag_gap, local_right_lead_gap, ...
        local_current_lead_veh_length, local_current_lead_speed,local_current_lag_speed,...
        local_left_lag_speed, local_left_lead_speed, local_right_lag_speed, local_right_lead_speed, ...
        local_lane_density, local_left_lane_density, local_right_lane_density, ...
        site_topology, site_lanes, site_length, local_veh_lanes, y_variable];
end