% Q3.3:
%       1. Load point correspondences
%       2. Obtain the correct M2
%       3. Save the correct M2, C2, p1, p2, R and P to q3_3.mat


load q2_1.mat;
load('../data/intrinsics.mat');
load('../data/some_corresp.mat');
[ E ] = essentialMatrix( F, K1, K2 );
[M2s] = camera2(E);
M1 = [eye(3) [0,0,0]'];
C1 = K1 * M1 ;
error = 0;
for i = 1: 4
  M2 = M2s(:,:,i);
  C2 = K2 * M2 ;  
  [ P, err ] = triangulate( C1, pts1, C2, pts2 );
  if all(P(:,3)>0)
      M2 = M2s(:,:,i);
      C2 = K2*M2;
  end
end

p1 = pts1;
p2 = pts2;
