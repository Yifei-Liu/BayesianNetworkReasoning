clc;
clear all;
close all;
%
fid=fopen('example.txt','r');%���ı����ļ�û�пո�һ��6��
number=0;%��ʾ���ĸ��� 7 ABCDEFG
blank=0;%��ʾ��ǰ�ո������
line=0;%��ʾ��ǰ������
link=0;%��ʾ���ӵĸ����������ӵĸ��������壩

while(1)
    tline=fgetl(fid);
    line=line+1;
    
    if line==1%��ȡ��һ��
        number=str2double(tline);
        small_number=zeros(1,number);%��ʾС�ڵ�ĸ���
        continue;
    end
    if line==2 %��ȡ�ڶ���
        link=str2double(tline);
      	edge_number=zeros(1,link);%��ʾ�ߵĸ���
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
            begin_node(i)=str2double(char(S(i)));%���ӿ�ʼ�Ľڵ㣨����A,B,C,D,E,F,G��
        end
        continue;
    end
    
    if line==6
%         S = regexp(tline, ' ', 'split');
        S=mysplit(tline);
        for i=1:link      % link==10
            end_node(i)=str2double(char(S(i)));%���ӽ����Ľڵ㣨����A,B,C,D,E,F,G��
        end
        
        %link=10
        freq=zeros(number,number);
        prob=zeros(number,number);
        
        degree=zeros(1,number);%��¼ÿ�������ֵĴ���
        
        
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
        ln=1;%��ʾ��
        
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
%% ����֮�������˳��
temp=prob;
[Number,Number]=size(temp);
%Number=7
topo_order=zeros(1,Number);
flag=zeros(1,Number);
topo_count=1;
flag1=zeros(1,Number);
for i=1:Number
    
    if(temp(:,i)==0)
        flag1(i)=2;%%flag1===2��ʾԴ���
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


%% %%%%%%%%%%%%%%%%%%%%%%%%%ģ������

N=number;%���������7
% count=10000;%����1000�Σ�ÿ�ζ��õ�7���ڵ�һ��ֵ
count=1000;
data=zeros(count,N);%1����true,0����false
                    %1000��7��
                    
num=1;
PA=0.75;%���� 
p=0.75;%���� p��ʾ���ȫָ��һ�� ���ı���
k=2;%���� ��ʾ���Ե�ֵ��Ĭ��Ϊ2��1->0.5
% A=1;B=2;C=3;D=4;E=5;F=6;G=7;

[syn_m,syn_n]=size(syn);


while(num<=count)%num��ʾ��num������  
    %record=0;%��¼�ڼ�������
	for i=topo_order
%         if(flag(i)==0)
%             data(num,i)=1;
%         elseif flag1(i)==2 %��ʾԴ�������ʣ�����Դ�
%             r=rand();
%             if r<=PA
%                 data(num,i)=1;%��ʱiΪ1
%             end
        if(flag(i)==0 ||flag1(i)==2)
              r=rand();
                if r<=PA
                    data(num,i)=1;%��ʱiΪ1
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
                         
                         break;%%������Ҫ����
                         
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
        elseif degree(i)==0 %��ʾû�г���
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

data=data+1;%%ֻ������Ļ�

save('data.mat', 'data');
save('topo_order.mat', 'topo_order');

%���Ľ����ʾdata.mat��2��ʾtrue
% 1��ʾfalse

% [m,n]=size(data);
% for i=1:m
%     for j=1:n
%         if (data(i,j)==1)
%             data(i,j)=2;%%2��ʾfalse
%         elseif (data(i,j)==2)
%             data(i,j)=1;%%1��ʾtrue
%         end
%     end
% end
