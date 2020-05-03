
//Start script
roiManager("Delete");
saveAs("Tiff", "/Users/efavuzzi/Desktop/output/picture-1.tif");
// Pulls DAPI for layer selection
open("/Users/efavuzzi/Desktop/output/picture-1.tif");
selectWindow("picture-1.tif");
run("Duplicate...", "title=picture1-2.tif duplicate channels=1");
selectWindow("picture1-2.tif");
//setTool("polygon") > define your ROI (e.g S1)
waitForUser("click 'OK'");
roiManager("Add");
open("/Users/efavuzzi/Desktop/output/picture-1.tif");
selectWindow("picture-1.tif");
run("Duplicate...", "title=picture1-1.tif duplicate channels=2");
selectWindow("picture1-1.tif");
roiManager("Select", 0);
run("Clear Outside");
roiManager("Measure");
run("RGB Color");
run("Color Threshold...");
min=newArray(3);
max=newArray(3);
filter=newArray(3);
a=getTitle();
run("HSB Stack");
run("Convert Stack to Images");
selectWindow("Hue");
rename("0");
selectWindow("Saturation");
rename("1");
selectWindow("Brightness");
rename("2");
min[0]=0;
max[0]=255;
filter[0]="pass";
min[1]=0;
max[1]=255;
filter[1]="pass";
min[2]=123;
max[2]=255;
filter[2]="pass";
for (i=0;i<3;i++){
  selectWindow(""+i);
  setThreshold(min[i], max[i]);
  run("Convert to Mask");
  if (filter[i]=="stop")  run("Invert");
}
imageCalculator("AND create", "0","1");
imageCalculator("AND create", "Result of 0","2");
for (i=0;i<3;i++){
  selectWindow(""+i);
  close();
}
selectWindow("Result of 0");
close();
selectWindow("Result of Result of 0");
rename(a);
// Colour Thresholding-------------
run("Watershed");
run("Analyze Particles...", "size=25-infinity circularity=0.00-1.00 show=Outlines display summarize");
saveAs("Tiff", "/Users/efavuzzi/Desktop/output/mask1.tif");
close("\\Others");
roiManager("Measure");
close("\\Others");
