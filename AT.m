%% Consensus
[number_user,number_movie]=size(score_matrix);
consensus_matrix=zeros(number_user,number_movie);
for j=1:number_movie
    for k=1:number_user
        temp=0;
        count=0;
       for i=1:number_user
           if score_matrix(k,j)~=0&&score_matrix(i,j)~=0;
             
              temp=temp+(score_matrix(k,j)-score_matrix(i,j))^2;
              count=count+1;
           end
       end
       consensus_matrix(k,j)=temp/count;
    end
    
end
for i=1:6040
    for j=1:3952
        if isnan(consensus_matrix(i,j))==1
            consensus_matrix(i,j)=0;
        end
    end
end

%% Distinctiveness
distinctiveness_matrix=zeros(6040,3952);
for i=1:6040
    for j=1:3952 
        tempnei=tabulate(sim_movies(:,j));
        [N1,N2]=size(tempnei);
        neighbor_movies=tempnei(N1,2);
        [N,index]=sort(sim_movies(:,j),'descend');
        sum=0;
        count=0;
        for k=1:neighbor_movies
        if score_matrix(i,j)~=0&&score_matrix(i,index(k,1))~=0
            sum=sum+(score_matrix(i,j)-score_matrix(i,index(k,1)))^2;
            count=count+1;
        end
            
        end
        if count==0;
            distinctiveness_matrix(i,j)=0;
        else
            distinctiveness_matrix(i,j)=sum/count;
        end
    end
end

for i=1:6040
    for j=1:3952
        if distinctiveness_matrix(i,j)~=0
            distinctiveness_matrix(i,j)=1./distinctiveness_matrix(i,j);
        end
    end
end
%% Societal expectation
Scoietal_E=zeros(3952,1);
for j=1:3952
    I_temp=tabulate(score_matrix(:,j));
    [m,n]=size(I_temp);
    number_r=sum(I_temp(:,2))-I_temp(1,2);
    score_w_temp=0;
    for i=2:m
    h=I_temp(i,2)/number_r;
    score_w_temp=score_w_temp+I_temp(i,1)*h;
    end
    Scoietal_E(j,1)=score_w_temp;
end
%% P or N preference
[number_user,number_movies]=size(score_matrix);
perference_matrix=zeros(number_user,number_movies);
for i=1:number_user
    for j=1:number_movies
        if score_matrix(i,j)~=0
            perference_matrix(i,j)=score_matrix(i,j)-score_w(j,1);
        end
    end
end

