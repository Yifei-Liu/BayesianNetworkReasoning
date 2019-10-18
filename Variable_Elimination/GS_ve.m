%% ̰������
main;
tic;
dag_gbn=learn_struct_gs(data_trainl',node_sizes);%̰������GS��greedy search���㷨
GS_t2=toc;
fprintf('̰������GS��greedy search���㷨ѵ��%d������%d��������õ�ʱ��Ϊ%d��\n',M,N,GS_t2);
figure;
draw_graph(dag_gbn);
title('�ṹѧϰ��̰�������㷨')

%% MLE �����Ȼ������ѧϰ
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
fprintf('�����Ȼ������ѧϰ����ʱ��Ϊ%d��\n',params_t2);
fprintf('    ѧϰ����������Ϊbnet3\n');
fprintf('\n');
CPT3=cell(1,N);
for i=1:N
      s=struct(bnet3.CPD{i});
CPT3{i}=s.CPT;
end%�鿴����CPTֵ


%% �����鷨�Ĳ���ѧϰ
for i=1:N
    bnet2.CPD{i}=tabular_CPD(bnet2,i,'CPT','unif','prior_type','dirichlet','dirichlet_type','BDeu','dirichlet_weight',priors);
end

tic;
bnet4=bayes_update_params(bnet2,data_trainl');%�����鷨�Ĳ���ѧϰ
update_t2=toc;
fprintf('�����鷨����ѧϰ����ʱ��Ϊ%d��\n',update_t2);
fprintf('    ѧϰ����������Ϊbnet4\n');
CPT4=cell(1,N);
for i=1:N
      s=struct(bnet4.CPD{i});
      CPT4{i}=s.CPT;
end%�鿴�½�bnet4��CPTֵ
fprintf('\n')

%% %%%%%%%%%%%%%%%%%�����ͨ��
global visited;
connected=zeros(N,N);
 for i=1:N%������N=7
   %��ÿ������������Ե�������н��
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
 
%% %%%�ƶ�
%% %%%�ƶ�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ʹ�������Ȼ��ѧϰ������bnet3
engine=var_elim_inf_engine(bnet3);
fs3=zeros(1,N);
for Node3=1:N
    fprintf('Ŀǰ����Ľ��Ϊ���%d\n',Node3);
       tic;
       if(sum(connected(Node3,:))>0)
            for j=1:N
                if connected(Node3,j)~=0
                    evidence=cell(1,N);
                    evidence{Node3}=2;
                    [engine,loglik]=enter_evidence(engine,evidence);
                    marg=marginal_nodes(engine,connected(Node3,j));
                    fprintf('    ���%d ����%d\n',connected(Node3,j),marg.T(2));
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
                    fprintf('    �ǽ��%d���µĸ���Ϊ%d\n',i,marg.T(2));
                end
            end
        end

        fs3(Node3)=toc;
        fprintf('����������õ�ʱ��Ϊ%d',fs3(Node3))
        fprintf('\n\n')
end

fprintf('ʹ��bnet3�ƶ����н�����õ�ƽ��ʱ��Ϊ%d��\n',mean(fs3));
fprintf('ʹ��bnet3�ƶ����н�����õ���ʱ��Ϊ%d��\n',sum(fs3));
fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');

engine=var_elim_inf_engine (bnet4);
fs4=zeros(1,N);
for Node4=1:N
    fprintf('Ŀǰ����Ľ��Ϊ���%d\n',Node4);
       tic;
       if(sum(connected(Node4,:))>0)
            for j=1:N
                if connected(Node4,j)~=0
                    evidence=cell(1,N);
                    evidence{Node4}=2;
                    [engine,loglik]=enter_evidence(engine,evidence);
                    marg=marginal_nodes(engine,connected(Node4,j));
                    fprintf('    ���%d ����%d\n',connected(Node4,j),marg.T(2));
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
                    fprintf('    �ǽ��%d���µĸ���Ϊ%d\n',i,marg.T(2));
                end
            end
        end

        fs4(Node4)=toc;
        fprintf('����������õ�ʱ��Ϊ%d',fs4(Node4))
        fprintf('\n\n')
end

fprintf('ʹ��bnet4�ƶ����н�����õ�ƽ��ʱ��Ϊ%d��\n',mean(fs4));
fprintf('ʹ��bnet4�ƶ����н�����õ���ʱ��Ϊ%d��\n',sum(fs4));
while(1)
    network=input('�����ƶ����õ�����,3��ʾ�����Ȼ��ѧϰ������,4��ʾ�����鷨ѧϰ������(Ĭ��Ϊbnet3)��');
    if(network==3)
            engine=var_elim_inf_engine(bnet3);
    elseif(network==4)
        engine=var_elim_inf_engine(bnet4);
    else
        break;
    end
    while(1)
        node1=input('�����뷢���Ľڵ�ֵ��');
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
                    fprintf('    ���%d ����%d\n',connected(node1,j),marg.T(2));
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
                    fprintf('    �ǽ��%d���µĸ���Ϊ%d\n',i,marg.T(2));
                end
            end
        end

        fs=toc;
        fprintf('����������õ�ʱ��Ϊ%d',fs)
        fprintf('\n\n')
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% for k=1:N
%     fprintf('�����%d����ʱ����������㷢�����µĸ���:\n',k)
%     for i=1:N
%         for j=1:N
%             if(connected(i,j)==k)
%                 evidence=cell(1,N);
%                 evidence{k}=1;
%                 [engine,loglik]=enter_evidence(engine,evidence);
%                 marg=marginal_nodes(engine,i);
%                 fprintf('    �ǽ��%d���µĸ���Ϊ%d\n',i,marg.T(2));
%             end
%         end
%     end
% end
% infer_t2=toc;
% fprintf('\n')
% fprintf('�ƶ����н������ʱ��Ϊ%d��\n',infer_t2);

% 
% 
% for k=1:N
%     fprintf('�����%d����ʱ����������㷢�����µĸ���:\n',k)
%     for i=1:N
%         for j=1:N
%             if(connected(i,j)==k)
%                 evidence=cell(1,N);
%                 evidence{k}=1;
%                 [engine,loglik]=enter_evidence(engine,evidence);
%                 marg=marginal_nodes(engine,i);
%                 fprintf('    �ǽ��%d���µĸ���Ϊ%d\n',i,marg.T(2));
%             end
%         end
%     end
% end
% infer_t2=toc;
% fprintf('\n')
% fprintf('�ƶ����н������ʱ��Ϊ%d��\n',infer_t2);



