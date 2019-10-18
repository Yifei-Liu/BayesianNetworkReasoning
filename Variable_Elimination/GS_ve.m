%% 贪婪搜索
main;
tic;
dag_gbn=learn_struct_gs(data_trainl',node_sizes);%贪婪搜索GS（greedy search）算法
GS_t2=toc;
fprintf('贪婪搜索GS（greedy search）算法训练%d个样本%d个结点所用的时间为%d秒\n',M,N,GS_t2);
figure;
draw_graph(dag_gbn);
title('结构学习—贪婪搜索算法')

%% MLE 最大似然法参数学习
bnet2=mk_bnet(dag_gbn,node_sizes,'discrete',1:N);
priors=1;
seed = 0; 
rand('state',seed); 
% A=1;B=2;C=3;D=4;E=5;F=6;G=7;

for i=1:N
    bnet2.CPD{i} = tabular_CPD(bnet2,i); 
end

tic;
bnet3 = learn_params(bnet2,data');
params_t2=toc;
fprintf('最大似然法参数学习所用时间为%d秒\n',params_t2);
fprintf('    学习的网络名称为bnet3\n');
fprintf('\n');
CPT3=cell(1,N);
for i=1:N
      s=struct(bnet3.CPD{i});
CPT3{i}=s.CPT;
end%查看各个CPT值


%% 最大后验法的参数学习
for i=1:N
    bnet2.CPD{i}=tabular_CPD(bnet2,i,'CPT','unif','prior_type','dirichlet','dirichlet_type','BDeu','dirichlet_weight',priors);
end

tic;
bnet4=bayes_update_params(bnet2,data_trainl');%最大后验法的参数学习
update_t2=toc;
fprintf('最大后验法参数学习所用时间为%d秒\n',update_t2);
fprintf('    学习的网络名称为bnet4\n');
CPT4=cell(1,N);
for i=1:N
      s=struct(bnet4.CPD{i});
      CPT4{i}=s.CPT;
end%查看新建bnet4的CPT值
fprintf('\n')

%% %%%%%%%%%%%%%%%%%求解连通性
global visited;
connected=zeros(N,N);
 for i=1:N%在这里N=7
   %对每个结点求它可以到达的所有结点
    visited=zeros(1,N);
    myDFS( dag_gbn, i  );
    num1=1;
    for j=1:N
        if(visited(j)==1 && j~=i)
            connected(i,num1)=j;
            num1=num1+1;
        end
    end
 end
 
%% %%%推断
%% %%%推断%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%使用最大似然法学习的网络bnet3
engine=var_elim_inf_engine(bnet3);
fs3=zeros(1,N);
for Node3=1:N
    fprintf('目前计算的结点为结点%d\n',Node3);
       tic;
       if(sum(connected(Node3,:))>0)
            for j=1:N
                if connected(Node3,j)~=0
                    evidence=cell(1,N);
                    evidence{Node3}=2;
                    [engine,loglik]=enter_evidence(engine,evidence);
                    marg=marginal_nodes(engine,connected(Node3,j));
                    fprintf('    结点%d 概率%d\n',connected(Node3,j),marg.T(2));
                end
            end
       end
        
        fprintf('\n')
        
        for i=1:N
            for j=1:N
                if(connected(i,j)==Node3)
                    evidence=cell(1,N);
                    evidence{Node3}=2;
                    [engine,loglik]=enter_evidence(engine,evidence);
                    marg=marginal_nodes(engine,i);
                    fprintf('    是结点%d导致的概率为%d\n',i,marg.T(2));
                end
            end
        end

        fs3(Node3)=toc;
        fprintf('计算概率所用的时间为%d',fs3(Node3))
        fprintf('\n\n')
end

fprintf('使用bnet3推断所有结点所用的平均时间为%d秒\n',mean(fs3));
fprintf('使用bnet3推断所有结点所用的总时间为%d秒\n',sum(fs3));
fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');

engine=var_elim_inf_engine (bnet4);
fs4=zeros(1,N);
for Node4=1:N
    fprintf('目前计算的结点为结点%d\n',Node4);
       tic;
       if(sum(connected(Node4,:))>0)
            for j=1:N
                if connected(Node4,j)~=0
                    evidence=cell(1,N);
                    evidence{Node4}=2;
                    [engine,loglik]=enter_evidence(engine,evidence);
                    marg=marginal_nodes(engine,connected(Node4,j));
                    fprintf('    结点%d 概率%d\n',connected(Node4,j),marg.T(2));
                end
            end
       end
        
        fprintf('\n')
        
        for i=1:N
            for j=1:N
                if(connected(i,j)==Node4)
                    evidence=cell(1,N);
                    evidence{Node4}=2;
                    [engine,loglik]=enter_evidence(engine,evidence);
                    marg=marginal_nodes(engine,i);
                    fprintf('    是结点%d导致的概率为%d\n',i,marg.T(2));
                end
            end
        end

        fs4(Node4)=toc;
        fprintf('计算概率所用的时间为%d',fs4(Node4))
        fprintf('\n\n')
end

fprintf('使用bnet4推断所有结点所用的平均时间为%d秒\n',mean(fs4));
fprintf('使用bnet4推断所有结点所用的总时间为%d秒\n',sum(fs4));
while(1)
    network=input('输入推断所用的网络,3表示最大似然法学习的网络,4表示最大后验法学习的网络(默认为bnet3)：');
    if(network==3)
            engine=var_elim_inf_engine(bnet3);
    elseif(network==4)
        engine=var_elim_inf_engine(bnet4);
    else
        break;
    end
    while(1)
        node1=input('请输入发生的节点值：');
        if(node1==-1)
            break;
        end
        tic;

        nodes=[1:N];

        if(sum(connected(node1,:))>0)
            for j=1:N
                if connected(node1,j)~=0
                    evidence=cell(1,N);
                    evidence{node1}=2;
                    [engine,loglik]=enter_evidence(engine,evidence);
                    marg=marginal_nodes(engine,connected(node1,j));
                    fprintf('    结点%d 概率%d\n',connected(node1,j),marg.T(2));
                end
            end
        end

        fprintf('\n')
        for i=1:N
            for j=1:N
                if(connected(i,j)==node1)
                    evidence=cell(1,N);
                    evidence{node1}=2;
                    [engine,loglik]=enter_evidence(engine,evidence);
                    marg=marginal_nodes(engine,i);
                    fprintf('    是结点%d导致的概率为%d\n',i,marg.T(2));
                end
            end
        end

        fs=toc;
        fprintf('计算概率所用的时间为%d',fs)
        fprintf('\n\n')
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% for k=1:N
%     fprintf('当结点%d发生时，是其他结点发生导致的概率:\n',k)
%     for i=1:N
%         for j=1:N
%             if(connected(i,j)==k)
%                 evidence=cell(1,N);
%                 evidence{k}=1;
%                 [engine,loglik]=enter_evidence(engine,evidence);
%                 marg=marginal_nodes(engine,i);
%                 fprintf('    是结点%d导致的概率为%d\n',i,marg.T(2));
%             end
%         end
%     end
% end
% infer_t2=toc;
% fprintf('\n')
% fprintf('推断所有结点所用时间为%d秒\n',infer_t2);

% 
% 
% for k=1:N
%     fprintf('当结点%d发生时，是其他结点发生导致的概率:\n',k)
%     for i=1:N
%         for j=1:N
%             if(connected(i,j)==k)
%                 evidence=cell(1,N);
%                 evidence{k}=1;
%                 [engine,loglik]=enter_evidence(engine,evidence);
%                 marg=marginal_nodes(engine,i);
%                 fprintf('    是结点%d导致的概率为%d\n',i,marg.T(2));
%             end
%         end
%     end
% end
% infer_t2=toc;
% fprintf('\n')
% fprintf('推断所有结点所用时间为%d秒\n',infer_t2);



