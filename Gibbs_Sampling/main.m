clc;
clear all;
close all;
load data.mat

load topo_order.mat

[M,N]=size(data);
%%data,mat��1Ϊ����2Ϊ��ȷ
ns=ones(1,N);
node_sizes=2*ns;

% order=topo_order;����Ҫ��ֱ��ʹ��topoorder

max_fan_in=1;
data_trainl=data;%����û�ж���ѵ�������ݼ���������ԭ����bnets������ɵ����ݼ�data
dag_gbn=zeros(N,N);%�����޻�ͼ

fprintf('	main.m�Ѿ�ִ��\n')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% xx=input('������֪����Ľ��:');
% xb=input('����������(1��ʾfalse��������2��ʾtrue����):');
% yy=input('����Ҫ�ƶϵĽ��:');
% yb=input('����Ҫ�ƶϵĽ������(1��ʾfalse��������2��ʾtrue����):');
% 
% infer_t1=tic;
% engine=jtree_inf_engine(bnet3);
% evidence{xx}=xb;
% [engine,loglik]=enter_evidence(engine,evidence);%׼�������ݼ�������
% marg=marginal_nodes(engine,yy);
% infer_t2=toc(infer_t1);
% fprintf('�����������ƶ�������������ʱ��Ϊ%d��\n',infer_t2);
% 
% fprintf('�������ƶ����õĸ��ʴ�СΪ%d\n',marg.T(yb));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 
% for i=1:N
%     if(sum(connected(i,:))>0)
%         fprintf('�����%d����������㷢���ĸ���Ϊ:\n',i)
%         for j=1:N
%             if(connected(i,j)~=0)           
%                 evidence=cell(1,N);
%                 evidence{i}=1;
%                 [engine,loglik]=enter_evidence(engine,evidence);
%                 marg=marginal_nodes(engine,connected(i,j));
%                 fprintf('    ���%d ����%d\n',connected(i,j),marg.T(1));
%             end
%         end
%     end
% end










