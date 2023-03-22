 function out = predictPyr(app,X)
 out = [];
            for idx = 1:size(X,2)
                X1 = X(:,idx)./sum(X(:,idx))-app.I_0(:)/sum(app.I_0(:));
                Y = app.pyr2mode*X1(:);
                out = [out Y(:)];
            end      
 end