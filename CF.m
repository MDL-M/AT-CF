%% fusion Similar

% Format:a*A-Consine+b*Pearson-(1-a-b)*(A-Consine).(Pearson);

%% Collaborative Filtering
   [m,n]=size(test_matrix);
%预测评分
       predict_score_matrix=zeros(m,1);
       
      for k=1:m
      %要对测试集中的电影做预测评分，先找出对指定电影有评分的用户。
       u_rate=find(score_matrix(:,test_matrix(k,2))~=0);
       u_rate=u_rate';
       [~,num]=size(u_rate);%num=对电影评价过的用户的数目
       %！！！！！！！！计算用户的邻居！！！！！！！！！
        neibor_num=5;
        u_rate_sim=sim_matrix(test_matrix(k,1),u_rate);
       [temp,index1]=sort(u_rate_sim,2,'descend');%降序排列,index1为与指定用户相似的用户的编号
       [~,num1]=size(index1);
       if num1>neibor_num
        neibor=(u_rate(index1(1:neibor_num)));
       else
        neibor=(u_rate(index1));
        neibor_num=num1;
       end
    %预测评分
       sum_score_u=sum(score_matrix(test_matrix(k,1),:),2);
       [~,num2]=size(find(score_matrix(test_matrix(k,1),:)));
       aver_score_u=sum_score_u/num2;
        sum1=0;
        sum2=0;
       for g=1:neibor_num
        sum_score_n=sum(score_matrix(neibor(g),:),2);
        [~,num3]=size(find(score_matrix(neibor(g),:)));
        aver_score_n=sum_score_n/num3;
       
        sum1=sum1+sim_matrix(test_matrix(k,1),neibor(g))*(score_matrix(neibor(g),test_matrix(k,2))-aver_score_n);
        sum2=sum2+sim_matrix(test_matrix(k,1),neibor(g));
       end
       if sum2==0
           predict_score_matrix(k,1)=round(aver_score_u);
       else
           predict_score_matrix(k,1)=round(aver_score_u+sum1/sum2);
         if predict_score_matrix(k,1)>5
            predict_score_matrix(k,1)=5;
          elseif predict_score_matrix(k,1)<1
            predict_score_matrix(k,1)=1;
         end
       end 
  
% for g=1:neibor_num
%    sum1=0;
%    count=0;
%   if score_matrix(neibor(g),test_matrix(k,2))~=0
%       sum1=sum1+sim_matrix(test_matrix(k,1),neibor(g))*score_matrix(neibor(g),test_matrix(k,2));
%       count=count+1;
%   end
%   
% end
% if count==0
%     predict_score_matrix(k,1)=score_w(test_matrix(k,2));
% else
%     predict_score_matrix(k,1)=sum1/count;
% end

     end
% %% 评价指标RMSE MSE
    eval=zeros(m,3);
    eval(:,1)=test_matrix(:,3);
    eval(:,2)=predict_score_matrix(:,1);
    eval(:,3)=abs(test_matrix(:,3)-predict_score_matrix(:,1));
%     k2=itk(1,iter)
%     bb=itk(1,b)
    RMSE=sqrt(eval(:,3)'*eval(:,3)/m)
    MAE=sum(eval(:,3))/m