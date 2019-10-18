function  myDFS( dag_gbn, i)
   global visited;
    [N,N]=size(dag_gbn);
    visited(i)=1;
    for j=1:N
        if(dag_gbn(i,j)==1 && visited(j)==0 )
            myDFS(dag_gbn,j)
        end
    end

end

