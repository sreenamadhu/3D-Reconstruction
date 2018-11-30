function [ P, err ] = triangulate( C1, p1, C2, p2 )
% triangulate:
%       C1 - 3x4 Camera Matrix 1
%       p1 - Nx2 set of points
%       C2 - 3x4 Camera Matrix 2
%       p2 - Nx2 set of points

%       P - Nx3 matrix of 3D coordinates
%       err - scalar of the reprojection error

% Q3.2:
%       Implement a triangulation algorithm to compute the 3d locations
%

%{
K1,K2 - Internal camera Matrices
M1,M2 - External camera matrices
C1 = M1*K1 C2 = M2*K2

C1,C2 - Camera Matrices of camera 1 and camera 2
        3X4.
We assume that the camera matrices are perfect! and have no errors

The reconstruction error isdepend on point correspondes of two images p1 and
p2

x=P*X and x' = P'*X
%}
    
    for pt_num = 1 :size(p1,1) 
        
        x1 = p1(pt_num,1);
        y1 = p1(pt_num,2);
        x2 = p2(pt_num,1);
        y2 = p2(pt_num,2);
       
        A = [x1*C1(3,:) - C1(1,:) ; y1*C1(3,:) - C1(2,:); x2*C2(3,:)-C2(1,:) ; y2*C2(3,:)-C2(2,:)];
        [U,S,V] = svd(A);
        out(pt_num,:) = V(:,end)';
        out(pt_num,:) = out(pt_num,:)./out(pt_num,4);
        
        
    end
    
    P = out(:,1:3);
    % out has shape Nx4 
    P_camera1 = (C1 * out')' ;
    P_camera1 = P_camera1 ./P_camera1(:,3);
    P_camera2 = (C2 * out')' ;
    P_camera2 = P_camera2 ./P_camera2(:,3);
    %P_camera has shape Nx3
    x1 = p1(:,1);
    y1 = p1(:,2);
    x2 = p2(:,1);
    y2 = p2(:,2);    
    x_1_hat = P_camera1(:,1);
    y_1_hat = P_camera1(:,2);
    x_2_hat = P_camera2(:,1);
    y_2_hat = P_camera2(:,2);    
    
    %Distances.....
    d_x1 = (x1-x_1_hat).^2 + (y1 - y_1_hat).^2;
    d_x2 = (x2-x_2_hat).^2 + (y2 - y_2_hat).^2;
    err = sum(sum(d_x1) + sum(d_x2)) ;
end
