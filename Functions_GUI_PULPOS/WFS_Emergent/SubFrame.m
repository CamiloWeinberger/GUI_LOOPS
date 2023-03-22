function frame = SubFrame(im, diameter, x, y)
        
    r    = round(diameter/2);
    pup1 = im(y(1)-r:y(1)+r, x(1)-r:x(1)+r); 
    pup2 = im(y(2)-r:y(2)+r, x(2)-r:x(2)+r); 
    pup3 = im(y(3)-r:y(3)+r, x(3)-r:x(3)+r); 
    pup4 = im(y(4)-r:y(4)+r, x(4)-r:x(4)+r); 
    frame = [pup1, pup2; pup3, pup4];

end