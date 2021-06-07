%% Clear workspace
clear; 
clc;
close all;
%% Main code
%Index for trucks
tic
sites = ["offramp_Delft","offramp_TerHeide","offramp_Zonzeel_south",...
        "onramp_Delft","onramp_TerHeide","onramp_Zonzeel_north",...
        "weaving_BergenOpZoom_east","weaving_BergenOpZoom_west",...
        "weaving_Klaverpolder_north","weaving_Klaverpolder_south",...
        "weaving_Princeville_east","weaving_Princeville_west",...
        "weaving_Ridderkerk_north","weaving_Ridderkerk_south"];
output = [];
output_left_bus = [];
output_right_bus = [];
count = 1;

for site_index=sites
    %site='onramp_Zonzeel_north';
    site = site_index;

    filename = site;
    load(strcat(filename, '_trajectories.mat'));
    load(strcat(filename, '_leader_follower.mat'));
    load(strcat(filename, '_lanes.mat'));
    
%     load([filename, '_trajectories.mat']);
%     load([filename, '_leader_follower.mat']);
%     load([filename, '_lanes.mat']);
%     %vehicle index for trucks
    truck_index = find([trajectories.l]>5.6 & [trajectories.l]<12.0);
    for i = 1: length(truck_index)
        id  = truck_index(i);
        lanetraj=trajectories(id).lanes;
        lane_transitions = (diff(lanetraj) ~= 0);
        temp_lane_change=sum(abs(lane_transitions));
        if lanetraj(1) == -1 | lanetraj(end) == -1 %| ~ismember(3, lanetraj)
            continue;
        else
            if temp_lane_change == 0
                if lanetraj(1) == 1
                    output_left_bus = [output_left_bus; get_trajectory_data_for_choice_models(id, trajectories, trajectories_lf, lanes, count)];
                    count = count + 1;
                else
                    output_right_bus = [output_right_bus; get_trajectory_data_for_choice_models(id, trajectories, trajectories_lf, lanes, count)];
                    count = count + 1;
                end

            elseif temp_lane_change == 1 & (max(trajectories(id).y_sm) - min(trajectories(id).y_sm) >=2)
                if lanetraj(1) == 1 & lanetraj(end) == 2
                    alpha = 1;
                    output_left_bus = [output_left_bus; new_get_trajectory_data_for_choice_models(id, trajectories, trajectories_lf, lanes, count, alpha)];
                    count = count + 1;
                elseif lanetraj(1) == 2 & lanetraj(end) == 1
                    alpha = -1;
                    output_right_bus = [output_right_bus; new_get_trajectory_data_for_choice_models(id, trajectories, trajectories_lf, lanes, count, alpha)];
                    count = count + 1;
                end
            end
        end
    end
end

% idx = find(output(:,end-1)==-1);
% output(idx, end-1) = 1;

writematrix(output_left_bus);
writematrix(output_right_bus);
toc
%% Old code
% data = trajectories(1);
% index = [];
% 
% for i = 1:length(data.t)
%     if rem(data.t(i),1) == 0
%         index = [index; i];
%     end
% end
% 
% local_id = data.id*ones(size(index,1),1);
% local_time = data.t(index);
% local_veh_length = data.l*ones(size(index,1),1);
% local_veh_speed = data.v_cal(index);
% local_veh_acc = data.a_cal(index);
% local_lead_gap = trajectories_lf(1).lead_s_nett(index,2);
% local_lag_gap = trajectories_lf(1).foll_s_nett(index,2);
% local_left_lead_veh = trajectories_lf(1).leader(index,1);
% local_right_lead_veh = trajectories_lf(1).leader(index,3);
% local_left_lag_veh = trajectories_lf(1).follower(index,1);
% local_right_lag_veh = trajectories_lf(1).follower(index,3);
% local_current_lead = trajectories_lf(1).leader(index,2);
% local_current_lead_veh_length = [];
% local_veh_lanes = data.lanes(index);
% local_left_lag_speed = [];
% local_left_lead_speed = [];
% local_right_lag_speed = [];
% local_right_lead_speed = [];
% local_lane_density = [];
% 
% for j = 1:length(local_time)
%     local_left_lag_speed = [local_left_lag_speed; match_speed(local_left_lag_veh(j), local_time(j), trajectories)];
%     local_left_lead_speed = [local_left_lead_speed; match_speed(local_left_lead_veh(j), local_time(j), trajectories)];
%     local_right_lag_speed = [local_right_lag_speed; match_speed(local_right_lag_veh(j), local_time(j), trajectories)];
%     local_right_lead_speed = [local_right_lead_speed; match_speed(local_right_lead_veh(j), local_time(j), trajectories)];
%     local_lane_density = [local_lane_density; lane_density(trajectories, local_time(j), local_veh_lanes(j))];
%     local_current_lead_veh_length = [local_current_lead_veh_length; lead_veh_length(local_current_lead(j), trajectories)];
% end
% 
% output = [local_id, local_time, local_veh_length, local_veh_speed, local_veh_acc, local_lead_gap, ...
%     local_lag_gap, local_current_lead_veh_length, ...
%     local_left_lag_speed, local_left_lead_speed, local_right_lag_speed, local_right_lead_speed, ...
%     local_lane_density, local_veh_lanes];