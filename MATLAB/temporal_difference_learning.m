% Testing Script

clear all; close all;
dim = [5,10,15,25]; %map sizes to be tested
iter= 10; %number of iterations per map size
fileID = fopen('../OUTPUT/out_new2525final.txt','w'); %output log file
for u = 1:length(dim)
    %%Set up    
    m = dim(u);
    n = dim(u);
    s = 5;
    
    epsilon = 0.2;
    episodes = 10000;
    %types = ['S','F','P','W','R'];
    %encoder, ultrasonic, shock sensor, moisture, pressure, steepness
    weights = [ 0.4     0       0       0.2     0.3     0.1;
                0.5     0.7     0.6     0       0       0.2;
                0       0       0       0       0       0;
                0.9     0.2     0.1     1       0.8     0;
                1       1       1       0       0       1];
    
    total_path_q = 0; 
    total_cost_q = 0;
    total_cost_per_unit_q = 0;
    total_time_q = 0;   
    
    total_path_s = 0; 
    total_cost_s = 0;
    total_cost_per_unit_s = 0;
    total_time_s = 0;
    
    qfail = 0;
    sfail = 0;
    
    for g = 1:iter
    close all;
    terrain = map_create(m,n,s);
    
    %% Q-Learning
    %clear all; close all;
    gamma = 0.8; %learning parameter

    g_reward = 1000;
    a_reward = 0;
    init_q = 0;
    pun = 0.01;
    fail = 0;

    fprintf('Solving Q (using Q-Learning)...\n');
    s_time = tic;
    Q = qlearning_main_2(m,n,s,terrain,gamma,episodes,epsilon,g_reward,a_reward,init_q,weights,pun);
    e_time = toc(s_time);
    fprintf('Plot terrain...\n');
    %Print Matrix
    figure;
    hold on;
    for i = 1:m
        for j = 1:n
            if terrain(i,j) == 1
                plot(j,i,'ms','MarkerFaceColor','m','LineWidth',5);
            elseif terrain(i,j) == 2
                plot(j,i,'gs','MarkerFaceColor','g','LineWidth',5);
            elseif terrain(i,j) == 3
                plot(j,i,'ks','MarkerFaceColor','k','LineWidth',5);
            elseif terrain(i,j) == 4
                plot(j,i,'bs','MarkerFaceColor','b','LineWidth',5);
            else
                plot(j,i,'rs','MarkerFaceColor','r','LineWidth',5);
            end                
        end
    end

    set(gca,'YDir','reverse')
    axis off;

    fprintf('Generating Path...\n\n');
    fprintf(fileID,'Q-Learning %dx%d Iteration: %d Results:\n',m,n,g);
    %Generate path
    mQ = Q;
    current_state = 1;
    goal = m*n;
    path = [];
    count = 1;
    while(current_state ~= goal)

        fprintf('%d -> ',current_state);
        path(count) = current_state;
        mQ(:,current_state) = -Inf;
        [~,current_state] = max(mQ(current_state,:));
        count = count + 1;
        if(count > m*n)
            fprintf('\n Failed to converge');
            fail = 1;
            qfail = qfail + 1;
            break;
        end
    end
    path(count) = goal;
    fprintf('%d\n',goal);

    for v = 1:length(path)
        [r,c] = getIndices(m,n,path(v));
        plot(c,r,'wx','LineWidth',3);
    end
    title( sprintf('Q-Learning World Path'), 'fontsize',18);
    set(gca, 'fontsize', 18, 'linewidth', 2);
    [c,average] = path_cost(terrain,path,weights);
    if(fail == 1)
        fprintf(fileID,'FAILURE FAILURE FAILURE\n');
    end
    fprintf(fileID,'Path Length:\t%d\nTotal Path Cost:\t%f\nAverage Cost:\t%f\nAlgorithm Time\t%f\n\n\n',length(path),c,average,e_time);

   

    descr = {sprintf('Path Length(%d) | Path Cost(%d) | Avg. Cost(%f) | Algorithm Time(%f)',length(path),c,average,e_time);
            };
    
    text(0,m+2,descr);
    set(gcf,'InvertHardCopy','off');
    print(sprintf('../IMAGES/q-learning_%dx%d_NEW2525final_%d',m,n,g),'-dpdf');
    if(fail == 0)
        total_path_q = total_path_q + length(path); 
        total_cost_q = total_cost_q + c;
        total_cost_per_unit_q = total_cost_per_unit_q + average;
        total_time_q = total_time_q + e_time;
    end

    %% Sarsa
    %clear all; close all;
    gamma = 0.3; %learning parameter

    g_reward = 1000;
    a_reward = 0;
    init_q = 0;
    pun = 1;
    fail = 0;
    
    fprintf('Solving Q (using Sarsa)...\n');
    s_time = tic;        
    Q = sarsa_main_2(m,n,s,terrain,gamma,episodes,epsilon,g_reward,a_reward,init_q,weights,pun);
    e_time = toc(s_time);
    fprintf('Plot terrain...\n');
    %Print Matrix
    figure;
    hold on;
    for i = 1:m
        for j = 1:n
            if terrain(i,j) == 1
                plot(j,i,'ms','MarkerFaceColor','m','LineWidth',5);
            elseif terrain(i,j) == 2
                plot(j,i,'gs','MarkerFaceColor','g','LineWidth',5);
            elseif terrain(i,j) == 3
                plot(j,i,'ks','MarkerFaceColor','k','LineWidth',5);
            elseif terrain(i,j) == 4
                plot(j,i,'bs','MarkerFaceColor','b','LineWidth',5);
            else
                plot(j,i,'rs','MarkerFaceColor','r','LineWidth',5);
            end                
        end
    end

    set(gca,'YDir','reverse')
    axis off;
    fprintf('Generating Path...\n\n');
    fprintf(fileID,'Sarsa %dx%d Iteration: %d Results:\n',m,n,g);
    %Generate path
    mQ = Q;
    current_state = 1;
    goal = m*n;
    path = [];
    count = 1;
    while(current_state ~= goal)

        fprintf('%d -> ',current_state);
        path(count) = current_state;
        mQ(:,current_state) = -Inf;
        [~,current_state] = max(mQ(current_state,:));
        count = count + 1;
        if(count > m*n)
            fprintf('\n Failed to converge');
            fail = 1;
            sfail = sfail + 1;
            break;
        end
    end
    path(count) = goal;
    fprintf('%d\n',goal);

    for v = 1:length(path)
        [r,c] = getIndices(m,n,path(v));
        plot(c,r,'wx','LineWidth',3);
    end
    title( sprintf('Sarsa World Path'), 'fontsize',18);
    set(gca, 'fontsize', 18, 'linewidth', 2);
    [c,average] = path_cost(terrain,path,weights);
    if(fail == 1)
        fprintf(fileID,'FAILURE FAILURE FAILURE\n');
    end
    fprintf(fileID,'Path Length:\t%d\nTotal Path Cost:\t%f\nAverage Cost:\t%f\nAlgorithm Time\t%f\n\n\n',length(path),c,average,e_time);

   

    descr = {sprintf('Path Length(%d) | Path Cost(%d) | Avg. Cost(%f) | Algorithm Time(%f)',length(path),c,average,e_time);
            };
    
    text(0,m+2,descr);
    set(gcf,'InvertHardCopy','off');
    print(sprintf('../IMAGES/sarsa_%dx%d_NEW2525final_%d',m,n,g),'-dpdf');
    if(fail == 0)
        total_path_s = total_path_s + length(path); 
        total_cost_s = total_cost_s + c;
        total_cost_per_unit_s = total_cost_per_unit_s + average;
        total_time_s = total_time_s + e_time;
    end
    end
    fprintf(fileID,'Q-Learning %dx%d Total Results:\n',m,n);
    qtot = iter-qfail;
    fprintf(fileID,'Success: %d/%d --> %f\n',qtot,iter,(qtot/iter)*100);    
    fprintf(fileID,'Total Path Length:\t%d\nTotal Path Cost:\t%f\nTotal Unit Cost:\t%f\nTotal Algorithm Time\t%f\n',total_path_q,total_cost_q,total_cost_per_unit_q,total_time_q);   
    fprintf(fileID,'Avg. Path Length:\t%f\nAvg. Path Cost:\t%f\nAvg. Unit Cost:\t%f\nAvg. Algorithm Time\t%f\n\n',total_path_q/qtot,total_cost_q/qtot,total_cost_per_unit_q/qtot,total_time_q/qtot);   
    fprintf(fileID,'Sarsa %dx%d Total Results:\n',m,n);
    stot = iter-sfail;
    fprintf(fileID,'Success: %d/%d --> %f\n',stot,iter,(stot/iter)*100);
    fprintf(fileID,'Total Path Length:\t%d\nTotal Path Cost:\t%f\nTotal Unit Cost:\t%f\nTotal Algorithm Time\t%f\n',total_path_s,total_cost_s,total_cost_per_unit_s,total_time_s);   
    fprintf(fileID,'Avg. Path Length:\t%f\nAvg. Path Cost:\t%f\nAvg. Unit Cost:\t%f\nAvg. Algorithm Time\t%f\n\n',total_path_s/stot,total_cost_s/stot,total_cost_per_unit_s/stot,total_time_s/stot);
    
end
fclose(fileID);