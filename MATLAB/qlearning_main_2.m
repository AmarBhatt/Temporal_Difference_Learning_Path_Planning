% Implements Q-Learning
function Q = qlearning_main_2(m,n,s,terrain,gamma,episodes,epsilon,g_reward,a_reward,init_q,weights,pun)


max_trials = epsilon*episodes;

goal = m*n;
state = [1:m*n];
R = [[]];

elem_cnt = 1;        
%create rewards matrix
for i=1:size(terrain,1)
    for j=1:size(terrain,2)
        
        temp = ones(1,size(terrain,1)*size(terrain,2));
        temp = temp - Inf;
        %check up
        if(i-1 > 0)        
            temp((i-1-1)*n+j) = a_reward;
        end
        %check down
        if(i+1 < size(terrain,1)+1)        
            temp((i+1-1)*n+j) = a_reward;
        end
        %check left
        if(j-1 > 0)       
            temp((i-1)*n+(j-1)) = a_reward;
        end
        %check right
        if(j+1 < size(terrain,2)+1)        
            temp((i-1)*n+(j+1)) = a_reward;
        end
        
        R(elem_cnt,:) = temp;
        elem_cnt = elem_cnt + 1;    
    end
end

%Set goal state reward

step_before_goal = find(R(:,goal) == 0);
for i = 1:length(step_before_goal)
    R(step_before_goal,goal) = g_reward;
end
%Add reward to stay at goal
R(goal,goal) = g_reward;

 
% Initialize Q to 0 (robot knows nothing in beginning
Q = zeros(size(R,1),size(R,2));
modR = R;
modR(find(modR~=-Inf)) = 0;
Q = Q + init_q + modR;

for j=1:episodes %episodes
    x = randperm(numel(state));
    cur_state = x(1);

    while (cur_state ~= goal)
        actions = find(R(cur_state,:)>-inf);
        if (j < max_trials)
            r = randperm(numel(actions));
        else
            [~,r] = max(actions);
        end
        reward = R(cur_state,actions(r(1)));
        a = actions(r(1));
        Q(cur_state,actions(r(1))) = Q(cur_state,actions(r(1))) + (reward + gamma * max(Q(actions(r(1)),:)) - Q(cur_state,a)) - punishment(cur_state, terrain, weights,pun);
        
        cur_state = actions(r(1));
    end
end

Q;

%normalized Q

Q_norm = Q/max(max(Q));

