clc;
clear all;
close all;
load data.mat

load topo_order.mat

[M,N]=size(data);
%%data,mat中1为错误，2为正确
ns=ones(1,N);
node_sizes=2*ns;

% order=topo_order;不需要，直接使用topoorder

max_fan_in=1;
data_trainl=data;%这里没有读入训练的数据集，而是由原来的bnets随机生成的数据集data
dag_gbn=zeros(N,N);%有向无环图

fprintf('	main.m已经执行\n')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% xx=input('输入已知情况的结点:');
% xb=input('输入结点的情况(1表示false不发生，2表示true发生):');
% yy=input('输入要推断的结点:');
% yb=input('输入要推断的结点的情况(1表示false不发生，2表示true发生):');
% 
% infer_t1=tic;
% engine=jtree_inf_engine(bnet3);
% evidence{xx}=xb;
% [engine,loglik]=enter_evidence(engine,evidence);%准备把数据加入引擎
% marg=marginal_nodes(engine,yy);
% infer_t2=toc(infer_t1);
% fprintf('联合树引擎推断以上数据所用时间为%d秒\n',infer_t2);
% 
% fprintf('联合树推断所得的概率大小为%d\n',marg.T(yb));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 
% for i=1:N
%     if(sum(connected(i,:))>0)
%         fprintf('当结点%d发生其他结点发生的概率为:\n',i)
%         for j=1:N
%             if(connected(i,j)~=0)           
%                 evidence=cell(1,N);
%                 evidence{i}=1;
%                 [engine,loglik]=enter_evidence(engine,evidence);
%                 marg=marginal_nodes(engine,connected(i,j));
%                 fprintf('    结点%d 概率%d\n',connected(i,j),marg.T(1));
%             end
%         end
%     end
% end










