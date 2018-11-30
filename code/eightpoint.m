function [ F ] = eightpoint( pts1, pts2, M )
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save F, M, pts1, pts2 to q2_1.mat

%     Write F and display the output of displayEpipolarF in your writeup
    %{    
    1. Scaling of data : Dividing each coordinate by M
    %}
    
    T=[1/M,0,0;0,1/M,0;0,0,1];
    
    %{    
    2. Solving the linear system of equations :
                        [x2x1 x2y1 x2 y2x1 y2y1 y2 x1 y1 1]
    %}
    pts1(:,3)=1;
    pts2(:,3)=1;
    n = 1; 
    for i = 1: size(pts1,1)
           pts1(i,:) = pts1(i,:)*T;
           pts2(i,:) = pts2(i,:)*T;
           x1=pts1(i,1);
           y1=pts1(i,2);
           x2=pts2(i,1);
           y2=pts2(i,2);
           A(n,:)=[x1*x2 x1*y2 x1 y1*x2 y1*y2 y1 x2 y2 1];
           n=n+1;
    end
    [U,S,V]=svd(A);
    F = V(:,9);
    F=reshape(F,[3,3])';
    [U_1,S_1,V_1]=svd(F);
    S_1(3,3) = 0;
    F = U_1*S_1*transpose(V_1);
    F = refineF(F,pts1,pts2);
    F=transpose(T)*F*T;
    
    % Displaying the Epipolar F implementation
    im1 = imread('../data/im1.png');
    im2 = imread('../data/im2.png');
    %displayEpipolarF(im1, im2, F);
    
    %save '../results/q2_1.mat' F M pts1 pts2
end



