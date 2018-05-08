% this function solves the odometry calibration problem
% given a measurement matrix Z.
% We assume that the information matrix is the identity
% for each of the measurements
% Every row of the matrix contains
% z_i = [u'x, u'y, u'theta, ux, uy, ytheta]
% Z:	The measurement matrix
% X:	the calibration matrix

% returns the correction matrix X
function X = ls_calibrate_odometry(Z)
  % initial solution (the identity transformation)
  X = eye(3); 

  % initialize H and b of the linear system
  H = zeros(9);
  b = zeros(9,1);
  omega = eye(3);
 
  % loop through the measurements and update H and b
  % You may call the functions error_function and jacobian, see below
  % We assume that the information matrix is the identity.
  for i=1:size(Z,1)
	H = H + jacobian(i,Z)'*omega*jacobian(i,Z);
	b = b + jacobian(i,Z)'*omega'*error_function(i,X,Z);
  endfor

  % solve and update the solution
  dX = -H\b;
  X = X + reshape(dX,3,3)';
end

% this function computes the error of the i^th measurement in Z
% given the calibration parameters
% i:	the number of the measurement
% X:	the actual calibration parameters
% Z:	the measurement matrix, each row contains first the scan-match result
%       and then the motion reported by odometry
% e:	the error of the ith measurement
function e = error_function(i, X, Z)
  % ompute the error of each measurement
  e = Z(i,1:3)' - X * Z(i,4:6)';
end

% derivative of the error function for the ith measurement in Z
% i:	the measurement number
% Z:	the measurement matrix
% J:	the jacobian of the ith measurement
function J = jacobian(i, Z)
  % compute the Jacobian
  u = Z(i,4:6);
  J = -[u, zeros(1,6); 
        zeros(1,3), u, zeros(1,3); 
        zeros(1,6), u];
end