function S = mysplit(tline)
    len=length(tline);
    space_num=0;%��ʾ���ڵĿո������
    %tline='1 34 678 2 4 98'
    %space_num=5;
    for i=1:len
        if(strcmp(tline(i),' ')==1)
            space_num=space_num+1;
        end
    end
    
    n=space_num+1;
    S=cell(1,n);
%  
%     for i=1:n
%         for j=i:len
%             if(strcmp(tline(j),' ')==0)%��ʾ�����,��Ϊ�ո�
%                 S(i)=strcat(S(i),tline(j));
%             else
%                 break;
%             end
%         end
%     end
% end
    
cnt=1;
for i=1:len
    if(strcmp(tline(i),' ')==0)
        S(cnt)=strcat(S(cnt),tline(i));
    elseif(strcmp(tline(i),' ')==1)
        cnt=cnt+1;
    end
end

end
        










