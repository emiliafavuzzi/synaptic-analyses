//Before starting you will need to change the directory from efavuzzi to yourname
//Make sure that the channel corresponds to what you want to analyze
//Before starting, sample some images to find the best fixed threshold for each channel or set up an automatic threshold

//starts asking your input and output directories for the batch
input = getDirectory("Input directory");
output = getDirectory("Output directory");

Dialog.create("File type");
Dialog.addString("File suffix: ", ".tif", 5);
Dialog.show();
suffix = Dialog.getString();

processFolder(input);
setBatchMode(true);
function processFolder(input) {
	list = getFileList(input);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + list[i]))
			processFolder("" + input + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	};
};
function processFile(input, output, file) {
	open(input + file);
//Start script
saveAs("Tiff", "/Users/efavuzzi/Desktop/output/picture-1.tif");
//start PV (note that this works if you have only one cell, if not add a rectangulare selection
run("Duplicate...", "title=picture1-1.tif duplicate channels=1");
selectWindow("picture1-1.tif");
run("Despeckle");
run("Smooth");
run("Enhance Contrast...", "saturated=0.5");
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
min[2]=55;
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
setOption("BlackBackground", false);
run("Make Binary");
run("Analyze Particles...", "size=10-Infinity show=Masks include");
run("Create Selection");
run("Enlarge...", "enlarge=-2.5");
run("Enlarge...", "enlarge=3");
waitForUser("CHECK ROI");
roiManager("Add");
roiManager("Measure");
run("Fill");
run("Clear Outside");
saveAs("Tiff", "/Users/efavuzzi/Desktop/output/mask1.tif");
close("\\Others");
// PV end
// VGlut2
open("/Users/efavuzzi/Desktop/output/picture-1.tif");
selectWindow("picture-1.tif");
run("Duplicate...", "title=picture1-2.tif duplicate channels=3");
selectWindow("picture1-2.tif");
run("Despeckle");
run("Smooth");
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
min[2]=41;
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
run("Analyze Particles...", "size=0.20-infinity circularity=0.00-1.00 show=Masks");
run("Watershed");
saveAs("Tiff", "/Users/efavuzzi/Desktop/output/mask2.tif");
close("\\Others");
// VGlut2 end
// Homer
open("/Users/efavuzzi/Desktop/output/picture-1.tif");
run("Duplicate...", "title=picture1-4.tif duplicate channels=2");
selectWindow("picture1-4.tif");
run("Despeckle");
run("Smooth");
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
min[2]=37;
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
run("Analyze Particles...", "size=0.10-infinity circularity=0.00-1.00 show=Masks");
run("Watershed");
saveAs("Tiff", "/Users/efavuzzi/Desktop/output/mask3.tif");
close("\\Others");
//Homer end
open("/Users/efavuzzi/Desktop/output/mask2.tif");
open("/Users/efavuzzi/Desktop/output/mask3.tif");
run("Merge Channels...", "c1=mask3.tif c2=mask2.tif create");
run("Stack to RGB");
run("8-bit");
// to be added here to save composite
// select colocalizing pre+post
run("Invert");
run("8-bit");
//run("Threshold...");
setThreshold(130, 255);
run("Convert to Mask");
run("Analyze Particles...", "size=0.1-Infinity show=Masks");
// analysis of particles - need to invert image for analysis
run("Analyze Particles...", "size=0.05-Infinity");
saveAs("Tiff", "/Users/efavuzzi/Desktop/output/prepost.tif");
run("Close All");
// coloc the pre+post w/ somas
open("/Users/efavuzzi/Desktop/output/prepost.tif");
open("/Users/efavuzzi/Desktop/output/mask1.tif");
run("Merge Channels...", "c1=mask1.tif c2=prepost.tif create");
run("Stack to RGB");
run("8-bit");
//run("Threshold...");
setThreshold(10, 255);
run("Convert to Mask");
run("Analyze Particles...", "size=0.00-Infinity show=Masks");
// analysis of particles - need to invert image for analysis
run("Invert");
run("Analyze Particles...", "size=0.00-Infinity summarize");
// create merge for colocalisation
open("/Users/efavuzzi/Desktop/output/mask1.tif");
roiManager("Delete");
run("Close All");
	print("Processing: " + input + file);

}
setBatchMode(false);
print("BATCH COMPLETED!");
