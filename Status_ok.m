display('LISTO!!!')
var = rand(1,10)
for i = 1:10
    display(i)
    plot(1:i,var(1:i))
    pause(.01)
end

cam = webcam;
photo = snapshot(cam);
%imshow(photo);
imwrite(photo,'C:\Users\Onichan\Desktop\photo.jpg');