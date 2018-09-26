function [x,y,z] = wgs2xyz(lam,phi,h)

% WGS2XYZ   Converts lam(longitude) phi(latitude) ellipsoidal coordinates
%           from WGS-84 to ECEF cartesian coordinates
%           lam, phi, h can be vectors
%
%           Call: [x,y,z] = wgs2xyz(longitude,latitude,h)
%                         lon, lat in decimal degrees
%                         h in meters above ellipsoid

% semimajor and semiminor axis for WGS-84
a = 6378137.0;
b = 6356752.314;
f = 1.0/298.257222101;
ee = 2*f - f^2;

% degrees to radians
lam = lam.*pi/180;
phi = phi.*pi/180;

% radius of curvature in prime vertical
N = a ./ sqrt(1-(sin(phi)).^2.*ee);
%N = a^2 / sqrt((cos(phi)).^2*a^2 + (sin(phi)).^2*b^2);

% make sure all are column vectors
lam = lam(:); phi = phi(:); h = h(:);
N = N(:);

x = cos(phi).*cos(lam).*(N+h);
y = cos(phi).*sin(lam).*(N+h);
z = sin(phi).*(N.*(b^2/a^2) + h);