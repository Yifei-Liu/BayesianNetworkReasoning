clc;
clear all;
close all;
%
fid=fopen('example.txt','r');%打开文本的文件没有空格，一共6行
number=0;%表示结点的个数 7 ABCDEFG
blank=0;%表示当前空格的数量
line=0;%表示当前的行数
link=0;%表示连接的个数（总连接的个数不具体）

while(1)
    tline=fgetl(fid);
    line=line+1;
    
    if line==1%读取第一行
        number=str2double(tline);
        small_number=zeros(1,number);%表示小节点的个数
        continue;
    end
    if line==2 %读取第二行
        link=str2double(tline);
      	edge_number=zeros(1,link);%表示边的个数
        continue;
    end
    if line==3
%         S = regexp(tline, ' ', 'split');
        S=mysplit(tline);
        for i=1:number
            small_number(i)=str2double(char(S(i)));
        end
        continue;
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if line==4
       % S = regexp(tline, ' ', 'split');
       S=mysplit(tline);
        for i=1:link
            edge_number(i)=str2double(char(S(i)));
        end
        continue;
    end
    
    if line==5
        %S = regexp(tline, ' ', 'split');
         S=mysplit(tline);
        for i=1:link      % link==10
            begin_node(i)=str2double(char(S(i)));%连接开始的节点（大结点A,B,C,D,E,F,G）
        end
        continue;
    end
    
    if line==6
%         S = regexp(tline, ' ', 'split');
        S=mysplit(tline);
        for i=1:link      % link==10
            end_node(i)=str2double(char(S(i)));%连接结束的节点（大结点A,B,C,D,E,F,G）
        end
        
        %link=10
        freq=zeros(number,number);
        prob=zeros(number,number);
        
        degree=zeros(1,number);%记录每个结点出现的次数
        
        
        for i=1:link
            freq(begin_node(i)+1,end_node(i)+1)=edge_number(i)+freq(begin_node(i)+1,end_node(i)+1);
        end
        
        for i=1:number
            for j=1:number
                if sum(freq(i,:))~=0
                    prob(i,j)=freq(i,j)/sum(freq(i,:));
                    if prob(i,j)~=0
                        degree(i)=degree(i)+1;
                    end
                        
                else
                    prob(i,j)=0;
                end
            end
        end
        ln=1;%表示行
        
        for i=1:number
            for j=1:number
                if prob(i,j)~=0
                    
                    syn(ln,1)=i;
                    syn(ln,2)=j;
                    syn(ln,3)=prob(i,j);
                    ln=ln+1;
                end
            end
        end
        
        break;
    end
end
%% 求结点之间的拓扑顺序
temp=prob;
[Number,Number]=size(temp);
%Number=7
topo_order=zeros(1,Number);
flag=zeros(1,Number);
topo_count=1;
flag1=zeros(1,Number);
for i=1:Number
    
    if(temp(:,i)==0)
        flag1(i)=2;%%flag1===2表示源结点
    end
    
end

for i=1:Number
    for j=1:Number
        if( sum(temp(:,j))==0 && flag(j)==0)
            topo_order(topo_count)=j;
            flag(j)=1;
            topo_count=topo_count+1;
            for k=1:Number
                temp(j,k)=0;
            end
        end
    end
end

for i=1:Number
    if(flag(i)==0)
       topo_order(topo_count)=i;
      % flag(i)=1;
       topo_count=topo_count+1;
    end
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%模拟数据

N=number;%在这里等于7
% count=10000;%计算1000次，每次都得到7个节点一个值
count=1000;
data=zeros(count,N);%1代表true,0代表false
                    %1000行7列
                    
num=1;
PA=0.75;%自设 
p=0.75;%自设 p表示如果全指向一个 它的比率
k=2;%自设 表示除以的值，默认为2，1->0.5
% A=1;B=2;C=3;D=4;E=5;F=6;G=7;

[syn_m,syn_n]=size(syn);


while(num<=count)%num表示第num行数据  
    %record=0;%记录第几个概率
	for i=topo_order
%         if(flag(i)==0)
%             data(num,i)=1;
%         elseif flag1(i)==2 %表示源结点求概率，特殊对待
%             r=rand();
%             if r<=PA
%                 data(num,i)=1;%此时i为1
%             end
        if(flag(i)==0 ||flag1(i)==2)
              r=rand();
                if r<=PA
                    data(num,i)=1;%此时i为1
                end
                
                if (data(num,i)==1 && flag(i)==1)
                     r=rand();
                     for place=1:syn_m
                          if(syn(place,1)==i)
%                           for j=place:degree(place)+place-1
%                             if(r<=sum(syn(place:j,3))/k)
%                                  data(num,syn(j,2))=1;
%                             end 
%                           end
                    
                         for j=place: (degree(i)+place-1)
                            if(r<=sum(syn(place:j,3))/k)
                                 data(num,syn(j,2))=1;
                            end 
                         end 
                         
                         break;%%极其重要！！
                         
                    end
                  end
                
            end
        elseif ( degree(i)==1&&data(num,i)==1 &&flag(i)==1)
            r=rand();
            if(r<=p)
                for place=1:syn_m
                    if(syn(place,1)==i)
                        data(num,syn(place,2))=1;
                    end
                end
            end
        elseif degree(i)==0 %表示没有出度
            continue;
        elseif ( degree(i)>1&&data(num,i)==1 &&flag(i)==1)
            r=rand();
            for place=1:syn_m
                if(syn(place,1)==i)
                      for j=place:degree(i)+place-1
                        if(r<=sum(syn(place:j,3))/k)
                             data(num,syn(j,2))=1;
                        end 
                      end
                      break;
                end
            end
        end
    end
    num=num+1;
end

data=data+1;%%只到这里的话

save('data.mat', 'data');
save('topo_order.mat', 'topo_order');

%最后的结果表示data.mat中2表示true
% 1表示false

% [m,n]=size(data);
% for i=1:m
%     for j=1:n
%         if (data(i,j)==1)
%             data(i,j)=2;%%2表示false
%         elseif (data(i,j)==2)
%             data(i,j)=1;%%1表示true
%         end
%     end
% end
