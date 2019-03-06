clear
clc

%% Match ID Download
header = {'accept' 'application/vnd.api+json'; 'Authorization' 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJlNTMzZmM1MC0xZWY4LTAxMzctNDUwMi0wYjk1YTc3YTFhOGMiLCJpc3MiOiJnYW1lbG9ja2VyIiwiaWF0IjoxNTUxNTE3ODA2LCJwdWIiOiJibHVlaG9sZSIsInRpdGxlIjoicHViZyIsImFwcCI6Im9wZ2dyZWNydWl0In0.x5m-RGlWJSJLRgFrB1K6g6OkcDUVTxktBQ9bMyPz880';};
options = weboptions('HeaderFields', header);
url_tournament = 'https://api.pubg.com/tournaments/kr-pkl18';
url_match_head = 'https://api.pubg.com/shards/tournament/matches/';
data_tournament = webread(url_tournament, options);

clear header url_tournament

% % PKL Season2 Match Date Number: To eliminate dummy game
% pkl2_date = datenum(datetime('2018-10-01'));
% pkl2_date = reshape(pkl2_date + repmat(0:2:4,[7 1]) + repmat([(0:7:7*5) 49]',[1 3]),[7*3 1]);
% pkl2_date = [pkl2_date;datenum(datetime('2018-12-01'))];

num = 1;
num_1 = 1;
num_2 = 1;
data_match = struct([]);

i_erangel_x = [];
i_erangel_y = [];
i_erangel_z = [];
i_erangel_p = [];
i_erangel_t = [];
i2_erangel_x = [];
i2_erangel_y = [];
i2_erangel_z = [];
i2_erangel_p = [];
i5_erangel_x = [];
i5_erangel_y = [];
i5_erangel_z = [];
i5_erangel_p = [];
i_miramar_x = [];
i_miramar_y = [];
i_miramar_z = [];
i_miramar_p = [];
i_miramar_t = [];
i2_miramar_x = [];
i2_miramar_y = [];
i2_miramar_z = [];
i2_miramar_p = [];
i5_miramar_x = [];
i5_miramar_y = [];
i5_miramar_z = [];
i5_miramar_p = [];

p_erangel_x = [];
p_erangel_y = [];
p_erangel_z = [];
p_erangel_p = [];
p_miramar_x = [];
p_miramar_y = [];
p_miramar_z = [];
p_miramar_p = [];

c_erangel_dis = [];
c_erangel_p = [];
c_miramar_dis = [];
c_miramar_p = [];

% k_erangel_x = [];
% k_erangel_y = [];
% k_erangel_z = [];
% k_erangel_p = [];
% k_miramar_x = [];
% k_miramar_y = [];
% k_miramar_z = [];
% k_miramar_p = [];

% HS_erangel_count = 0;
% TS_erangel_count = 0;
% S_erangel_count = 0;
% HS_miramar_count = 0;
% TS_miramar_count = 0;
% S_miramar_count = 0;

for i=1:size(data_tournament.included,1)
    tic
    
    % Dummy Check by date
%     match_date = floor(datenum(datetime(data_tournament.included(i).attributes.createdAt,'inputFormat','yyyy-MM-dd''T''HH:mm:ss''Z')));
%     if nnz((pkl2_date==match_date)) == 0
%         continue;
%     end
    
    %% Match Data Download
    data_match_temp = webread([url_match_head data_tournament.included(i).id], options);
    if size(data_match_temp.included,1) == 81
        data_match(num,1).match = data_match_temp;
        num = num+1;
        [idx,~] = find(string(cellfun(@(x) x.type, data_match_temp.included, 'UniformOutput', false)) == "asset");
        data_telemetry_temp = webread(data_match_temp.included{idx,1}.attributes.URL, options);
        
       %% Match Telemetry Processing
        % data_telemetry_temp(1) always LogMatchDefinition, useless
        type_event = cellfun(@(x) x.x_T, data_telemetry_temp(2:end),'UniformOutput',false);
        % Item Pickup Data
        item_position_x = cellfun(@(x) x.character.location.x, data_telemetry_temp([false; type_event == "LogItemPickup"]),'UniformOutput',false);
        item_position_y = cellfun(@(x) x.character.location.y, data_telemetry_temp([false; type_event == "LogItemPickup"]),'UniformOutput',false);
        item_position_z = cellfun(@(x) x.character.location.z, data_telemetry_temp([false; type_event == "LogItemPickup"]),'UniformOutput',false);
        item_phase = cellfun(@(x) x.common.isGame, data_telemetry_temp([false; type_event == "LogItemPickup"]),'UniformOutput',false);
        item_team = cellfun(@(x) x.character.teamId, data_telemetry_temp([false; type_event == "LogItemPickup"]),'UniformOutput',false);
        
        % Item Use Data
        item2_position_x = cellfun(@(x) x.character.location.x, data_telemetry_temp([false; type_event == "LogItemUse"]),'UniformOutput',false);
        item2_position_y = cellfun(@(x) x.character.location.y, data_telemetry_temp([false; type_event == "LogItemUse"]),'UniformOutput',false);
        item2_position_z = cellfun(@(x) x.character.location.z, data_telemetry_temp([false; type_event == "LogItemUse"]),'UniformOutput',false);
        item2_phase = cellfun(@(x) x.common.isGame, data_telemetry_temp([false; type_event == "LogItemUse"]),'UniformOutput',false);
        
%         % Item Equip Data
%         item3_position_x = cellfun(@(x) x.character.location.x, data_telemetry_temp([false; type_event == "LogItemEquip"]),'UniformOutput',false);
%         item3_position_y = cellfun(@(x) x.character.location.y, data_telemetry_temp([false; type_event == "LogItemEquip"]),'UniformOutput',false);
%         item3_position_z = cellfun(@(x) x.character.location.z, data_telemetry_temp([false; type_event == "LogItemEquip"]),'UniformOutput',false);
%         item3_phase = cellfun(@(x) x.common.isGame, data_telemetry_temp([false; type_event == "LogItemEquip"]),'UniformOutput',false);
%         item3_name = cellfun(@(x) x.item.itemId, data_telemetry_temp([false; type_event == "LogItemEquip"]),'UniformOutput',false);
%         
%         % Item Unequip Data
%         item4_position_x = cellfun(@(x) x.character.location.x, data_telemetry_temp([false; type_event == "LogItemUnequip"]),'UniformOutput',false);
%         item4_position_y = cellfun(@(x) x.character.location.y, data_telemetry_temp([false; type_event == "LogItemUnequip"]),'UniformOutput',false);
%         item4_position_z = cellfun(@(x) x.character.location.z, data_telemetry_temp([false; type_event == "LogItemUnequip"]),'UniformOutput',false);
%         item4_phase = cellfun(@(x) x.common.isGame, data_telemetry_temp([false; type_event == "LogItemUnequip"]),'UniformOutput',false);
%         item4_name = cellfun(@(x) x.item.itemId, data_telemetry_temp([false; type_event == "LogItemUnequip"]),'UniformOutput',false);
        
        % Item Destroy Data
        item5_position_x = cellfun(@(x) x.victim.location.x, data_telemetry_temp([false; type_event == "LogArmorDestroy"]),'UniformOutput',false);
        item5_position_y = cellfun(@(x) x.victim.location.y, data_telemetry_temp([false; type_event == "LogArmorDestroy"]),'UniformOutput',false);
        item5_position_z = cellfun(@(x) x.victim.location.z, data_telemetry_temp([false; type_event == "LogArmorDestroy"]),'UniformOutput',false);
        item5_phase = cellfun(@(x) x.common.isGame, data_telemetry_temp([false; type_event == "LogArmorDestroy"]),'UniformOutput',false);
        
        % Position Data
        p_x = cellfun(@(x) x.character.location.x, data_telemetry_temp([false; type_event == "LogPlayerPosition"]),'UniformOutput',false);
        p_y = cellfun(@(x) x.character.location.y, data_telemetry_temp([false; type_event == "LogPlayerPosition"]),'UniformOutput',false);
        p_z = cellfun(@(x) x.character.location.z, data_telemetry_temp([false; type_event == "LogPlayerPosition"]),'UniformOutput',false);
        p_phase = cellfun(@(x) x.common.isGame, data_telemetry_temp([false; type_event == "LogPlayerPosition"]),'UniformOutput',false);
        
        % Player Combat Data
%         combat_damagereason = cellfun(@(x) x.damageReason, data_telemetry_temp([false; type_event == "LogArmorDestroy" | type_event == "LogPlayerKill" | type_event == "LogPlayerMakeGroggy" | type_event == "LogPlayerTakeDamage"]),'UniformOutput',false);
        
        combat_distance = cellfun(@(x) x.distance, data_telemetry_temp([false; type_event == "LogArmorDestroy" | type_event == "LogPlayerKill" | type_event == "LogPlayerMakeGroggy"]),'UniformOutput',false);       
        combat_phase = cellfun(@(x) x.common.isGame, data_telemetry_temp([false; type_event == "LogArmorDestroy" | type_event == "LogPlayerKill" | type_event == "LogPlayerMakeGroggy"]),'UniformOutput',false);
        
%         combat_weapon = cellfun(@(x) x.damageCauserName, data_telemetry_temp([false; type_event == "LogPlayerTakeDamage"]),'UniformOutput',false);
%         combat_damage = cellfun(@(x) x.damage, data_telemetry_temp([false; type_event == "LogPlayerTakeDamage"]),'UniformOutput',false);
%         
%         kill_position_x = cellfun(@(x) x.victim.location.x, data_telemetry_temp([false; type_event == "LogPlayerKill"]),'UniformOutput',false);
%         kill_position_y = cellfun(@(x) x.victim.location.y, data_telemetry_temp([false; type_event == "LogPlayerKill"]),'UniformOutput',false);
%         kill_position_z = cellfun(@(x) x.victim.location.z, data_telemetry_temp([false; type_event == "LogPlayerKill"]),'UniformOutput',false);
%         kill_phase = cellfun(@(x) x.common.isGame, data_telemetry_temp([false; type_event == "LogPlayerKill"]),'UniformOutput',false);

        % Transform Data
        if data_match_temp.data.attributes.mapName == "Erangel_Main"
            num_1 = num_1+1;
            
            % Item Pickup Data
            i_erangel_x = cat(1,i_erangel_x,cell2mat(item_position_x));
            i_erangel_y = cat(1,i_erangel_y,cell2mat(item_position_y));
            i_erangel_z = cat(1,i_erangel_z,cell2mat(item_position_z));
            i_erangel_p = cat(1,i_erangel_p,cell2mat(item_phase));
            i_erangel_t = cat(1,i_erangel_t,16*(num_1-2)+cell2mat(item_team));
            
            % Item Use/Drop Data
            i2_erangel_x = cat(1,i2_erangel_x,cell2mat(item2_position_x));
            i2_erangel_y = cat(1,i2_erangel_y,cell2mat(item2_position_y));
            i2_erangel_z = cat(1,i2_erangel_z,cell2mat(item2_position_z));
            i2_erangel_p = cat(1,i2_erangel_p,cell2mat(item2_phase));
            
%             % Item Equip Data
%             i3_erangel_x = cat(1,i3_erangel_x,cell2mat(item3_position_x));
%             i3_erangel_y = cat(1,i3_erangel_y,cell2mat(item3_position_y));
%             i3_erangel_z = cat(1,i3_erangel_z,cell2mat(item3_position_z));
%             i3_erangel_p = cat(1,i3_erangel_p,cell2mat(item3_phase));
%             i3_erangel_n = cat(1,i3_erangel_n,string(item3_name));
%             
%             % Item Unequip Data
%             i4_erangel_x = cat(1,i4_erangel_x,cell2mat(item4_position_x));
%             i4_erangel_y = cat(1,i4_erangel_y,cell2mat(item4_position_y));
%             i4_erangel_z = cat(1,i4_erangel_z,cell2mat(item4_position_z));
%             i4_erangel_p = cat(1,i4_erangel_p,cell2mat(item4_phase));
%             i4_erangel_n = cat(1,i4_erangel_n,string(item4_name));
            
            % Item Destroy Data
            i5_erangel_x = cat(1,i5_erangel_x,cell2mat(item5_position_x));
            i5_erangel_y = cat(1,i5_erangel_y,cell2mat(item5_position_y));
            i5_erangel_z = cat(1,i5_erangel_z,cell2mat(item5_position_z));
            i5_erangel_p = cat(1,i5_erangel_p,cell2mat(item5_phase));
            
            % Position Data
            p_erangel_x = cat(1,p_erangel_x,cell2mat(p_x));
            p_erangel_y = cat(1,p_erangel_y,cell2mat(p_y));
            p_erangel_z = cat(1,p_erangel_z,cell2mat(p_z));
            p_erangel_p = cat(1,p_erangel_p,cell2mat(p_phase));
            
%             % Shot Count
%             HS_erangel_count = HS_erangel_count + nnz(combat_damagereason == "HeadShot");
%             TS_erangel_count = TS_erangel_count + nnz(combat_damagereason == "TorsoShot");
%             S_erangel_count = S_erangel_count + nnz(combat_damagereason == "HeadShot" | combat_damagereason == "ArmShot" | combat_damagereason == "LegShot" | combat_damagereason == "PelvisShot" | combat_damagereason == "TorsoShot");
            
            % Combat Distance
            c_erangel_dis = cat(1,c_erangel_dis,cell2mat(combat_distance));
            c_erangel_p = cat(1,c_erangel_p,cell2mat(combat_phase));
            
%             % Weapon & Damage
%             c_erangel_w = cat(1,c_erangel_w,string(combat_weapon));
%             c_erangel_dmg = cat(1,c_erangel_dmg,cell2mat(combat_damage));
%             
%             % Kill
%             k_erangel_x = cat(1,k_erangel_x,cell2mat(kill_position_x));
%             k_erangel_y = cat(1,k_erangel_y,cell2mat(kill_position_y));
%             k_erangel_z = cat(1,k_erangel_z,cell2mat(kill_position_z));
%             k_erangel_p = cat(1,k_erangel_p,cell2mat(kill_phase));
            
        else
            num_2 = num_2+1;
            
            % Item Pickup Data
            i_miramar_x = cat(1,i_miramar_x,cell2mat(item_position_x));
            i_miramar_y = cat(1,i_miramar_y,cell2mat(item_position_y));
            i_miramar_z = cat(1,i_miramar_z,cell2mat(item_position_z));
            i_miramar_p = cat(1,i_miramar_p,cell2mat(item_phase));
            i_miramar_t = cat(1,i_miramar_t,16*(num_2-2)+cell2mat(item_team));
            
            % Item Use/Drop Data
            i2_miramar_x = cat(1,i2_miramar_x,cell2mat(item2_position_x));
            i2_miramar_y = cat(1,i2_miramar_y,cell2mat(item2_position_y));
            i2_miramar_z = cat(1,i2_miramar_z,cell2mat(item2_position_z));
            i2_miramar_p = cat(1,i2_miramar_p,cell2mat(item2_phase));
            
%             % Item Equip Data
%             i3_miramar_x = cat(1,i3_miramar_x,cell2mat(item3_position_x));
%             i3_miramar_y = cat(1,i3_miramar_y,cell2mat(item3_position_y));
%             i3_miramar_z = cat(1,i3_miramar_z,cell2mat(item3_position_z));
%             i3_miramar_p = cat(1,i3_miramar_p,cell2mat(item3_phase));
%             i3_miramar_n = cat(1,i3_miramar_n,string(item3_name));
%             
%             % Item Unequip Data
%             i4_miramar_x = cat(1,i4_miramar_x,cell2mat(item4_position_x));
%             i4_miramar_y = cat(1,i4_miramar_y,cell2mat(item4_position_y));
%             i4_miramar_z = cat(1,i4_miramar_z,cell2mat(item4_position_z));
%             i4_miramar_p = cat(1,i4_miramar_p,cell2mat(item4_phase));
%             i4_miramar_n = cat(1,i4_miramar_n,string(item4_name));
            
            % Item Destroy Data
            i5_miramar_x = cat(1,i5_miramar_x,cell2mat(item5_position_x));
            i5_miramar_y = cat(1,i5_miramar_y,cell2mat(item5_position_y));
            i5_miramar_z = cat(1,i5_miramar_z,cell2mat(item5_position_z));
            i5_miramar_p = cat(1,i5_miramar_p,cell2mat(item5_phase));
            
            % Position Data
            p_miramar_x = cat(1,p_miramar_x,cell2mat(p_x));
            p_miramar_y = cat(1,p_miramar_y,cell2mat(p_y));
            p_miramar_z = cat(1,p_miramar_z,cell2mat(p_z));
            p_miramar_p = cat(1,p_miramar_p,cell2mat(p_phase));
            
%             % Shot Count
%             HS_miramar_count = HS_miramar_count + nnz(combat_damagereason == "HeadShot");
%             TS_miramar_count = TS_miramar_count + nnz(combat_damagereason == "TorsoShot");
%             S_miramar_count = S_miramar_count + nnz(combat_damagereason == "HeadShot" | combat_damagereason == "ArmShot" | combat_damagereason == "LegShot" | combat_damagereason == "PelvisShot" | combat_damagereason == "TorsoShot");
            
            % Combat Distance
            c_miramar_dis = cat(1,c_miramar_dis,cell2mat(combat_distance));
            c_miramar_p = cat(1,c_miramar_p,cell2mat(combat_phase));
            
%             % Weapon & Damage
%             c_miramar_w = cat(1,c_miramar_w,string(combat_weapon));
%             c_miramar_dmg = cat(1,c_miramar_dmg,cell2mat(combat_damage));
%             
%             % Kill
%             k_miramar_x = cat(1,k_miramar_x,cell2mat(kill_position_x));
%             k_miramar_y = cat(1,k_miramar_y,cell2mat(kill_position_y));
%             k_miramar_z = cat(1,k_miramar_z,cell2mat(kill_position_z));
%             k_miramar_p = cat(1,k_miramar_p,cell2mat(kill_phase));
            
        end
%         landing_position_x = cellfun(@(x) x.character.location.x, data_telemetry_temp([false; type_event == "LogParachuteLanding"]),'UniformOutput',false);
%         landing_position_y = cellfun(@(x) x.character.location.y, data_telemetry_temp([false; type_event == "LogParachuteLanding"]),'UniformOutput',false);
    end
    toc
end

clear url_match_head options type_event item_position_x item_position_y item_position_z item_phase item_team item2_position_x item2_position_y item2_position_z item2_phase item5_position_x item5_position_y item5_position_z item5_phase p_x p_y p_z p_phase combat_distance combat_phase
%% Phase-Distance Graph

erangel_dis = zeros(1,18);
miramar_dis = zeros(1,18);
erangel_dis2 = zeros(1,18);
miramar_dis2 = zeros(1,18);
erangel_dis3 = zeros(1,18);
miramar_dis3 = zeros(1,18);

for i=1:0.5:9.5
    erangel_dis(i*2-1) = mean(c_erangel_dis(c_erangel_p==i)); 
    miramar_dis(i*2-1) = mean(c_miramar_dis(c_miramar_p==i));
    erangel_dis2(i*2-1) = median(c_erangel_dis(c_erangel_p==i)); 
    miramar_dis2(i*2-1) = median(c_miramar_dis(c_miramar_p==i));
    erangel_dis3(i*2-1) = max(c_erangel_dis(c_erangel_p==i)); 
    miramar_dis3(i*2-1) = max(c_miramar_dis(c_miramar_p==i));
end

figure;
plot(1:0.5:9.5,erangel_dis,'.-','color','b');
hold on
plot(1:0.5:9.5,miramar_dis,'.-','color','y');
plot(1:0.5:9.5,erangel_dis2,'.-','color','g');
plot(1:0.5:9.5,miramar_dis2,'.-','color','r');
plot(1:0.5:9.5,erangel_dis3,'.-','color','c');
plot(1:0.5:9.5,miramar_dis3,'.-','color','k');
xlabel("Phase")
ylabel("Combat Distance")
title("Combat Distance - Phase")
legend("Erangel,mean","Miramar,mean","Erangel,median","Miramar,median","Erangel,max","Miramar,max");
axis([1 10 0 9e4])

%% Item Map Clustering

% Erangel
[i_seed_erangel_x, i_seed_erangel_y, i_seed_erangel_r, item_class_erangel, item_fp_erangel_x, item_fp_erangel_y, item_fp_erangel_t] = K_cluster(num_1,i_erangel_t,i_erangel_p,i_erangel_x,i_erangel_y);
% Miramar
[i_seed_miramar_x, i_seed_miramar_y, i_seed_miramar_r, item_class_miramar, item_fp_miramar_x, item_fp_miramar_y, item_fp_miramar_t] = K_cluster(num_2,i_miramar_t,i_miramar_p,i_miramar_x,i_miramar_y);

%% Cluster Scoring

% Erangel
[item2_class_erangel, item2_fp_erangel_x, item2_fp_erangel_y] = K_classify(i_seed_erangel_x,i_seed_erangel_y,i2_erangel_x,i2_erangel_y,i2_erangel_p);
[item5_class_erangel, item5_fp_erangel_x, item5_fp_erangel_y] = K_classify(i_seed_erangel_x,i_seed_erangel_y,i5_erangel_x,i5_erangel_y,i5_erangel_p);

item_score_erangel_cluster = zeros(size(i_seed_erangel_r));
item_erangel_cluster_games = zeros(size(i_seed_erangel_r));
i_seed_erangel_dis = sqrt((repmat(i_seed_erangel_x,[size(i_seed_erangel_x,2) 1])-repmat(i_seed_erangel_x',[1 size(i_seed_erangel_x,2)])).^2+(repmat(i_seed_erangel_y,[size(i_seed_erangel_y,2) 1])-repmat(i_seed_erangel_y',[1 size(i_seed_erangel_y,2)])).^2);
i_seed_erangel_dis(i_seed_erangel_dis==0) = NaN;
[i_seed_erangel_R,idx] = min(i_seed_erangel_dis);
i_seed_erangel_R = (i_seed_erangel_R + i_seed_erangel_r - i_seed_erangel_r(idx))/2;
for i=1:size(i_seed_erangel_R,2)
    item_erangel_cluster_games(i) = size(unique(floor((item_fp_erangel_t(item_class_erangel==i)-1)/16)),1);
    item_score_erangel_cluster(i) = (nnz(item_class_erangel==i)-nnz(item2_class_erangel==i)-nnz(item5_class_erangel==i))/(i_seed_erangel_R(i)^2*item_erangel_cluster_games(i));
end

[~,max_idx] = maxk(item_score_erangel_cluster,10);
figure; imshow(erangel);
hold on
for i=max_idx
plot(item_fp_erangel_x(item_class_erangel==i)/100+1,item_fp_erangel_y(item_class_erangel==i)/100-2,'.')
end

% Miramar
[item2_class_miramar, item2_fp_miramar_x, item2_fp_miramar_y] = K_classify(i_seed_miramar_x,i_seed_miramar_y,i2_miramar_x,i2_miramar_y,i2_miramar_p);
[item5_class_miramar, item5_fp_miramar_x, item5_fp_miramar_y] = K_classify(i_seed_miramar_x,i_seed_miramar_y,i5_miramar_x,i5_miramar_y,i5_miramar_p);

item_score_miramar_cluster = zeros(size(i_seed_miramar_r));
item_miramar_cluster_games = zeros(size(i_seed_miramar_r));
i_seed_miramar_dis = sqrt((repmat(i_seed_miramar_x,[size(i_seed_miramar_x,2) 1])-repmat(i_seed_miramar_x',[1 size(i_seed_miramar_x,2)])).^2+(repmat(i_seed_miramar_y,[size(i_seed_miramar_y,2) 1])-repmat(i_seed_miramar_y',[1 size(i_seed_miramar_y,2)])).^2);
i_seed_miramar_dis(i_seed_miramar_dis==0) = NaN;
[i_seed_miramar_R,idx] = min(i_seed_miramar_dis);
i_seed_miramar_R = (i_seed_miramar_R + i_seed_miramar_r - i_seed_miramar_r(idx))/2;
for i=1:size(i_seed_miramar_R,2)
    item_miramar_cluster_games(i) = size(unique(floor((item_fp_miramar_t(item_class_miramar==i)-1)/16)),1);
    item_score_miramar_cluster(i) = (nnz(item_class_miramar==i)-nnz(item2_class_miramar==i)-nnz(item5_class_miramar==i))/(i_seed_miramar_R(i)^2*item_miramar_cluster_games(i));
end

[~,max_idx] = maxk(item_score_miramar_cluster,10);
figure; imshow(miramar);
hold on
for i=max_idx
plot(item_fp_miramar_x(item_class_miramar==i)/100+1,item_fp_miramar_y(item_class_miramar==i)/100-2,'.')
end

% 
% figure; imshow(erangel);
% hold on
% for i=1:size(i_seed_erangel_r,2)
%     imagesc(

% %% Item Scoring
% 
% weapon_list = ["ProjGrenade_C"
%     "ProjMolotov_C"
%     "ProjMolotov_DamageField_Direct_C"
%     "WeapAK47_C"
%     "WeapAUG_C"
%     "WeapAWM_C"
%     "WeapBerreta686_C"
%     "WeapBerylM762_C"
%     "WeapBizonPP19_C"
%     "WeapCowbar_C"
%     "WeapCrossbow_1_C"
%     "WeapDP28_C"
%     "WeapFNFal_C"
%     "WeapG18_C"
%     "WeapG36C_C"
%     "WeapGroza_C"
%     "WeapHK416_C"
%     "WeapKar98k_C"
%     "WeapM16A4_C"
%     "WeapM1911_C"
%     "WeapM249_C"
%     "WeapM24_C"
%     "WeapM9_C"
%     "WeapMachete_C"
%     "WeapMini14_C"
%     "WeapMk14_C"
%     "WeapMk47Mutant_C"
%     "WeapNagantM1895_C"
%     "WeapPan_C"
%     "WeapQBU88_C"
%     "WeapQBZ95_C"
%     "WeapRhino_C"
%     "WeapSaiga12_C"
%     "WeapSawnoff_C"
%     "WeapSCAR-L_C"
%     "WeapSickle_C"
%     "WeapSKS_C"
%     "WeapThompson_C"
%     "WeapUMP_C"
%     "WeapUZI_C"
%     "WeapVector_C"
%     "WeapVSS_C"
%     "Weapvz61Skorpion_C"
%     "WeapWin94_C"
%     "WeapWinchester_C"];
% 
% dmg_erangel = zeros(size(weapon_list));
% dmg_mirarmar = zeros(size(weapon_list));
% eqt_erangel = zeros(size(weapon_list));
% eqt_mirarmar = zeros(size(weapon_list));
% 
% for i=1:size(dmg_erangel,1)
%     dmg_erangel(i) = sum(c_erangel_dmg(c_erangel_w==weapon_list(i)));
%     eqt_erangel(i)% = ??? equip한 총 시간
%     %miramar 추가
% end
% dps_erangel = dmg_erangel./equip_erangel;
% dps_miramar = dmg_miramar./equip_miramar;
% 
% %% Item Cluster Scoring
% weapon_list = cat(2,weapon_list,["Item_Ammo_12Guage_C"
%   "Item_Ammo_300Magnum_C"
%   "Item_Ammo_45ACP_C"
%   "Item_Ammo_556mm_C"
%   "Item_Ammo_762mm_C"
%   "Item_Ammo_9mm_C"
%   "Item_Ammo_Bolt_C"
%   "Item_Ammo_Flare_C"
%   "Item_Weapon_AK47_C"
%   "Item_Weapon_Apple_C"
%   "Item_Weapon_AUG_C"
%   "Item_Weapon_AWM_C"
%   "Item_Weapon_Berreta686_C"
%   "Item_Weapon_BerylM762_C"
%   "Item_Weapon_BizonPP19_C"
%   "Item_Weapon_Cowbar_C"
%   "Item_Weapon_Crossbow_C"
%   "Item_Weapon_DP28_C"
%   "Item_Weapon_FlareGun_C"
%   "Item_Weapon_FlashBang_C"
%   "Item_Weapon_FNFal_C"
%   "Item_Weapon_G18_C"
%   "Item_Weapon_G36C_C"
%   "Item_Weapon_Grenade_C"
%   "Item_Weapon_Grenade_Warmode_C"
%   "Item_Weapon_Groza_C"
%   "Item_Weapon_HK416_C"
%   "Item_Weapon_Kar98k_C"
%   "Item_Weapon_M16A4_C"
%   "Item_Weapon_M1911_C"
%   "Item_Weapon_M249_C"
%   "Item_Weapon_M24_C"
%   "Item_Weapon_M9_C"
%   "Item_Weapon_Machete_C"
%   "Item_Weapon_Mini14_C"
%   "Item_Weapon_Mk14_C"
%   "Item_Weapon_Mk47Mutant_C"
%   "Item_Weapon_Molotov_C"
%   "Item_Weapon_NagantM1895_C"
%   "Item_Weapon_Pan_C"
%   "Item_Weapon_QBU88_C"
%   "Item_Weapon_QBZ95_C"
%   "Item_Weapon_Rhino_C"
%   "Item_Weapon_Saiga12_C"
%   "Item_Weapon_Sawnoff_C"
%   "Item_Weapon_SCAR-L_C"
%   "Item_Weapon_Sickle_C"
%   "Item_Weapon_SKS_C"
%   "Item_Weapon_SmokeBomb_C"
%   "Item_Weapon_Snowball_C"
%   "Item_Weapon_Thompson_C"
%   "Item_Weapon_UMP_C"
%   "Item_Weapon_UZI_C"
%   "Item_Weapon_Vector_C"
%   "Item_Weapon_VSS_C"
%   "Item_Weapon_vz61Skorpion_C"
%   "Item_Weapon_Win1894_C"
%   "Item_Weapon_Winchester_C"]); %% item list weapon list에 대응해서 추가
% hp_list = []; %% item list에서 해당 아이템 추가
% 
% i_erangel_dis = sqrt((repmat(i_erangel_x,size(i_seed_erangel_x))-repmat(i_seed_erangel_x,size(i_erangel_x))).^2+(repmat(i_erangel_y,size(i_seed_erangel_y))-repmat(i_seed_erangel_y,size(i_erangel_y))).^2);
% [~,i_erangel_class] = min(i_erangel_dis,[],2);
% 
% hp_score_erangel = zeros(size(i_seed_erangel_r));
% for i=1:size(hp_score_erangel,2)
%     for j=1:3
%         hp_score_erangel(i) = hp_score_erangel(i) + dps_erangel*nnz(i_erangel_n==weapon_list(j,2)&((i_erangel_p==1 | i_erangel_p==1.5)&i_erangel_class==i));% pick up +
%     for j=4:size(weapon_list,1)
%         hp_score_erangel(i) = hp_score_erangel(i) + dps_erangel*nnz(i_erangel_n==weapon_list(j,2)&((i_erangel_p==1 | i_erangel_p==1.5)&i_erangel_class==i));
%     end
% end