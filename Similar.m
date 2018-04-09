%% A-Cosine

 
function Sim_user=Similar(sim_3s_matrix,u1,u2)

 
%function P_ab=Rate_both_ab(score_matrix,a,b)
 
temp=sim_3s_matrix(u1,:)&sim_3s_matrix(u2,:);%temp=train(:,u1)&train(:,u2);
P_user=find(temp);%P_ab=find(temp);计算用户u1和u2共同评价过的电影
P_u1=find(sim_3s_matrix(u1,:)~=0);
P_u2=find(sim_3s_matrix(u2,:)~=0);%用户u1、u2评分的电影。
%P_ab=P_ab';%用行向量存储所有评价电影a和b的用户
%end

 
if isempty(P_user)
    Sim_user=0;
else
    [~,temp]=size(P_user);%用户u1和u2共同评价的的用户的数目
    [~,temp_u1]=size(P_u1);
    [~,temp_u2]=size(P_u2);%用户u1、u2评价过的电影数目
    %[~,number_movies]=size(score_matrix);
    sum1=0;
    sum2=0;
    sum3=0;
    for i=1:temp
        [~,m1]=size(find(sim_3s_matrix(u1,:)~=0));%计算该用户u1评价的电影个数
        [~,m2]=size(find(sim_3s_matrix(u2,:)~=0));%计算该用户u2评价的电影个数
        sum_score1=sum(sim_3s_matrix(u1,:),2);%用户u1对所有电影的总评分
        sum_score2=sum(sim_3s_matrix(u2,:),2);%用户u2对所有电影的总评分
        aver_score1=sum_score1/m1;
        aver_score2=sum_score2/m2;
        sum1=sum1+(sim_3s_matrix(u1,P_user(i))-aver_score1)*(sim_3s_matrix(u2,P_user(i))-aver_score2);
    end%计算修正余弦公式的分子
    for j=1:temp_u1
        sum2=sum2+(sim_3s_matrix(u1,P_u1(j))-aver_score1)^2;
    end
    for k=1:temp_u2
        sum3=sum3+(sim_3s_matrix(u2,P_u2(k))-aver_score2)^2;
    end
    if sum2==0||sum3==0
        Sim_user=0;
    else
        Sim_user=sum1/(sqrt(sum2)*sqrt(sum3));
    end
end
%% Pearson
% function coeff = sim_I2( u,v )
% %SIM_I2 此处显示有关此函数的摘要
% %   此处显示详细说明
% if length(u)~=length(v)
%     error('向两维数不相同')
%     return;
% end
% 
% fenzi=sum(u.*v)-(sum(u)*sum(v))/length(u);
% fenmu=sqrt((sum(u.^2)-sum(u)^2/length(u))*(sum(v.^2)-sum(v)^2/length(u)));
% coeff=fenzi/fenmu;
% 
% end