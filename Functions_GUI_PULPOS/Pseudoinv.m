function pyr2mode = Pseudoinv(app,I,sp,sm)
% I = app.I_0;

for idx = 1:size(sp,2)
    sp2(:,idx) = sp(:,idx)/sum(sp(:,idx));%-I(:)/sum(I(:));
    sm2(:,idx) = sm(:,idx)/sum(sm(:,idx));%-I(:)/sum(I(:));
end
    iMat = 0.5*(sp2-sm2)/app.amp_imat;
    pyr2mode = pinv(iMat);
end