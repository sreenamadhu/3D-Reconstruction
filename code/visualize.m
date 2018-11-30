% Q4.2:
% Integrating everything together.
% Loads necessary files from ../data/ and visualizes 3D reconstruction
% using scatter3
 
% Q2.7 - Todo:
% Integrating everything together.
% Loads necessary files from ../data/ and visualizes 3D reconstruction
% using scatter3
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%Loading hand selected points from im1. (x1 and y1)
load('../data/templeCoords.mat');
 
%Loading point correspondences(pts1 and pts2)
load('../data/some_corresp.mat');
 
%Loading intrinsics of the camera matrices (K1 and K2)
load('../data/intrinsics.mat');
 
%Loading images 
im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');
 
% Extrinsic camera matrix(Rotation and translation transformation)
M1 =[eye(3) [0,0,0]'];
 
%Calculating the Fundamental Matrix
M = max(size(im1,1),size(im1,2));
[F] = eightpoint(pts1,pts2,M);
 

%Calculating the point correspondences of the hand picked coordinates
x2=[];
y2=[];
for i = 1:size(x1,1)
    
   [p,q] = epipolarCorrespondence(im1,im2,F,x1(i),y1(i));
   x2=[x2;p];
   y2=[y2;q];
    
end
pts1 = [x1 y1];
pts2=[x2 y2];
%Calculate the best M2 for creating the 3D point. 
[ E ] = essentialMatrix( F, K1, K2 );
[M2s] = camera2(E);
C1 = K1*M1;
for i = 1: 4
  M2 = M2s(:,:,i);
  C2 = K2 * M2 ;  
  [ P, err ] = triangulate( C1, pts1, C2, pts2 );
  if all(P(:,3)>0)
      M2 = M2s(:,:,i);
      C2 = K2*M2;
      P_final = P;
  end
end

P = P_final;
scatter3(P(:,1),P(:,2),P(:,3),'filled');

