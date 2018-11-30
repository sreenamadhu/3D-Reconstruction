function [ F ] = sevenpoint( pts1, pts2, M )
% sevenpoint:
%   pts1 - 7x2 matrix of (x,y) coordinates
%   pts2 - 7x2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.2:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save recovered F (either 1 or 3 in cell), M, pts1, pts2 to q2_2.mat

%     Write recovered F and display the output of displayEpipolarF in your writeup


    
    T=[1/M,0,0;0,1/M,0;0,0,1];
    
    %{    
    2. Solving the linear system of equations :
                        [x2x1 x2y1 x2 y2x1 y2y1 y2 x1 y1 1]
    %}
    pts1(:,3)=1;
    pts2(:,3)=1;
    n = 1; 
    ind = randperm(size(pts1,1));
    pts1 = pts1(ind,:);
    pts2 = pts2(ind,:);
    for i = 1: 7
           pts1(i,:) = pts1(i,:)*T;
           pts2(i,:) = pts2(i,:)*T;
           x1=pts1(i,1);
           y1=pts1(i,2);
           x2=pts2(i,1);
           y2=pts2(i,2);
           A(n,:)=[x2*x1 x2*y1 x2 y2*x1 y2*y1 y2 x1 y1 1];
           n=n+1;
    end
    [U,S,V]=svd(A);
    F1 = V(:,9);
    F1=reshape(F1,[3,3])';
    F2 = V(:,8);
    F2 = reshape(F2,[3,3])';
    syms lambda
    eqn = det(F1+lambda*F2) ==0;
    lambda = double(solve(eqn,lambda,'Real',true));
    F={};
    for i = 1:length(lambda)
            F{i} = F1 + lambda(i)*F2;
            [U_1,S_1,V_1]=svd(F{i});
            S_1(3,3) = 0;
            F{i} = U_1*S_1*transpose(V_1);
            F{i} = refineF(F{i},pts1,pts2);
            F{i}=transpose(T)*F{i}*T;
    end
%     save '../results/q2_2.mat' F M pts1 pts2
end

