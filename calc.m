function v = calc(H,i,j)

v = [H(i,1)*H(j,1), H(i,1)*H(j,2)+H(i,2)*H(j,1), H(i,2)*H(j,2), H(i,3)*H(j,1)+H(i,1)*H(j,3), H(i,3)*H(j,2)+H(i,2)*H(j,3), H(i,3)*H(j,3);];